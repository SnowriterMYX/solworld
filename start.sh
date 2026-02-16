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

# 临时对照测试：每次同步后强制禁用这些 MOD（可随时恢复）
FORCED_DISABLED_JARS=(
    "carryon-fabric-1.21.1-2.2.4.4.jar"
)

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

# --- 4.1 自动禁用未索引 MOD ---
prune_unindexed_mods() {
    if [[ ! -f "index.toml" ]]; then
        echo "⚠️  未找到 index.toml，跳过未索引 MOD 清理。"
        return 0
    fi

    declare -A allowed=()

    # 允许所有被 index.toml 直接索引的 mods/ 文件
    while IFS= read -r file_path; do
        [[ -n "$file_path" ]] && allowed["$file_path"]=1
    done < <(awk -F'"' '/^file = "mods\// {print $2}' index.toml)

    # 允许被索引的 .pw.toml 中声明的 jar 文件
    while IFS= read -r pw_meta; do
        [[ -f "$pw_meta" ]] || continue
        local jar_name
        jar_name=$(awk -F'"' '/^filename = "/ {print $2; exit}' "$pw_meta")
        if [[ -n "$jar_name" ]]; then
            allowed["mods/$jar_name"]=1
        fi
    done < <(awk -F'"' '/^file = "mods\/.*\.pw\.toml"/ {print $2}' index.toml)

    local disabled_dir="mods/_disabled"
    mkdir -p "$disabled_dir"
    local moved_count=0

    # 仅处理 jar，避免误动其他资源文件
    while IFS= read -r jar_path; do
        if [[ -z "${allowed[$jar_path]:-}" ]]; then
            local base_name
            base_name=$(basename "$jar_path")
            local dest_path="$disabled_dir/$base_name"
            if [[ -e "$dest_path" ]]; then
                dest_path="$disabled_dir/${base_name%.jar}-$(date '+%Y%m%d_%H%M%S').jar"
            fi
            mv "$jar_path" "$dest_path"
            echo "🛑 未索引 MOD 已禁用: $jar_path -> $dest_path"
            moved_count=$((moved_count + 1))
        fi
    done < <(find mods -maxdepth 1 -type f -name "*.jar" -print)

    if [[ $moved_count -eq 0 ]]; then
        echo "✅ 未发现未索引的 MOD。"
    fi
}

force_disable_selected_mods() {
    local disabled_dir="mods/_disabled"
    mkdir -p "$disabled_dir"
    local moved_count=0

    for jar_name in "${FORCED_DISABLED_JARS[@]}"; do
        local mod_path="mods/$jar_name"
        if [[ -f "$mod_path" ]]; then
            local dest_path="$disabled_dir/$jar_name"
            if [[ -e "$dest_path" ]]; then
                dest_path="$disabled_dir/${jar_name%.jar}-$(date '+%Y%m%d_%H%M%S').jar"
            fi
            mv "$mod_path" "$dest_path"
            echo "🛑 已按测试策略禁用 MOD: $mod_path -> $dest_path"
            moved_count=$((moved_count + 1))
        fi
    done

    if [[ $moved_count -eq 0 ]]; then
        echo "✅ 强制禁用清单中的 MOD 当前已处于禁用状态。"
    fi
}

# --- 5. 内存与 GC 自动调优 ---
get_total_physical_memory_mb() {
    local total_kb=""
    if [[ -r /proc/meminfo ]]; then
        total_kb=$(awk '/MemTotal:/{print $2; exit}' /proc/meminfo)
    fi
    if [[ -z "$total_kb" ]] && command -v free &> /dev/null; then
        total_kb=$(free -k | awk '/^Mem:/{print $2}')
    fi
    [[ "$total_kb" =~ ^[0-9]+$ ]] || total_kb=0
    echo $((total_kb / 1024))
}

