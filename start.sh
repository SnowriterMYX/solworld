#!/usr/bin/env bash

# ==============================================================================
# Solworld Server All-in-One Startup Script (Fixed Launcher Logic)
# ==============================================================================

SESSION_NAME="solworld"
# 更改为 fabric 默认的启动文件名，避免覆盖原版 server.jar
LAUNCH_JAR="fabric-server-launch.jar"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
FABRIC_INSTALLER="fabric-installer.jar"
LOG_DIR="./logs/archive"
MAX_LOG_RETAIN=30
RESTART_DELAY=10

# --- 0. 通用工具函数 ---
detect_distro() {
    local distro="Unknown"
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        distro="${PRETTY_NAME:-$NAME}"
    fi
    echo "$distro"
}

run_as_root() {
    if [[ "$EUID" -eq 0 ]]; then
        "$@"
        return $?
    fi
    if command -v sudo &> /dev/null; then
        sudo "$@"
        return $?
    fi
    return 1
}

ensure_tmux() {
    if command -v tmux &> /dev/null; then
        return 0
    fi

    local distro
    distro=$(detect_distro)
    echo "正在安装 tmux... (检测到: $distro)"

    if command -v pacman &> /dev/null; then
        run_as_root pacman -S --noconfirm tmux || { echo "安装失败，请手动执行: pacman -S tmux"; exit 1; }
    elif command -v apt-get &> /dev/null; then
        run_as_root apt-get update && run_as_root apt-get install -y tmux || { echo "安装失败，请手动执行: apt-get install tmux"; exit 1; }
    elif command -v dnf &> /dev/null; then
        run_as_root dnf install -y tmux || { echo "安装失败，请手动执行: dnf install tmux"; exit 1; }
    elif command -v yum &> /dev/null; then
        run_as_root yum install -y tmux || { echo "安装失败，请手动执行: yum install tmux"; exit 1; }
    elif command -v zypper &> /dev/null; then
        run_as_root zypper --non-interactive install tmux || { echo "安装失败，请手动执行: zypper install tmux"; exit 1; }
    else
        echo "未识别的发行版/包管理器，无法自动安装 tmux。请手动安装后重试。"
        exit 1
    fi
}

sha256() {
    if command -v sha256sum &> /dev/null; then
        sha256sum "$@"
        return $?
    fi
    if command -v shasum &> /dev/null; then
        shasum -a 256 "$@"
        return $?
    fi
    return 1
}

# --- 1. 基础环境检查 ---
if ! command -v mise &> /dev/null; then
    echo "错误: 未检测到 mise。请先安装 mise (https://mise.jdx.dev/)"
    exit 1
fi

ensure_tmux

# --- 2. Mise & Java 环境初始化 ---
eval "$(mise activate bash)"
mise install java@openjdk-21 -q
mise use --global java@openjdk-21

# --- 3. 自动安装服务端核心 ---
install_server_core() {
    # 检查启动器是否存在
    if [[ ! -f "$LAUNCH_JAR" ]]; then
        echo "--- 正在安装 Fabric 服务端 (1.21.1) ---"
        local mc_ver=$(grep "minecraft =" pack.toml | cut -d'"' -f2 || echo "1.21.1")
        local fabric_ver=$(grep "fabric =" pack.toml | cut -d'"' -f2 || echo "0.16.7")
        
        wget -q -O "$FABRIC_INSTALLER" https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
        
        # 安装。这会生成 fabric-server-launch.jar 和一个原版的 server.jar
        java -jar "$FABRIC_INSTALLER" server -mcversion "$mc_ver" -loader "$fabric_ver" -downloadMinecraft
        
        if [[ ! -f "$LAUNCH_JAR" ]]; then
            echo "❌ Fabric 安装失败！未找到 $LAUNCH_JAR"
            exit 1
        fi
        
        [[ ! -f "eula.txt" ]] && echo "eula=true" > eula.txt
        rm -f "$FABRIC_INSTALLER"
        echo "✅ Fabric 服务端核心准备就绪。"
    fi
}

