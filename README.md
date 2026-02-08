# 🌍 Solworld Modpack (1.21.1 Fabric)

![Version](https://img.shields.io/badge/Version-1.0.0-blue)
![Loader](https://img.shields.io/badge/Loader-Fabric-orange)
![Java](https://img.shields.io/badge/Java-21-red)

**Ciallo～(∠・ω< )⌒☆ 欢迎来到 Solworld！祝你在这个世界玩得开心！**

Solworld 整合包采用 [Packwiz](https://packwiz.infra.link/) 元数据驱动，实现了客户端与服务端的秒级同步。

---

## 📖 目录
1. [环境准备](#-环境准备)
2. [服务器部署指南](#-服务器部署指南)
3. [服务端核心配置](#-服务端核心配置)
4. [常用管理指令手册](#-常用管理指令手册)
5. [开发者维护流](#-开发者维护流)
6. [客户端安装指南](#-客户端安装指南)
7. [常见问题排查](#-常见问题排查)

---

## 🛠 环境准备

本项目强制要求 **Java 21**。

### 1. 使用 `mise` 管理 (推荐)
适用于需要隔离环境的开发者。
```bash
mise install java@openjdk-21
mise use java@openjdk-21
```

### 2. Arch Linux 系统安装
```bash
sudo pacman -S jdk21-openjdk
sudo archlinux-java set java-21-openjdk
```

---

## 🖥 服务器部署指南

### 1. 首次初始化
在你的 VPS 上创建一个干净的目录：
```bash
mkdir solworld-server && cd solworld-server

# 安装 Fabric 核心
wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
echo "eula=true" > eula.txt

# 下载 Packwiz 引导程序
wget https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
```

### 2. 创建高可靠启动脚本 `start.sh`
建议使用以下脚本，它包含了**自动崩溃重启**和**自动更新同步**逻辑：
```bash
#!/bin/bash
while true
do
    echo "--- 正在检查 Mod 更新 ---"
    # 添加 ?v=$RANDOM 强制绕过 GitHub Raw 缓存
    java -jar packwiz-installer-bootstrap.jar -s server "https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml?v=$RANDOM"

    echo "--- 正在启动服务端 ---"
    # Aikar's Flags 优化参数 (适用于 8G 内存)
    java -Xmx8G -Xms8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar fabric-server-launch.jar nogui

    echo "--- 服务器已关闭，5秒后重启 (Ctrl+C 退出) ---"
    sleep 5
done
```

---

## ⚙ 服务端核心配置

### 1. `server.properties` 推荐设置
```properties
online-mode=false           # 允许离线玩家登录
view-distance=10            # 渲染视距 (10-12 最佳)
simulation-distance=8       # 模拟视距 (建议比渲染视距小 2)
sync-chunk-writes=false     # 极大提升大规模跑图时的性能
allow-flight=true           # 开启飞行许可 (防止鞘翅误判)
max-tick-time=60000         # 增加超时检测时间，防止卡顿导致停机
```

### 2. 性能优化补丁
- **Lithium**: 提供物理、AI、区块加载优化。
- **ModernFix**: 优化内存占用和启动速度。
- **Starlight (内置于1.20+)**: 已不再需要，1.21 已内置光照优化。

---

## 🎮 常用管理指令手册

| 功能分类 | 指令 | 说明 |
| :--- | :--- | :--- |
| **区块预生成** | `/chunky center 0 0` | 设置预生成中心 (一般设为出生点) |
| | `/chunky radius 5000` | 设置预生成半径 (建议至少 5000) |
| | `/chunky start` | **必做：** 开启生成，彻底消除玩家跑图卡顿 |
| **备份管理** | `/backup start` | 立即创建存档备份 |
| | `/backup status` | 查看备份任务详情 |
| **权限/保护** | `/lp editor` | LuckPerms 网页编辑器 (管理玩家权限) |
| | `/flan` | 领地保护插件主指令 (防止熊孩子) |
| **性能诊断** | `/spark health` | 查看 TPS、CPU、内存实时健康度 |
| | `/spark profiler` | 采样分析性能瓶颈 |

---

## 🔄 开发者维护流

### 1. 添加新 Mod
```bash
packwiz modrinth add <mod-slug>
```
**注意：** 添加渲染增强类 Mod (如 Iris, Sodium) 后，必须编辑 `mods/xxx.pw.toml`，确保：
`side = "client"`

### 2. 更新配置文件
修改 `config/` 下的任何文件后，必须运行：
```bash
packwiz refresh
```

### 3. 同步推送
```bash
git add .
git commit -m "feat: [描述变更内容]"
git push origin master
```

---

## 💻 客户端安装指南

1. **导出：** 开发者在目录运行 `packwiz modrinth export`。
2. **分发：** 将得到的 `solworld.mrpack` 发给玩家。
3. **导入：** 
   - **XMCL:** 点击“导入整合包” -> 选择文件。
   - **Prism Launcher:** 点击“添加实例” -> “从 mrpack 导入”。
4. **自动：** 启动器会自动安装 Java 21 并下载所有 Mod。

---

## ⚠️ 常见问题排查

- **404 Jar Not Found**: 本项目不追踪物理 Jar。报错 404 说明某个 Mod 的 `.pw.toml` 丢失，导致 Packwiz 尝试去 GitHub 下载。**解决：** 重新使用 `packwiz add` 命令添加该 Mod。
- **GitHub 缓存**: 服务器端执行后提示 `Already up to date` 但内容未变。**解决：** 确保启动脚本 URL 后带有 `?v=随机数`。
- **Side 属性错误**: 服务器启动报 `Class Not Found`。**解决：** 检查是否有 Iris/Sodium 等 Mod 被误设为 `side = "both"`。