# 仅使用物理内存数据（不计算 swap/虚拟内存）
get_available_physical_memory_mb() {
    local avail_kb=""
    if [[ -r /proc/meminfo ]]; then
        avail_kb=$(awk '/MemAvailable:/{print $2; exit}' /proc/meminfo)
        if [[ -z "$avail_kb" ]]; then
            # 兼容极旧内核：近似可用物理内存，不含 swap
            local mem_free_kb cached_kb sreclaimable_kb
            mem_free_kb=$(awk '/MemFree:/{print $2; exit}' /proc/meminfo)
            cached_kb=$(awk '/^Cached:/{print $2; exit}' /proc/meminfo)
            sreclaimable_kb=$(awk '/SReclaimable:/{print $2; exit}' /proc/meminfo)
            [[ "$mem_free_kb" =~ ^[0-9]+$ ]] || mem_free_kb=0
            [[ "$cached_kb" =~ ^[0-9]+$ ]] || cached_kb=0
            [[ "$sreclaimable_kb" =~ ^[0-9]+$ ]] || sreclaimable_kb=0
            avail_kb=$((mem_free_kb + cached_kb + sreclaimable_kb))
        fi
    fi
    if [[ -z "$avail_kb" ]] && command -v free &> /dev/null; then
        # free 的 available 列也是物理可用内存估算，不包含 swap
        avail_kb=$(free -k | awk '/^Mem:/{print $7}')
    fi
    [[ "$avail_kb" =~ ^[0-9]+$ ]] || avail_kb=0
    echo $((avail_kb / 1024))
}

get_cgroup_available_memory_mb() {
    local limit_bytes=""
    local usage_bytes=""

    if [[ -r /sys/fs/cgroup/memory.max && -r /sys/fs/cgroup/memory.current ]]; then
        # cgroup v2
        limit_bytes=$(cat /sys/fs/cgroup/memory.max)
        usage_bytes=$(cat /sys/fs/cgroup/memory.current)
        if [[ "$limit_bytes" == "max" ]]; then
            echo "-1"
            return 0
        fi
    elif [[ -r /sys/fs/cgroup/memory/memory.limit_in_bytes && -r /sys/fs/cgroup/memory/memory.usage_in_bytes ]]; then
        # cgroup v1
        limit_bytes=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
        usage_bytes=$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes)
    else
        echo "-1"
        return 0
    fi

    [[ "$limit_bytes" =~ ^[0-9]+$ ]] || { echo "-1"; return 0; }
    [[ "$usage_bytes" =~ ^[0-9]+$ ]] || usage_bytes=0

    # 兼容 cgroup v1 “无限制”哨兵值（非常大的整数）
    if [ "$limit_bytes" -ge 1152921504606846976 ]; then
        echo "-1"
        return 0
    fi

    local remain_bytes=$((limit_bytes - usage_bytes))
    [ "$remain_bytes" -lt 0 ] && remain_bytes=0
    echo $((remain_bytes / 1024 / 1024))
}

get_effective_available_memory_mb() {
    local host_avail_mb cgroup_avail_mb
    host_avail_mb=$(get_available_physical_memory_mb)
    cgroup_avail_mb=$(get_cgroup_available_memory_mb)

    if [[ "$host_avail_mb" -le 0 ]]; then
        host_avail_mb=$(get_total_physical_memory_mb)
    fi
    [[ "$host_avail_mb" -gt 0 ]] || host_avail_mb=4096

    if [[ "$cgroup_avail_mb" -ge 0 && "$cgroup_avail_mb" -lt "$host_avail_mb" ]]; then
        echo "$cgroup_avail_mb"
    else
        echo "$host_avail_mb"
    fi
}

