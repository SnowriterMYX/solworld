# 🌍 Solworld Modpack (1.21.1 Fabric)

![Version](https://img.shields.io/badge/Version-0.1.0.44-blue)
![Loader](https://img.shields.io/badge/Loader-Fabric-orange)
![Java](https://img.shields.io/badge/Java-21-red)
![Mode](https://img.shields.io/badge/Status-Permanent_Survival-brightgreen)

**Ciallo～(∠・ω< )⌒☆ 欢迎来到 Solworld！致力于打造一个稳定、平衡且可持续的永久生存空间。**

Solworld 整合包采用 [Packwiz](https://packwiz.infra.link/) 元数据驱动，深度集成了性能优化与长期服维护工具，旨在提供极致的长期生存体验。

---

## 📖 目录
1. [项目定位](#-项目定位)
2. [当前 Mod 列表](#-当前-mod-列表)
3. [环境准备](#-环境准备)
4. [服务器部署指南](#-服务器部署指南)
5. [服务端核心配置](#-服务端核心配置)
6. [常用管理指令手册](#-常用管理指令手册)
7. [开发者维护流](#-开发者维护流)
8. [客户端安装指南](#-客户端安装指南)

---

## 💎 项目定位：超长期生存 (Permanent)
- **数据至上**: 自动化的增量备份机制，确保数年甚至更久的数据安全。
- **极致稳定**: 经过深度调优的 JVM 参数与优化 Mod 套件，杜绝长期运行导致的内存溢出或 TPS 下降。
- **公平与安全**: 集成 LuckPerms 权限组与 Flan 领地保护，防止破坏与作弊。

---

## 📦 当前 Mod 列表
- 当前模组总数：**267**
- 统计来源：`mods/*.pw.toml`（按文件名排序）
- 简介来源：由维护者按模组定位手写整理（非逐句翻译）。
- 名称规则：优先使用社区常见中文名；未能确认中文名的模组保留英文原名。

<details>
<summary>点击展开完整列表</summary>

| ID | 模组 | 端 | 简介（维护者编写） |
|---|---|---|---|
| `3dskinlayers` | 3D Skin Layers | client | 让玩家皮肤第二层显示为立体模型，角色观感更自然。 |
| `adventurez` | AdventureZ | both | 冒险生物扩展，加入更高威胁度的敌对生物。 |
| `aether` | 天域（The Aether） | both | 新增“天域”维度，提供完整的独立探索与生存线路。 |
| `amecs` | Amecs | client | 扩展按键绑定能力，方便设置更多快捷键组合。 |
| `amendments` | Amendments | both | 对原版方块交互进行细节增强与体验优化。 |
| `appleskin` | 苹果皮（AppleSkin） | both | 在 HUD 中补充食物与饱和度相关信息。 |
| `architectury-api` | Architectury | both | 跨平台开发中间层，统一 Fabric/Forge 常用接口。 |
| `armor-statues` | 盔甲架增强（Armor Statues） | both | 增强盔甲架编辑能力，支持更细致的摆放与展示。 |
| `artifacts` | Artifacts | both | 加入一批偏冒险向的稀有遗物道具。 |
| `athena-ctm` | Athena | client | 资源与模型相关的通用前置库。 |
| `athena` | Athena | both | 资源与模型相关的通用前置库。 |
| `auditory-continued` | Auditory | both | 音效增强模组，提升环境声与沉浸感。 |
| `auto-third-person` | Auto Third Person | client | 按动作自动切换第三人称，便于飞行和战斗观察。 |
| `balm-fabric` | Balm | both | Blay 系列模组通用前置库。 |
| `balm` | Balm | both | Blay 系列模组通用前置库。 |
| `bclib` | BCLib | both | BetterX 系列世界生成前置库。 |
| `beautify-refabricated` | Beautify | both | 建筑装饰扩展，补充大量家居与细节摆件。 |
| `better-combat` | 更好的战斗（Better Combat） | both | 重构近战手感与连击节奏，提升战斗表现。 |
| `betterf3` | BetterF3 | client | 优化 F3 调试信息排版，可读性更高。 |
| `better-fabric-console` | Better Fabric Console | server | 服务端控制台增强，补全、高亮与日志体验更好。 |
| `betternether` | Better Nether | both | 下界生态扩展，增加生物群系与素材内容。 |
| `better-stats` | 更好的统计界面（Better Statistics Screen） | both | 重做统计界面，分类更清晰、查阅更直观。 |
| `biolith` | Biolith | both | 世界生成兼容层，用于协调多模组群系注入。 |
| `biomes-o-plenty` | 丰富群系（Biomes O' Plenty） | both | 大型群系扩展，增加大量地表生态风格。 |
| `bobby` | Bobby | client | 客户端远距离区块缓存显示，减少视野空洞。 |
| `bookshelf-lib` | Bookshelf 库 | both | 通用依赖库，为多模组提供基础工具。 |
| `bosses-of-mass-destruction` | 大型 BOSS 破坏（Bosses of Mass Destruction） | both | 添加阶段性 Boss 战内容，增强中后期挑战。 |
| `botany-pots` | 植物盆（Botany Pots） | both | 植物盆种植系统，支持自动化与小空间栽培。 |
| `bountiful-blocks` | Bountiful Blocks | both | 建筑方块拓展包，提供更多装饰变体。 |
| `bountiful-fares` | Bountiful Fares | both | 农耕与食材扩展，强化日常生存烹饪线。 |
| `brb` | Better Recipe Book | client | 优化配方书交互流程，查配方更顺手。 |
| `capes` | Capes | client | 披风渲染支持与显示增强。 |
| `cardinal-components-api` | Cardinal Components API | both | 组件化数据 API，为对象附加自定义数据。 |
| `carry-on` | Carry On | both | 允许徒手搬运部分方块实体，便于整理与搬家。 |
| `chalk` | Chalk | both | 建筑标记与标线工具，便于施工规划。 |
| `charm-forked` | Charm | both | 原版风格小型增强合集，不改核心节奏。 |
| `chat-heads` | Chat Heads | client | 聊天栏显示玩家头像，消息辨识度更高。 |
| `chipped` | Chipped | both | 装饰变体扩展，为原版方块提供大量新样式。 |
| `chunky` | 区块预生成（Chunky） | both | 区块预生成工具，降低首次跑图卡顿。 |
| `cicada` | CICADA | both | 开发辅助前置库。 |
| `cloth-config` | Cloth Config v15 | both | 配置界面前置库。 |
| `clumps` | 经验球聚合（Clumps） | both | 经验球聚合，减少实体堆积与掉帧。 |
| `collective` | Collective | both | Serilum 系列模组公共依赖。 |
| `comforts` | Comforts | both | 加入睡袋与吊床，便携休息但不强改重生点。 |
| `connected-glass` | 连纹玻璃（Connected Glass） | both | 连纹玻璃扩展，玻璃拼接更自然。 |
| `connectivity` | Connectivity Mod | both | 修复部分网络连接异常与超时问题。 |
| `continuity` | Continuity | client | 客户端贴图连接与资源包效果增强。 |
| `controlling` | Controlling | client | 按键设置搜索与冲突排查工具。 |
| `cooking-for-blockheads` | 厨艺方块头（Cooking for Blockheads） | both | 厨房系统扩展，集中管理食谱与烹饪流程。 |
| `creeper-overhaul` | 苦力怕革新（Creeper Overhaul） | both | 苦力怕变种扩展，不同群系有不同外观与行为。 |
| `cristel-lib` | Cristel Lib | both | 结构与运行时数据包前置库。 |
| `critters-and-companions` | Critters and Companions | both | 主世界动物扩展，增加原版风格生物。 |
| `croptopia-refabricated` | Croptopia Refabricated | both | 作物与食材扩展，丰富农业链路。 |
| `crossstitch` | CrossStitch | server | 代理/转发环境兼容增强。 |
| `cupboard` | cupboard | both | 通用前置库。 |
| `debugify` | Debugify | both | 修复原版已知问题与边角 Bug。 |
| `default-options` | Default Options | client | 预设客户端选项，统一新实例默认设置。 |
| `dehydration` | Dehydration | both | 加入口渴系统，强化生存管理。 |
| `diagonal-fences` | Diagonal Fences | both | 栅栏支持对角连接，建筑过渡更顺滑。 |
| `dimensionaldoors` | DimensionalDoors | both | 维度裂隙与口袋空间玩法扩展。 |
| `distanthorizons` | 远景地平线（Distant Horizons） | client | 超远景地形显示，提升远处地貌可见性。 |
| `do-a-barrel-roll` | Do a Barrel Roll | client | 飞行镜头动作增强，增加旋转与动态反馈。 |
| `do-api` | [Let's Do] API | both | Let's Do 系列通用前置 API。 |
| `dynamic-fps` | 动态帧率（Dynamic FPS） | client | 后台或静止时自动降帧，减少资源占用。 |
| `easy-anvils` | 简易铁砧（Easy Anvils） | both | 铁砧体验重做，交互更直观、损耗更友好。 |
| `easyauth` | Easy Authentication Mod | server | 简化服务端身份验证与注册登录流程。 |
| `easy-magic` | 简易附魔（Easy Magic） | both | 附魔台流程优化，重掷与保留体验更好。 |
| `ebe` | Enhanced Block Entities | client | 方块实体渲染优化，减少场景渲染开销。 |
| `ecologics` | Ecologics | both | 原版生态小扩展，增加生物与自然内容。 |
| `emi` | EMI 物品管理 | both | 物品与配方查询工具（轻量、可定制）。 |
| `enchantment-descriptions` | Enchantment Descriptions | client | 附魔说明文本补全，效果一眼可读。 |
| `endrem` | 末地重制（End Remastered） | both | 末地流程重做：需收集多种特殊末影之眼再推进。 |
| `enhanced-groups` | Simple Voice Chat Enhanced Groups | both | 语音聊天群组功能增强。 |
| `entityculling` | Entity Culling | client | 遮挡剔除优化，减少无效实体渲染。 |
| `essential-commands` | 基础指令（Essential Commands） | server | 常用管理指令集合（home/tpa/warp 等）。 |
| `euphoria-patches` | Euphoria Patches | client | 光影兼容补丁与视觉细节修正。 |
| `explorify` | Explorify | both | 原版友好型结构扩展，提升探索多样性。 |
| `exposure` | Exposure | both | 摄影相机玩法，强调构图与拍摄流程。 |
| `extendeddrawersaddon` | ExtendedDrawersAddon | both | Extended Drawers 功能补充插件。 |
| `extended-drawers` | Extended Drawers | both | 抽屉式存储系统扩展。 |
| `fabric-api` | Fabric API | both | Fabric 生态核心 API。 |
| `fabric-language-kotlin` | Fabric Language Kotlin | both | Kotlin 语言支持前置。 |
| `fabric-mail` | Fabric Mail | server | 服务端邮件系统。 |
| `fabrictailor` | Fabric Tailor | both | 皮肤切换与外观管理。 |
| `falling-leaves-fabric` | Falling Leaves | both | 环境落叶粒子效果，增强氛围感。 |
| `farmers-delight-refabricated` | 农夫乐事（Farmer's Delight） | both | 经典烹饪扩展，补充厨具与菜谱。 |
| `fastback` | FastBack | server | 增量式世界备份，适合长期服归档。 |
| `ferrite-core` | FerriteCore | both | 内存占用优化。 |
| `firework-frenzy` | Firework Frenzy | both | 烟花与弩联动玩法增强。 |
| `fix-gpu-memory-leak` | Gpu memory leak fix mod | both | 修复显存泄漏类问题，提升长时稳定性。 |
| `flan` | Flan 领地保护 | server | 领地保护与防破坏核心模组。 |
| `forge-config-api-port` | Forge Config API Port | both | 移植 Forge 配置体系，提升跨平台兼容。 |
| `framework` | Framework | both | 开发辅助通用库。 |
| `friends-and-foes` | Friends&Foes | both | 补全投票落选生物并扩展其玩法。 |
| `fusion-connected-textures` | Fusion | both | 资源包高级纹理/模型功能支持。 |
| `fzzy-config` | Fzzy Config | both | 自动配置 GUI 与端服同步配置框架。 |
| `geckolib` | GeckoLib 动画库 | both | 高阶动画引擎前置，支持复杂关键帧动画。 |
| `glitchcore` | GlitchCore | both | 跨加载器工具库。 |
| `goblintradersfood` | Goblin Traders Food Config | server | 哥布林商人食物偏好配置模块。 |
| `goblin-traders` | Goblin Traders | both | 增加哥布林流动商人，提供特色交易。 |
| `golem-overhaul` | Golem Overhaul | both | 铁傀儡/傀儡系玩法与外观增强。 |
| `grieflogger` | GriefLogger | server | 方块与实体交互日志记录，便于追责回溯。 |
| `handcrafted` | Handcrafted | both | 家具与室内装饰扩展。 |
| `hang-glider` | Hang Glider | both | 滑翔翼移动工具，提升地形穿越效率。 |
| `healing-campfire` | Healing Campfire | server | 篝火范围治疗效果，可配置半径。 |
| `i18nupdatemod` | I18nUpdateMod | both | 语言资源更新辅助。 |
| `illager-invasion` | Illager Invasion | both | 灾厄势力扩展，新增敌人与战斗遭遇。 |
| `immediatelyfast` | ImmediatelyFast | client | 渲染路径优化，提升客户端帧率表现。 |
| `immersive-aircraft` | Immersive Aircraft | both | 低科技飞行器扩展（运输与探索）。 |
| `inventory-profiles-next` | Inventory Profiles Next | client | 背包整理、排序与快捷管理工具。 |
| `iris` | Iris 光影 | client | 主流光影加载器。 |
| `item-descriptions` | Item Descriptions | client | 为物品补充说明文本。 |
| `item-interactions-mod` | Item interactions mod | client | 增强物品交互逻辑与细节操作。 |
| `jade` | Jade 信息显示 | both | 查看目标方块/实体信息的探查 HUD。 |
| `jei` | JEI（Just Enough Items） | both | 经典物品与配方检索工具。 |
| `joy-of-painting` | Joy of Painting | both | 绘画创作玩法扩展。 |
| `just-enough-characters` | Just Enough Characters | both | JEI 拼音检索与字符输入增强。 |
| `krypton` | Krypton | both | 网络栈优化，改善多人联机性能。 |
| `ksyxis` | Ksyxis | server | 世界加载优化，缩短进服等待时间。 |
| `lambdynamiclights` | LambDynamicLights - Dynamic Lights | client | 动态光源效果。 |
| `language-reload` | Language Reload | client | 语言包热重载工具。 |
| `lazydfu-reloaded` | LazyDFU Reloaded | client | 启动阶段优化，缩短初始化时长。 |
| `lets-do-addon-compat` | [Let's Do Addon] Compat | server | Let's Do 系列兼容补丁集合。 |
| `lets-do-bakery-farmcharm-compat` | [Let's Do] Bakery | both | 烘焙主题扩展，补充面包甜点与制作链。 |
| `lets-do-beachparty` | [Let's Do] Beachparty | both | 海滩主题内容：休闲装饰与派对元素。 |
| `lets-do-bloomingnature` | [Let's Do] BloomingNature | both | 自然景观扩展，增加花卉与生态变化。 |
| `lets-do-brewery-farmcharm-compat` | [Let's Do] Brewery | both | 酿造主题扩展，补充酒类制作流程。 |
| `lets-do-camping` | Camping | both | 露营玩法扩展：帐篷、野炊与户外休息。 |
| `lets-do-candlelight-farmcharm-compat` | [Let's Do] Candlelight | both | 餐饮主题扩展，强化料理与餐桌表现。 |
| `lets-do-emi-compat` | emi-letsdo-compat | both | Let's Do 与 EMI 的配方显示兼容层。 |
| `lets-do-farm-charm` | [Let's Do] Farm & Charm | both | 农场生活扩展，强化种植与料理联动。 |
| `lets-do-furniture` | [Let's Do] Furniture | both | 家居家具扩展。 |
| `lets-do-hearth-timber` | [Let's Do] Hearth & Timber | both | 乡野建材与木构件扩展。 |
| `lets-do-herbalbrews` | [Let's Do] HerbalBrews | both | 草本茶饮与酿煮系统扩展。 |
| `lets-do-lilis-lucky-lures` | Lilis' Lucky Lures | both | 钓鱼向玩法扩展，新增渔获与垂钓机制。 |
| `lets-do-lilis-pottery` | [Let's Do] LilisPottery | both | 陶艺与砖瓦装饰扩展。 |
| `lets-do-meadow` | [Let's Do] Meadow | both | 山地牧场与野花生态扩展。 |
| `lets-do-vinery` | [Let's Do] Vinery | both | 葡萄园与酿酒经营扩展。 |
| `lets-do-wildernature` | [Let's Do] WilderNature | both | 野生生态扩展，增加动物与自然事件。 |
| `libipn` | libIPN | client | Inventory Profiles Next 前置库。 |
| `lithium` | Lithium 锂优化 | both | 服务端逻辑性能优化。 |
| `lithostitched` | Lithostitched | both | 世界生成兼容前置库。 |
| `lootr` | Lootr | both | 战利品实例化，避免多人开箱冲突。 |
| `luckperms` | LuckPerms 权限 | server | 权限组与权限节点管理核心。 |
| `ly-graves` | Graves | both | 死亡墓碑与掉落保护。 |
| `macaws-bridges` | Macaw's Bridges | both | 桥梁样式扩展。 |
| `macaws-doors` | Macaw's Doors | both | 门类样式扩展。 |
| `macaws-fences-and-walls` | Macaw's Fences and Walls | both | 围栏与围墙样式扩展。 |
| `macaws-furniture` | Macaw's Furniture | both | 家具组合扩展。 |
| `macaws-holidays` | Macaw's Holidays | both | 节日装饰扩展（圣诞/万圣等）。 |
| `macaws-paintings` | Macaw's Paintings | both | 画作主题扩展。 |
| `macaws-roofs` | Macaw's Roofs | both | 屋顶构件扩展。 |
| `macaws-stairs` | Macaw's Stairs and Balconies | both | 楼梯与阳台构件扩展。 |
| `macaws-trapdoors` | Macaw's Trapdoors | both | 活板门样式扩展。 |
| `macaws-windows` | Macaw's Windows | both | 窗户与百叶等构件扩展。 |
| `macu-lib` | macu Lib | both | 通用依赖库。 |
| `memory-check` | Memory Check | server | 快速查看服务端内存占用。 |
| `midnightlib` | MidnightLib | both | 轻量配置与界面前置库。 |
| `mighty-mail` | Mighty Mail | both | 生存向邮件系统。 |
| `moanimals` | MoAnimals | both | 动物扩展模组。 |
| `modernfix` | ModernFix | both | 现代版本综合性能优化。 |
| `modern-ui` | Modern UI | both | 现代化 UI 框架与渲染界面扩展。 |
| `modmenu` | 模组菜单（Mod Menu） | client | 客户端模组配置入口与列表管理。 |
| `moonlight` | 月光库（Moonlight） | both | 多功能通用前置库（资源、数据与工具）。 |
| `morechathistory` | More Chat History | client | 扩展聊天记录保留长度。 |
| `more-compatibility-variants-lets-do` | More Compatibility Variants [Let's Do] | both | Let's Do 与 More Variants 的材质/配方兼容。 |
| `moreculling` | More Culling | client | 更多剔除优化，减少不必要渲染。 |
| `moremousetweaks` | More Mouse Tweaks | client | 鼠标操作细节增强。 |
| `more-villagers-re-employed` | MoreVillagers | both | 新增村民职业、工作站与交易内容。 |
| `mouse-tweaks` | Mouse Tweaks | client | 背包鼠标手势增强。 |
| `mouse-wheelie` | Mouse Wheelie | both | 滚轮搬运与快速整理增强。 |
| `nexuslib` | NexusLib | both | 通用前置库。 |
| `no-chat-reports` | 禁用聊天举报（No Chat Reports） | both | 禁用聊天举报链路并增强隐私控制。 |
| `noisium` | Noisium | server | 世界生成性能优化。 |
| `not-enough-animations` | Not Enough Animations | client | 第一人称动作动画补全。 |
| `nrb` | No Report Button | client | 移除聊天举报按钮相关入口。 |
| `numismatic-overhaul` | Numismatic Overhaul | both | 货币系统扩展，支持分层价值流通。 |
| `nyfs-spiders` | Nyf's Spiders | both | 蜘蛛 AI 与攀爬行为增强。 |
| `observable` | Observable | both | 性能观测工具，定位卡顿来源。 |
| `oracle-index` | Oracle Index | both | 文档索引辅助模组。 |
| `owo-lib` | oωo | both | oωo 系列通用依赖库。 |
| `particle-core` | Particle Core | client | 粒子系统性能与表现增强。 |
| `patchouli` | 帕秋莉手册（Patchouli） | both | 可数据驱动的游戏内文档系统。 |
| `pehkui` | 体型调整（Pehkui） | both | 实体体型缩放系统。 |
| `pl3xmap` | Pl3x 地图 | both | 服务端网页地图。 |
| `placeholder-api` | Placeholder API | both | 文本占位符 API 前置。 |
| `platform` | Platform | both | 跨平台基础能力库。 |
| `playeranimatorapi` | Zigy's Player Animator API | both | 玩家动画 API 前置。 |
| `playeranimator` | Player Animator | both | 玩家动作动画实现库。 |
| `polymorph` | Polymorph | both | 合成冲突选择器，支持手动切换结果。 |
| `presence-footsteps` | Presence Footsteps | client | 脚步与材质音效沉浸增强。 |
| `prickle` | PrickleMC | both | JSON 配置格式与工具前置。 |
| `puzzles-lib` | Puzzles Lib | both | Puzzles 系列通用前置。 |
| `reeses-sodium-options` | Reese's Sodium Options | client | Sodium 设置界面增强。 |
| `repurposed-structures-fabric` | Repurposed Structures | both | 原版结构变体扩展。 |
| `resourceful-config` | Resourcefulconfig | both | 配置系统前置库。 |
| `resourceful-lib` | Resourceful Lib | both | Resourceful 系列通用依赖库。 |
| `rottencreatures` | RottenCreatures | both | 僵尸系怪物扩展。 |
| `scalablelux` | ScalableLux | both | 光照计算优化与修复。 |
| `searchables` | Searchables | client | 搜索输入与配置检索前置。 |
| `seasonal-lets-do` | Seasonal Let's Do | server | Let's Do 与季节系统兼容补丁。 |
| `serene-seasons` | SereneSeasons | both | 四季系统扩展（温度与色彩变化）。 |
| `servercore` | ServerCore | server | 服务端核心性能优化。 |
| `simple-item-blacklist` | Item Blacklist | both | 黑名单物品全局拦截（配方、战利品、交易与拾取清理）。 |
| `simple-voice-chat` | Simple Voice Chat | both | 近距离语音聊天系统。 |
| `simply-swords` | Simply Swords | both | 武器库扩展。 |
| `sleep-tight` | Sleep Tight | both | 睡眠机制增强与吊床玩法补充。 |
| `sleep-warp-updated` | SleepWarp (Updated) | server | 睡眠加速时间流逝，不直接跳日。 |
| `small-ships` | Small Ships | both | 原版风格船只扩展。 |
| `smartbrainlib` | SmartBrainLib | both | AI 行为树/Brain 系统前置库。 |
| `smooth-gui` | Smooth Gui | client | 界面过渡动画与流畅度优化。 |
| `smooth-swapping` | Smooth Swapping | client | 物品切换动画平滑化。 |
| `snowy-spirit` | Snowy Spirit | both | 冬季主题扩展（雪橇与节日内容）。 |
| `sodium-extra` | Sodium Extra 钠扩展 | client | Sodium 额外图形选项扩展。 |
| `sodium` | Sodium 钠优化 | client | 高性能渲染优化核心模组。 |
| `sophisticated-backpacks-(unoffical-fabric-port)` | Sophisticated Backpacks | both | 多层级可升级背包系统。 |
| `sophisticated-core-(unofficial-fabric-port)` | Sophisticated Core | both | Sophisticated 系列核心依赖。 |
| `sound-physics-remastered` | Sound Physics Remastered | client | 空间声学与回响模拟增强。 |
| `spark` | spark | both | 性能采样与剖析工具。 |
| `sparkweave` | Sparkweave Engine | both | Up 系列模组共享功能库。 |
| `starter-kit` | Starter Kit | both | 首进服务器自动发放新手物资。 |
| `structory` | Structory | both | 氛围化结构扩展。 |
| `structure-layout-optimizer` | Structure Layout Optimizer | server | Jigsaw 结构布局性能优化。 |
| `supermartijn642s-config-lib` | SuperMartijn642's Config Lib | both | 配置系统前置库。 |
| `supermartijn642s-core-lib` | SuperMartijn642's Core Lib | both | SuperMartijn642 系列核心依赖。 |
| `supplementaries` | Supplementaries | both | Vanilla+ 功能方块扩展。 |
| `tcdcommons` | TCD Commons API | both | 作者个人 API 依赖库。 |
| `tectonic` | Tectonic | both | 大地形重塑，强化山脉与地貌纵深。 |
| `terrablender` | TerraBlender | both | 群系注入兼容层。 |
| `terralith` | 地貌重塑（Terralith） | both | 大规模群系与地形扩展。 |
| `textile_backup` | Textile 备份 | both | 服务端定时备份系统。 |
| `tiny-item-animations` | Tiny Item Animations | client | 小型物品动画细节增强。 |
| `toms-storage` | Tom's Simple Storage Mod | both | 终端式物品存储网络。 |
| `touhoulittlemaid-orihime` | Touhou Little Maid: Orihime | both | 东方小女仆的 Fabric 移植扩展。 |
| `touhoupixelcanteen` | Gensokyo Izakaya | client | 东方主题餐饮内容扩展。 |
| `towns-and-towers` | Towns and Towers | both | 村庄与塔楼等结构扩展。 |
| `trash-cans` | Trash Cans | both | 物品/液体/能量垃圾桶。 |
| `travelersbackpack` | 旅行者背包（Traveler's Backpack） | both | 可升级旅行背包与外观定制。 |
| `trinkets` | 饰品栏（Trinkets） | both | 饰品栏系统与槽位扩展。 |
| `universal-graves` | 通用墓碑（Universal Graves） | server | 服务端可用的通用墓碑系统。 |
| `universal-shops` | Universal Shops | server | 服务器通用商店交易系统。 |
| `unnamed-framework` | Unnamed Framework | both | 数据包框架与公共函数库。 |
| `villagerapi` | VillagerAPI | both | 村民职业与交易扩展 API。 |
| `visuality` | Visuality | client | 客户端视觉粒子与特效增强。 |
| `visual-workbench` | 可视化工作台（Visual Workbench） | both | 工作台可视化与合成保留增强。 |
| `vmp-fabric` | Very Many Players | both | 高并发玩家场景服务端优化。 |
| `voice-chat-interaction` | Voice Chat Interaction | server | 语音聊天与游戏机制联动扩展。 |
| `wavey-capes` | Wavey Capes | client | 动态披风物理效果。 |
| `waystones` | 路石（Waystones） | both | 路石传送网络。 |
| `worldweaver` | WorldWeaver | both | 数据驱动世界构建辅助工具。 |
| `xaeros-minimap` | Xaero 小地图 | both | 高兼容原版风格小地图。 |
| `xaeros-world-map` | Xaero 世界地图 | both | 与 Xaero 小地图联动的世界全图。 |
| `yacl` | YACL 配置库（YetAnotherConfigLib） | both | YetAnotherConfigLib 配置库前置。 |
| `yungs-api` | YUNG's API | both | YUNG 系列结构模组通用 API。 |
| `yungs-better-desert-temples` | YUNG's Better Desert Temples | server | 沙漠神殿结构重做。 |
| `yungs-better-dungeons` | YUNG's Better Dungeons | server | 原版地牢结构重做。 |
| `yungs-better-end-island` | YUNG's Better End Island | server | 末地主岛与龙战场景重做。 |
| `yungs-better-jungle-temples` | YUNG's Better Jungle Temples | server | 丛林神庙结构重做。 |
| `yungs-better-mineshafts` | YUNG's Better Mineshafts | server | 废弃矿井结构重做。 |
| `yungs-better-nether-fortresses` | YUNG's Better Nether Fortresses | server | 下界要塞结构重做。 |
| `yungs-better-ocean-monuments` | YUNG's Better Ocean Monuments | server | 海底神殿结构重做。 |
| `yungs-better-strongholds` | YUNG's Better Strongholds | server | 要塞结构重做。 |
| `yungs-better-witch-huts` | YUNG's Better Witch Huts | server | 女巫小屋结构重做。 |
| `yungs-bridges` | YUNG's Bridges | server | 自然生成桥梁结构扩展。 |
| `yungs-cave-biomes` | YUNG's Cave Biomes | both | 洞穴群系与地下生态扩展。 |
| `yungs-extras` | YUNG's Extras | server | YUNG 额外结构与小型内容补充。 |
| `yungs-menu-tweaks` | YUNG's Menu Tweaks | client | 菜单交互细节优化。 |
| `zoomify` | Zoomify | client | 可配置平滑缩放镜头。 |

</details>

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
sudo pacman -S jdk21-openjdk tmux
```

---

## 🖥 服务器部署指南

### 1. 零门槛一键启动 (推荐)
本项目脚本已实现 **“全栈自动化”**，你只需安装 `mise` 并克隆仓库，剩下的交给脚本。

```bash
# 1. 克隆/进入目录
cd solworld

# 2. 直接运行启动脚本
chmod +x start.sh
./start.sh
```

**脚本会为你自动完成所有繁琐工作：**
- **环境初始化**: 自动通过 `mise` 安装并配置专属的 Java 21。
- **服务端核心安装**: 自动根据 `pack.toml` 的版本信息下载 Fabric 核心，重命名并**自动同意 EULA**。
- **资源同步**: 自动调用 `packwiz` 拉取所有 Mod、插件及其精调配置文件。
- **后台持久化**: 自动创建 `tmux` 会话，即便关闭终端，服务器依然运行。
- **智能运维**: 动态内存调优、崩溃 10 秒自启动、日志自动 Gzip 归档。

### 1.1 JVM（Generational ZGC）内存策略
`start.sh` 默认采用 Java 21 的分代 ZGC，并使用“硬上限 + 软上限”模型：
- `SOLWORLD_MAX_HEAP_MB=10240`：硬上限（对应 `-Xmx`）
- `SOLWORLD_SOFT_HEAP_MB=6144`：软上限（对应 `-XX:SoftMaxHeapSize`）
- `SOLWORLD_INIT_HEAP_MB=1024`：初始堆（对应 `-Xms`）
- `SOLWORLD_RESERVED_MB=2048`：系统保留内存（避免吃满宿主机）

示例（10G 硬上限 + 6G 软上限）：
```bash
SOLWORLD_MAX_HEAP_MB=10240 \
SOLWORLD_SOFT_HEAP_MB=6144 \
SOLWORLD_INIT_HEAP_MB=1024 \
./start.sh
```

### 2. 控制台管理
- **进入控制台**: `tmux attach -t solworld`
- **退出控制台 (不停止服务器)**: 按 `Ctrl + B` 然后按 `D`。

---

## ⚙ 服务端核心配置

### 1. `server.properties` 推荐设置
```properties
online-mode=false           # 允许离线玩家登录
view-distance=10            # 渲染视距
simulation-distance=8       # 模拟视距
sync-chunk-writes=false     # 极大提升性能
allow-flight=true           # 开启飞行许可 (防止鞘翅误判)
max-tick-time=120000        # 增加超时检测时间，防止卡顿导致停机
```

### 2. 核心保护插件
- **Flan**: 领地保护。防止苦力怕炸图及玩家间非授权破坏。
- **Textile Backup**: 定时自动备份，默认存放于 `backup/` 文件夹。
- **LuckPerms**: 权限管理。使用 `/lp editor` 在线管理组与权限。

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
| **性能诊断** | `/spark profiler` | 采样分析性能瓶颈 |

---

## 🔄 开发者维护流

### 1. 添加新 Mod
```bash
packwiz modrinth add <mod-slug>
```
**注意：** 添加渲染增强类 Mod (如 Iris, Sodium) 后，必须编辑 `mods/xxx.pw.toml`，确保：
`side = "client"`

### 2. 更新配置文件
修改 `config/` 下的任何文件后，运行：
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

### 推荐分发模式（稳定）
- **首次安装**：使用与 `pack.toml` 版本一致的 `mrpack` 完整安装客户端。
- **后续更新**：发布新版本 `mrpack` 后，玩家在启动器重新导入同版本包即可完成更新。
- **维护建议**：发布时同步提供版本号与更新日志，方便玩家确认是否需要更新客户端实例。

### 发版流程（维护者）
1. 更新 `pack.toml` 版本号，完成模组/配置改动后执行 `packwiz refresh`。
2. 运行 `scripts/export-mrpack.sh` 导出对应版本 `mrpack`（输出到 `output/`）。
3. 重启服务器，确认 `packwiz` 同步与服务器启动正常。
4. 分发 `output/Solworld-<version>.mrpack` 给玩家，并在公告中标注对应版本号。

### 玩家安装步骤
1. 导入 `mrpack`：
   - **XMCL**：点击“导入整合包”并选择文件。
   - **Prism Launcher**：点击“添加实例” -> “从 mrpack 导入”。
2. 启动游戏并进服。
3. 后续版本更新时，重新导入新版本 `mrpack`，并使用与服务端一致的版本号。