# --- 4. Packwiz 安全同步 ---
backup_on_update() {
    local hash_file=".pack_hash"
    local current_hash=""

    local files=()
    [[ -f "pack.toml" ]] && files+=("pack.toml")
    [[ -f "index.toml" ]] && files+=("index.toml")
    if [[ ${#files[@]} -eq 0 ]]; then
        return 0 # 没有核心索引就不折腾了
    fi

    if ! current_hash=$(sha256 "${files[@]}" 2>/dev/null | sha256 | awk '{print $1}'); then
        echo "⚠️  无法计算哈希（缺少 sha256sum/shasum），跳过更新前备份。"
        return 0
    fi

    local do_backup=false
    if [[ ! -f "$hash_file" ]]; then
        do_backup=true
    else
        local last_hash=$(cat "$hash_file")
        if [[ "$current_hash" != "$last_hash" ]]; then
            do_backup=true
        fi
    fi

    if [ "$do_backup" = true ]; then
        echo "🔄 检测到 pack.toml 变更，正在执行更新前备份..."
        local backup_dir="./backups/pre_update"
        mkdir -p "$backup_dir"
        local timestamp=$(date '+%Y%m%d_%H%M%S')
        local backup_file="$backup_dir/backup_$timestamp.tar.gz"

        # 备份关键目录，忽略非关键错误
        tar -czf "$backup_file" mods config pack.toml index.toml 2>/dev/null || true
        
        echo "✅ 备份完成: $backup_file"
        echo "$current_hash" > "$hash_file"
        
        # 清理旧备份 (保留最近 5 个)
        find "$backup_dir" -name "backup_*.tar.gz" -type f -printf "%T@ %p\n" | sort -nr | tail -n +6 | cut -d' ' -f2- | xargs -r rm
    fi
}

sync_mods() {
    backup_on_update
    echo "--- 正在同步资源 (Packwiz) ---"
    if [[ ! -f "$BOOTSTRAP_JAR" ]]; then
        wget -q -O "$BOOTSTRAP_JAR" https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
    fi
    
    java -jar "$BOOTSTRAP_JAR" -no-gui -s server pack.toml
    local sync_status=$?
    
    if [ $sync_status -ne 0 ]; then
        echo "❌ [关键错误] Packwiz 同步失败！"
        echo "为了保护存档，服务器将不会启动。1分钟后重试..."
        sleep 60
        return 1
    fi
    return 0
}

# --- 5. 内存自动调优 ---
calculate_memory() {
    local total_mem=$(free -m | awk '/^Mem:/{print $2}')
    local zram_check=$(zramctl --noheadings --output NAME 2>/dev/null | wc -l)
    local reserved=1536 
    [ "$total_mem" -lt 4096 ] && reserved=1024
    local xmx=$((total_mem - reserved))
    [ "$zram_check" -gt 0 ] && xmx=$((total_mem - 800))
    [ "$xmx" -lt 2048 ] && xmx=2048
    echo "$xmx"
}

# --- 6. 核心运行逻辑 ---
run_server() {
    mkdir -p "$LOG_DIR"
    while true; do
        install_server_core
        if ! sync_mods; then continue; fi

        MEM_MB=$(calculate_memory)
        JAVA_OPTS="-Xms${MEM_MB}M -Xmx${MEM_MB}M \
        -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
        -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
        -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
        -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
        -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
        -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
        -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

        echo "[$(date '+%H:%M:%S')] 启动 Solworld (Memory: ${MEM_MB}M)..."
        
        if [[ -f "logs/latest.log" ]]; then
            local timestamp=$(date '+%Y%m%d_%H%M%S')
            mv "logs/latest.log" "$LOG_DIR/server_$timestamp.log"
            gzip "$LOG_DIR/server_$timestamp.log"
            find "$LOG_DIR" -name "*.gz" -mtime +$MAX_LOG_RETAIN -delete
        fi

        # 运行引导程序
        java $JAVA_OPTS -jar "$LAUNCH_JAR" nogui
        
        local exit_code=$?
        if [ $exit_code -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器已正常关闭。"
            break
        else
            echo "[$(date '+%H:%M:%S')] 异常退出 (Exit Code: $exit_code)，${RESTART_DELAY}秒后重启..."
            sleep $RESTART_DELAY
        fi
    done
}

# --- 7. 启动入口 ---
if [ "$1" == "run" ]; then
    run_server
else
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        echo "Solworld 已在后台运行。"
    else
        echo "🚀 正在后台启动 Solworld..."
        eval "$(mise activate bash)"
        mise install java@openjdk-21 -q
        tmux new-session -d -s "$SESSION_NAME" "bash $0 run"
        echo "✅ 任务已提交至后台 Tmux！"
        echo "指令: tmux attach -t $SESSION_NAME"
    fi
fi