calculate_max_heap() {
    local avail_mb="${1:-}"
    if [[ -z "$avail_mb" ]]; then
        avail_mb=$(get_effective_available_memory_mb)
    fi

    local min_heap_mb="${SOLWORLD_MIN_HEAP_MB:-2048}"
    local max_heap_mb="${SOLWORLD_MAX_HEAP_MB:-16384}"
    local reserved_mb="${SOLWORLD_RESERVED_MB:-2048}"
    local heap_percent="${SOLWORLD_HEAP_PERCENT:-80}"
    local hard_floor_mb="${SOLWORLD_HARD_FLOOR_MB:-512}"

    [[ "$min_heap_mb" =~ ^[0-9]+$ ]] || min_heap_mb=2048
    [[ "$max_heap_mb" =~ ^[0-9]+$ ]] || max_heap_mb=16384
    [[ "$reserved_mb" =~ ^[0-9]+$ ]] || reserved_mb=2048
    [[ "$heap_percent" =~ ^[0-9]+$ ]] || heap_percent=80
    [[ "$hard_floor_mb" =~ ^[0-9]+$ ]] || hard_floor_mb=512

    [ "$heap_percent" -lt 50 ] && heap_percent=50
    [ "$heap_percent" -gt 95 ] && heap_percent=95
    [ "$hard_floor_mb" -lt 256 ] && hard_floor_mb=256
    [ "$max_heap_mb" -lt "$min_heap_mb" ] && max_heap_mb="$min_heap_mb"
    [ "$avail_mb" -le 0 ] && avail_mb=4096

    # 策略：物理可用内存百分比与固定预留取更保守者，避免在低内存下超配。
    local by_percent=$((avail_mb * heap_percent / 100))
    local by_reserved=$((avail_mb - reserved_mb))
    local xmx="$by_percent"

    if [ "$by_reserved" -gt 0 ] && [ "$by_reserved" -lt "$xmx" ]; then
        xmx="$by_reserved"
    fi

    if [ "$xmx" -lt "$hard_floor_mb" ]; then
        xmx="$hard_floor_mb"
    fi

    # 仅在“预留后仍有余量”时尝试满足期望最小堆，防止低内存强行抬高 Xmx。
    if [ "$by_reserved" -ge "$min_heap_mb" ] && [ "$xmx" -lt "$min_heap_mb" ]; then
        xmx="$min_heap_mb"
    fi

    [ "$xmx" -lt 256 ] && xmx=256
    [ "$xmx" -gt "$max_heap_mb" ] && xmx="$max_heap_mb"
    [ "$xmx" -gt "$avail_mb" ] && xmx="$avail_mb"
    [ "$xmx" -lt 128 ] && xmx=128
    echo "$xmx"
}

calculate_soft_heap() {
    local xmx_mb="$1"
    local soft_heap_mb="${SOLWORLD_SOFT_HEAP_MB:-6144}"
    [[ "$soft_heap_mb" =~ ^[0-9]+$ ]] || soft_heap_mb=6144
    [ "$soft_heap_mb" -lt 512 ] && soft_heap_mb=512
    [ "$soft_heap_mb" -gt "$xmx_mb" ] && soft_heap_mb="$xmx_mb"
    echo "$soft_heap_mb"
}

calculate_initial_heap() {
    local soft_mb="$1"
    local xmx_mb="$2"
    local xms_mb="${SOLWORLD_INIT_HEAP_MB:-1024}"
    [[ "$xms_mb" =~ ^[0-9]+$ ]] || xms_mb=1024
    [ "$xms_mb" -lt 512 ] && xms_mb=512
    [ "$xms_mb" -gt "$soft_mb" ] && xms_mb="$soft_mb"
    [ "$xms_mb" -gt "$xmx_mb" ] && xms_mb="$xmx_mb"
    echo "$xms_mb"
}

java_major_version() {
    local major
    major=$(java -version 2>&1 | awk -F'[\".]' '/version/ { if ($2 == "1") print $3; else print $2; exit }')
    [[ "$major" =~ ^[0-9]+$ ]] || major=0
    echo "$major"
}

