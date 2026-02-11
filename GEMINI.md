# Solworld 项目记忆库

## 1. 基础信息 (Project Info)
- **项目名称**: Solworld
- **作者**: Snowriter
- **版本**: 0.1.0.37
- **定位**: **超长期生存服 (永久)**
- **描述**: Ciallo～(∠・ω< )⌒☆ 欢迎来到 Solworld！致力于打造一个稳定、平衡且可持续的永久生存空间。
- **游戏版本**: Minecraft 1.21.1 (支持 1.21.x)
- **加载器**: Fabric 0.18.4
- **Java 版本**: 21

## 2. 技术栈与工具 (Tech Stack)
- **管理工具**: [packwiz](https://packwiz.infra.link/) - 用于自动化管理和导出整合包。
- **核心文件**:
    - `pack.toml`: 项目全局配置。
    - `index.toml`: 资源索引。
    - `mods/`: 包含所有 mod 的 `.pw.toml` 元数据。
    - `config/`: 存储高度定制化的模块配置文件。

## 3. 核心设计方向 (Core Directions)
- **极致优化**: 集成了 Sodium, Lithium, FerriteCore, ModernFix, VMP, C2ME 等全套优化方案，确保长期运行不卡顿。
- **超长期稳定性**:
    - **备份机制**: 使用 `Textile Backup` 实现定时自动备份，确保数据绝对安全。
    - **领地保护**: 集成 `Flan` 插件，提供完善的玩家领地与公共区域保护，防止破坏。
    - **权限控制**: 使用 `LuckPerms` 进行精细化的权限组管理。
- **世界增强**: 使用 YUNG's 系列地牢增强和 Tectonic 地形生成，提供丰富的探索内容。
- **冒险体验**: 引入 Better Combat, Simply Swords, Artifacts 等 RPG 元素，保持长期的游戏趣味性。
- **视觉美化**: 支持 Iris 光影与 Distant Horizons 超远视距。

## 4. 维护规范 (Maintenance)
- **运行管理**: 使用 `./start.sh` 启动服务器。
    - 该脚本会自动在 `tmux` 后台运行，支持 SSH 断连后持续运行。
    - **内存调优**: 脚本会自动识别系统 RAM/ZRAM 并动态分配最佳 JVM 内存。
    - **自动重启**: 服务器崩溃后会自动触发重连/重启。
    - **日志管理**: 自动将 `latest.log` 归档至 `logs/archive/` 并进行 Gzip 压缩，保留 30 天。
- **控制台交互**:
    - 进入控制台: `tmux attach -t solworld`
    - 退出控制台 (保持后台): 按 `Ctrl + B` 然后按 `D`。
- **配置修改**: 修改 `config/` 下的文件后需及时提交 Git。
- **Mod 更新**: 使用 `packwiz mr update --all` 或 `packwiz cf update --all` 进行更新。
- **备份检查**: 定期验证备份文件的完整性。
- **CI/CD**: 通过 GitHub Actions 自动化构建分发版本。
