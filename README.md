# 🌍 Solworld Modpack (1.21.1 Fabric)

![Version](https://img.shields.io/badge/Version-1.0.0-blue)
![Loader](https://img.shields.io/badge/Loader-Fabric-orange)
![Java](https://img.shields.io/badge/Java-21-red)

Solworld 是一个平衡了**极致性能**与**生存增强**的 Minecraft 1.21.1 整合包。

---

## 📖 目录
1. [环境准备](#-环境准备)
2. [服务器首次初始化](#-服务器首次初始化)
3. [启动与运维脚本](#-启动与运维脚本)
4. [🛡️ 服务器深度管理手册](#️-服务器深度管理手册)
5. [🔄 开发者维护流](#-开发者维护流)
6. [💻 客户端安装](#-客户端安装)

---

## 🛠 环境准备

本项目强制要求 **Java 21**。

### 1. 使用 `mise` 管理 (推荐)
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

## 🖥 服务器首次初始化

在你的 VPS 上创建一个干净的目录并执行以下操作：

1. **获取 Fabric 核心**：
   ```bash
   wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
   java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
   echo "eula=true" > eula.txt
   ```

2. **获取 Packwiz 引导程序**：
   ```bash
   wget https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
   ```

3. **配置 `server.properties`**：
   ```properties
   online-mode=false           # 允许离线玩家
   view-distance=10            # 渲染视距
   allow-flight=true           # 防止鞘翅飞行误踢
   ```

---

## 🚀 启动与运维脚本

建议创建 `start.sh` 并使用以下内容，它支持**自动更新**与**高可靠重启**：

```bash
#!/bin/bash
while true
do
    echo "--- 正在同步更新 ---"
    java -jar packwiz-installer-bootstrap.jar -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml?v=$RANDOM
    echo "--- 正在启动 (8G 内存优化) ---"
    java -Xmx8G -Xms8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar fabric-server-launch.jar nogui
    echo "--- 服务器重启中 (Ctrl+C 退出) ---"
    sleep 5
done
```

---

## 🛡️ 服务器深度管理手册

### 1. 权限管理 (LuckPerms)
- **/lp editor** - 在浏览器中可视化编辑权限。
- **/lp user <玩家> info** - 查看玩家权限状态。

### 2. 领地与保护 (Flan)
- **/flan menu** - 打开图形化领地菜单。
- **/flan claim <半径>** - 快速圈地。

### 3. 操作审计与回滚 (Ledger)
- **/l inspect** - 查询方块破坏/箱子交互记录。
- **/l rollback <参数>** - 回滚区域内的误操作。

### 4. 性能监控 (Carpet / Spark)
- **/tick health** - 查看实时 MSPT 性能。
- **/spark health** - 查看系统级健康度。
- **/player <名字> spawn** - 召唤假人挂机。

---

## 🔄 开发者维护流
1. **添加 Mod**: `packwiz modrinth add <slug>`
2. **标记 Side**: 渲染增强 Mod 必须在 `.pw.toml` 中标记 `side = "client"`。
3. **上传**: `git add . && git commit -m "update" && git push`
4. **生效**: 重启服务端。

---

## 💻 客户端安装
1. 开发者运行 `packwiz modrinth export`。
2. 玩家将 `solworld.mrpack` 拖入 **XMCL** 即可。