# --- 6. 核心运行逻辑 ---
run_server() {
    mkdir -p "$LOG_DIR"
    while true; do
        install_server_core
        if ! sync_mods; then continue; fi
        prune_unindexed_mods
        force_disable_selected_mods

        local mem_total_mb mem_avail_mb cgroup_avail_mb
        mem_total_mb=$(get_total_physical_memory_mb)
        mem_avail_mb=$(get_effective_available_memory_mb)
        cgroup_avail_mb=$(get_cgroup_available_memory_mb)

        MEM_XMX_MB=$(calculate_max_heap "$mem_avail_mb")
        MEM_SOFT_MB=$(calculate_soft_heap "$MEM_XMX_MB")
        MEM_XMS_MB=$(calculate_initial_heap "$MEM_SOFT_MB" "$MEM_XMX_MB")

        local java_major
        java_major=$(java_major_version)
        local z_uncommit_delay_s="${SOLWORLD_ZUNCOMMIT_DELAY_S:-120}"
        [[ "$z_uncommit_delay_s" =~ ^[0-9]+$ ]] || z_uncommit_delay_s=120

        local gc_label="G1GC"
        local use_softmax=false
        local -a gc_opts=()
        local -a registry_debug_opts=()

        if [ "$java_major" -ge 21 ]; then
            gc_label="ZGC (Generational)"
            use_softmax=true
            gc_opts=(
                "-XX:+UnlockExperimentalVMOptions"
                "-XX:+UseZGC"
                "-XX:+ZGenerational"
                "-XX:+ZUncommit"
                "-XX:ZUncommitDelay=${z_uncommit_delay_s}"
            )
        elif [ "$java_major" -ge 17 ]; then
            gc_label="ZGC"
            use_softmax=true
            gc_opts=(
                "-XX:+UseZGC"
                "-XX:+ZUncommit"
                "-XX:ZUncommitDelay=${z_uncommit_delay_s}"
            )
        else
            gc_opts=("-XX:+UseG1GC")
        fi

        local -a java_opts=(
            "-Xms${MEM_XMS_MB}M"
            "-Xmx${MEM_XMX_MB}M"
            "-XX:+DisableExplicitGC"
            "-XX:+ExitOnOutOfMemoryError"
            "-XX:+PerfDisableSharedMem"
        )
        if [[ "${SOLWORLD_REGISTRY_DEBUG:-1}" == "1" ]]; then
            registry_debug_opts=(
                "-Dfabric.registry.debug=true"
                "-Dfabric.registry.debug.writeContentsAsCsv=true"
            )
        fi
        if [ "$use_softmax" = true ]; then
            java_opts+=("-XX:SoftMaxHeapSize=${MEM_SOFT_MB}M")
        fi
        java_opts+=("${gc_opts[@]}")

        if [ "$use_softmax" = true ]; then
            echo "[$(date '+%H:%M:%S')] 启动 Solworld (GC: ${gc_label}, Xms: ${MEM_XMS_MB}M, Xmx: ${MEM_XMX_MB}M, SoftMax: ${MEM_SOFT_MB}M)..."
        else
            echo "[$(date '+%H:%M:%S')] 启动 Solworld (GC: ${gc_label}, Xms: ${MEM_XMS_MB}M, Xmx: ${MEM_XMX_MB}M)..."
        fi
        if [[ "$cgroup_avail_mb" -ge 0 ]]; then
            echo "[$(date '+%H:%M:%S')] 内存探测: 物理总内存=${mem_total_mb}M, 可用物理内存=${mem_avail_mb}M, cgroup可用=${cgroup_avail_mb}M (不计入 swap)"
        else
            echo "[$(date '+%H:%M:%S')] 内存探测: 物理总内存=${mem_total_mb}M, 可用物理内存=${mem_avail_mb}M (不计入 swap)"
        fi
        
        if [[ -f "logs/latest.log" ]]; then
            local timestamp=$(date '+%Y%m%d_%H%M%S')
            mv "logs/latest.log" "$LOG_DIR/server_$timestamp.log"
            gzip "$LOG_DIR/server_$timestamp.log"
            find "$LOG_DIR" -name "*.gz" -mtime +$MAX_LOG_RETAIN -delete
        fi

        # 运行引导程序
        java "${java_opts[@]}" "${registry_debug_opts[@]}" -jar "$LAUNCH_JAR" nogui
        
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
