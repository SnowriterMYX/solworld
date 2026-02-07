# 🌍 Solworld Modpack (1.21.1 Fabric)

![Version](https://img.shields.io/badge/Version-1.0.0-blue)
![Loader](https://img.shields.io/badge/Loader-Fabric-orange)
![Java](https://img.shields.io/badge/Java-21-red)

Solworld 是一个平衡了**极致性能**与**生存增强**的 Minecraft 1.21.1 整合包。

---

## 📖 目录
1. [环境准备](#-环境 preparation)
2. [服务器部署](#-服务器部署)
3. [服务端配置](#-服务端配置)
4. [🛡️ 服务器深度管理手册](#️-服务器深度管理手册)
5. [🔄 开发者维护流](#-开发者维护流)
6. [💻 客户端安装](#-客户端安装)

---

## 🛡️ 服务器深度管理手册

整合包内置了多维度的管理工具，请熟练使用以下系统：

### 1. 权限与身份 (LuckPerms)
这是服务器的基石，用于管理谁能执行什么命令。
- **/lp editor** - **最常用：** 在浏览器中直观地编辑权限组、前缀、勋章。
- **/lp user <玩家> info** - 查看玩家所属的权限组。
- **/lp group <组名> permission set <权限名> true** - 为指定组添加权限。

### 2. 领地与防熊 (Flan)
用于保护玩家建筑不被破坏或被箱子被偷。
- **/flan menu** - 打开可视化管理菜单（查看已有领地、修改权限）。
- **/flan claim <半径>** - 以玩家为中心快速创建领地。
- **/flan setGlobalPerms <权限> <true/false>** - 修改全局默认保护规则。

### 3. 操作审计与回滚 (Ledger)
这是服务器的“监控摄像头”，记录所有方块破坏、箱子取物。
- **/l inspect** - 开启/关闭查询模式。开启后，左键点击方块查看破坏记录，右键点击箱子查看存取记录。
- **/l rollback <参数>** - 回滚指定区域或玩家的行为（如回滚某人 1 小时内的破坏：`/l rollback r:5 t:1h u:playername`）。

### 4. 社交与队伍 (FTB Teams)
- **/ftbteams party create** - 创建一个派对。
- **/ftbteams party invite <玩家>** - 邀请玩家加入队伍。
- *成员共享领地和特定 Mod 功能。*

### 5. 性能与生存调试 (Carpet)
- **/carpet** - 查看所有已开启的优化和特性。
- **/tick health** - 查看服务端处理每刻的毫秒数 (MSPT)，定位卡顿源。
- **/player <名字> spawn** - 在当前位置放置一个“假人”（用于挂机刷怪塔或测试）。

### 6. 安全与防御 (InertiaAntiCheat)
- 本插件会自动拦截常见的非法移动、快速交互等作弊行为。
- **/inertia notify** - 开启/关闭管理员的违规通知。

### 7. 生存社交辅助
- **/voicechat menu** - 调整语音距离、音量等核心设置。
- **/waystones list** - 查看服务器上的传送石碑列表。
- **/shops** - 管理你的在线商店 (Universal Shops)。

---

## 🖥 服务器部署指南

### 启动脚本 `start.sh` (推荐)
```bash
#!/bin/bash
while true
do
    echo "--- 正在同步更新 ---"
    java -jar packwiz-installer-bootstrap.jar -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml?v=$RANDOM
    echo "--- 正在启动 (8G 内存优化) ---"
    java -Xmx8G -Xms8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar fabric-server-launch.jar nogui
    echo "--- 服务器重启中 ---"
    sleep 5
done
```

---

## ⚙ 服务端核心配置 (`server.properties`)
```properties
online-mode=false           # 允许离线玩家
view-distance=10            # 推荐 10，过高会增加 CPU 压力
simulation-distance=8       # 模拟距离
allow-flight=true           # 防止鞘翅飞行误踢
max-tick-time=60000         # 防止卡顿误判为崩溃
```

---

## 🔄 开发者维护流
1. **添加 Mod**: `packwiz modrinth add <slug>`
2. **刷新**: `packwiz refresh`
3. **上传**: `git add . && git commit -m "update" && git push`
4. **生效**: 重启服务端即可。

---

## 💻 客户端安装
1. 开发者运行 `packwiz modrinth export`。
2. 玩家将 `solworld.mrpack` 拖入 **XMCL**。
3. 启动器自动完成环境准备。
