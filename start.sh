#!/usr/bin/env bash

# ==============================================================================
# Solworld Server All-in-One Startup Script (Full Automation Edition)
# ==============================================================================
# 功能:
# 1. Mise 环境初始化 (Java 21 自动安装)
# 2. Fabric 服务端核心自动安装 (适配 pack.toml 版本)
# 3. Packwiz 自动同步 (自动拉取/更新 Mods & Configs)
# 4. 内存动态调优 (支持 ZRAM & 物理内存识别)
# 5. Tmux 后台运行 & 崩溃自愈 & 日志归档
# ==============================================================================

SESSION_NAME="solworld"
JAR_NAME="server.jar"
BOOTSTRAP_JAR="packwiz-installer-bootstrap.jar"
FABRIC_INSTALLER="fabric-installer.jar"
LOG_DIR="./logs/archive"
MAX_LOG_RETAIN=30
RESTART_DELAY=10

# --- 1. 基础环境检查 ---
if ! command -v mise &> /dev/null; then
    echo "错误: 未检测到 mise。请先安装 mise (https://mise.jdx.dev/)"
    exit 1
fi

if ! command -v tmux &> /dev/null; then
    echo "正在安装 tmux..."
    sudo pacman -S --noconfirm tmux || { echo "安装失败，请手动执行 sudo pacman -S tmux"; exit 1; }
fi

# --- 2. Mise & Java 环境初始化 ---
echo "--- 正在初始化 Java 环境 ---"
eval "$(mise activate bash)"
mise install java@openjdk-21 -q
mise use --global java@openjdk-21

# --- 3. 自动安装/检查服务端核心 ---
install_server_core() {
    if [[ ! -f "$JAR_NAME" ]]; then
        echo "--- 未检测到 server.jar，正在自动安装 Fabric 服务端 ---"
        
        # 从 pack.toml 读取版本信息 (如果不存在则使用默认值)
        local mc_ver=$(grep "minecraft =" pack.toml | cut -d'"' -f2 || echo "1.21.1")
        local fabric_ver=$(grep "fabric =" pack.toml | cut -d'"' -f2 || echo "0.16.7")
        
        echo "目标版本: Minecraft $mc_ver, Fabric $fabric_ver"
        
        # 下载 Fabric Installer
        wget -q -O "$FABRIC_INSTALLER" https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
        
        # 执行安装
        java -jar "$FABRIC_INSTALLER" server -mcversion "$mc_ver" -loader "$fabric_ver" -downloadMinecraft
        
        # 重命名
        if [[ -f "fabric-server-launch.jar" ]]; then
            mv fabric-server-launch.jar "$JAR_NAME"
            echo "✅ Fabric 服务端安装完成。"
        else
            echo "❌ 安装失败: 未生成 fabric-server-launch.jar"
            exit 1
        fi
        
        # 处理 EULA
        if [[ ! -f "eula.txt" ]]; then
            echo "eula=true" > eula.txt
            echo "✅ 已自动同意 EULA。"
        fi
        
        # 清理
        rm -f "$FABRIC_INSTALLER"
    fi
}

# --- 4. Packwiz 同步 ---
sync_mods() {
    echo "--- 正在同步 Modpack (Packwiz) ---"
    if [[ ! -f "$BOOTSTRAP_JAR" ]]; then
        wget -q -O "$BOOTSTRAP_JAR" https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
    fi
    # 同步本地 mods 和配置
    java -jar "$BOOTSTRAP_JAR" -no-gui -s server pack.toml
}

# --- 5. 内存自动调优 ---
calculate_memory() {
    local total_mem=$(free -m | awk '/^Mem:/{print $2}')
    local zram_check=$(zramctl --noheadings --output NAME 2>/dev/null | wc -l)
    
    local reserved=1536 
    if [ "$total_mem" -lt 4096 ]; then reserved=1024; fi
    
    local xmx=$((total_mem - reserved))
    if [ "$zram_check" -gt 0 ]; then
        xmx=$((total_mem - 800))
    fi

    [ "$xmx" -lt 2048 ] && xmx=2048
    echo "$xmx"
}

# --- 6. 核心运行逻辑 ---
run_server() {
    mkdir -p "$LOG_DIR"
    
    while true; do
        # 依次执行：安装核心 -> 同步插件 -> 启动
        install_server_core
        sync_mods

        MEM_MB=$(calculate_memory)
        # Aikar's 高性能参数
        JAVA_OPTS="-Xms${MEM_MB}M -Xmx${MEM_MB}M \
        -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
        -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
        -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
        -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
        -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
        -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
        -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 启动 Solworld (Memory: ${MEM_MB}M)..."
        
        if [[ -f "logs/latest.log" ]]; then
            local timestamp=$(date '+%Y%m%d_%H%M%S')
            mv "logs/latest.log" "$LOG_DIR/server_$timestamp.log"
            gzip "$LOG_DIR/server_$timestamp.log"
            find "$LOG_DIR" -name "*.gz" -mtime +$MAX_LOG_RETAIN -delete
        fi

        java $JAVA_OPTS -jar "$JAR_NAME" nogui
        
        local exit_code=$?
        if [ $exit_code -eq 0 ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 服务器已正常关闭。"
            break
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] 异常退出 (Exit Code: $exit_code)，${RESTART_DELAY}秒后重启..."
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
        echo "查看: tmux attach -t $SESSION_NAME"
    else
        echo "🚀 正在开启全自动初始化并后台启动 Solworld..."
        eval "$(mise activate bash)"
        mise install java@openjdk-21 -q
        
        tmux new-session -d -s "$SESSION_NAME" "bash $0 run"
        echo "✅ 任务已提交至后台 Tmux 会话！"
        echo "--------------------------------------------------"
        echo "首次运行会执行以下全自动化流程："
        echo "1. Mise 安装 Java 21"
        echo "2. 自动下载 Fabric 核心并同意 EULA"
        echo "3. Packwiz 自动拉取全量 Mod 和配置"
        echo "4. 动态分配内存并启动游戏"
        echo "--------------------------------------------------"
        echo "指令: tmux attach -t $SESSION_NAME"
    fi
fi
