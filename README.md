# 🌍 Solworld Modpack

一个精心优化的 1.21.1 生存整合包。内置高性能渲染配置与基础生存增强，开箱即用。

## 🚀 核心架构

- **游戏版本**: 1.21.1
- **加载器**: Fabric (Latest)
- **Java版本**: 21 (强制要求)
- **同步机制**: 基于 Packwiz 元数据驱动，实现客户端/服务端自动化同步。

---

## 🛠️ 环境准备 (Java 21 安装)

### 方式 A：使用 `mise` 管理 (推荐 / 隔离环境)
```bash
mise install java@openjdk-21
mise use java@openjdk-21
```

### 方式 B：系统级安装 (Arch Linux)
```bash
sudo pacman -S jdk21-openjdk
sudo archlinux-java set java-21-openjdk
```

---

## 🖥️ 服务端运维 (Linux VPS)

### 1. 首次初始化
```bash
# 安装 Fabric 核心
wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
echo "eula=true" > eula.txt

# 同步 Mod 数据
wget https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml
```

### 2. 关键配置 (`server.properties`)
建议修改以下项以获得最佳体验：
```properties
online-mode=false           # 关闭正版验证 (允许离线登录)
view-distance=10            # 服务端视距 (建议 10-12)
simulation-distance=8       # 模拟视距
sync-chunk-writes=false     # 提高磁盘 I/O 性能
allow-flight=true           # 防止鞘翅飞行被误踢
```

### 3. 常用管理指令

#### 🧩 区块预生成 (Chunky)
强烈建议在玩家进服前运行，可大幅减少跑图卡顿：
- `/chunky center 0 0` - 设置预生成中心
- `/chunky radius 5000` - 设置半径 (5000格)
- `/chunky start` - 开始生成
- `/chunky pause` - 暂停
- `/chunky status` - 查看进度

#### 💾 自动备份 (Textile Backup)
- `/backup start` - 立即手动执行备份
- `/backup status` - 查看备份任务状态
- *配置文件位于 `config/textile_backup.json5`，默认在服务器重启和定时触发。*

#### ⚡ 性能监控 (Spark)
- `/spark health` - 查看当前内存、CPU、TPS 情况
- `/spark profiler start` - 开始采样 (运行 30s 后执行 stop)
- `/spark profiler stop` - 停止采样并生成分析链接

---

## 💻 客户端部署 (玩家指南)

1. 在开发目录运行 `packwiz modrinth export` 生成 `solworld.mrpack`。
2. 将文件拖入 **XMCL** 或 **Prism Launcher**。
3. 启动器会自动处理 Java 21 环境及 Mod 下载。

---

## 🔄 开发者工作流

1. **添加 Mod**: `packwiz modrinth add <slug>`
2. **标记 Side**: 渲染类 Mod 必须修改 `.pw.toml` 设置 `side = "client"`。
3. **推送更新**:
   ```bash
   packwiz refresh
   git add . && git commit -m "feat: some changes" && git push
   ```
4. **服务端生效**: 重启服务器，启动脚本会自动通过 URL 刷取最新配置。

---

## ⚠️ 常见问题修复

- **GitHub Raw 延迟**: 若更新未生效，在启动脚本 URL 后加 `?v=任意数字`。
- **404 错误**: 确保 `.gitignore` 忽略了 `.jar`，但每个 Mod 都有对应的 `.pw.toml` 索引文件。
