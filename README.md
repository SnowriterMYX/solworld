# 🌍 Solworld Modpack

基于 [Packwiz](https://packwiz.infra.link/) 构建的 Minecraft 1.21.1 Fabric 整合包项目。采用元数据驱动，实现客户端与服务端的自动化同步与按需加载。

## 🚀 核心架构

- **游戏版本**: 1.21.1
- **加载器**: Fabric (Latest)
- **托管平台**: GitHub
- **同步机制**: 仅追踪 `.pw.toml` 索引文件，Mod 实体文件通过 Modrinth/CurseForge 实时下载，完美避开 GitHub 仓库容量限制。

---

## 🛠️ 环境准备 (Java 21 安装)

运行 Minecraft 1.21.1 必须使用 Java 21。推荐以下两种安装方式：

### 方式 A：使用 `mise` 管理 (推荐 / 隔离环境)
如果你希望像 Python 虚拟环境一样管理不同版本的 Java，推荐使用 `mise`：
```bash
# 安装 Java 21
mise install java@openjdk-21

# 在当前目录启用 (会生成 .mise.toml)
mise use java@openjdk-21

# 验证版本
java -version
```

### 方式 B：系统级安装 (Arch Linux)
直接通过系统包管理器安装：
```bash
sudo pacman -S jdk21-openjdk

# 如果系统有多个 Java 版本，请切换默认版本
sudo archlinux-java set java-21-openjdk
```

---

## 💻 客户端部署

### 导出整合包 (推荐给朋友使用)
1. 在本地项目目录执行：
   ```bash
   packwiz modrinth export
   ```
2. 将生成的 `solworld.mrpack` 文件拖入 **XMCL** 或 **Prism Launcher** 即可。

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

# C. 首次同步 Mod 数据
java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml
```

### 2. 编写启动脚本 `start.sh`
```bash
#!/bin/bash
# 1. 自动同步更新 (添加 ?v=1 绕过 GitHub 缓存)
java -jar packwiz-installer-bootstrap.jar -s server https://raw.githubusercontent.com/SnowriterMYX/solworld/master/pack.toml?v=1

# 2. 运行服务端
java -Xmx8G -jar fabric-server-launch.jar nogui
```

---

## 🔄 日常维护工作流

1. **添加 Mod**: `packwiz modrinth add <slug>`
2. **标记 Side**: 如果是渲染/优化类，手动修改 `.pw.toml` 为 `side = "client"`。
3. **同步上传**:
   ```bash
   packwiz refresh
   git add .
   git commit -m "feat: update modpack"
   git push origin master
   ```

---

## ⚠️ 注意事项

1. **缓存延迟**: GitHub Raw 链接有缓存。同步时若未刷出新 Mod，请在 URL 后添加 `?v=时间戳`。
2. **依赖冲突**: 若服务端报错缺少依赖（如 Fusion），请检查该依赖的 `side` 属性是否被错误标记为 `client`。
