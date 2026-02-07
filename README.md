# 🌍 Solworld Modpack

基于 [Packwiz](https://packwiz.infra.link/) 构建的 Minecraft 1.21.1 Fabric 整合包项目。采用元数据驱动，实现客户端与服务端的自动化同步与按需加载。

## 🚀 核心架构

- **游戏版本**: 1.21.1
- **加载器**: Fabric (Latest)
- **托管平台**: GitHub
- **同步机制**: 仅追踪 `.pw.toml` 索引文件，Mod 实体文件通过 Modrinth/CurseForge 实时下载，完美避开 GitHub 仓库容量限制。

---

## 🛠️ 环境准备

在开始之前，请确保你的系统已安装以下工具：

- **Java 21**: 运行 Minecraft 1.21.1 的必备版本。
- **Packwiz CLI**: 
  ```bash
  paru -S packwiz  # Arch Linux 用户
  ```
- **Git**: 版本控制。

---

## 💻 客户端部署

### 方式 A：导出整合包 (推荐给朋友使用)
1. 在本地项目目录执行：
   ```bash
   packwiz modrinth export
   ```
2. 将生成的 `solworld.mrpack` 文件拖入 **XMCL** 或 **Prism Launcher**。
3. 启动器会自动根据索引下载所有 Mod 及配置文件。

---

## 🖥️ 服务端运维 (Linux VPS)

Solworld 实现了服务端自动瘦身，部署时会自动跳过 Iris、Sodium 等客户端插件。

### 1. 首次初始化 (安装核心与引导)
```bash
# 创建目录
mkdir solworld-server && cd solworld-server

# A. 下载并安装 Fabric 服务端核心
wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -jar fabric-installer-1.0.1.jar server -mcversion 1.21.1 -downloadMinecraft
echo "eula=true" > eula.txt

# B. 下载 Packwiz 自动更新引导包
wget https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar

# C. 首次同步 Mod 数据 (关键参数: -s server)
java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml
```

### 2. 编写启动脚本 `start.sh`
推荐使用此脚本，每次重启服务器时都会自动检查并下载 GitHub 上的最新 Mod 更新：
```bash
#!/bin/bash
# 1. 自动同步更新 (指向你的 GitHub Raw 链接)
java -jar packwiz-installer-bootstrap.jar -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml

# 2. 运行服务端
# 注意: 核心文件名必须与第一步生成的保持一致 (通常是 fabric-server-launch.jar)
java -Xmx8G -jar fabric-server-launch.jar nogui
```

---

## 🔄 日常维护工作流

### 1. 添加 Mod
```bash
# 从 Modrinth 添加
packwiz modrinth add <mod-slug>

# 标记分类 (如果是客户端专用)
# 修改 mods/<mod>.pw.toml，设置 side = "client"
```

### 2. 同步与上传
```bash
packwiz refresh
git add .
git commit -m "feat: update modpack"
git push origin master
```

---

## ⚠️ 注意事项

1. **核心 JAR 丢失**: 如果报错 `Unable to access jarfile`，请确保已执行上述“安装 Fabric 服务端核心”的步骤。
2. **Side 属性**: 渲染类 Mod 务必标记为 `side = "client"`，否则服务端崩溃。
3. **GitHub Raw 延迟**: 推送后服务器端可能有 1-5 分钟的缓存延迟。
