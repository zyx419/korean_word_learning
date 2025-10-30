# Isar + Notion 同步骨架

最小可运行的目录与接口，用于韩语单词学习 App：
- Isar 模型与索引
- Notion 适配器雏形 `toNotion()/fromNotion()`
- 同步调度器接口与最小实现
- 本地 Isar 初始化服务
- 远端 Notion API 封装（示例 stub）

## 快速开始
1. 在 `pubspec.yaml` 中调整 isar 版本号后执行：
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
2. 在 `main.dart` 初始化 `IsarService` 后运行应用。
3. 保存/删除模型时，调用 `SyncScheduler.enqueue(...)` 入队。

用法要点：


运行 dart run build_runner build --delete-conflicting-outputs 生成 Isar *.g.dart。


在 main.dart 保留 IsarService.init()。


将 Notion 的 databaseId/token 接到 NotionApi 与 SentenceSyncHandler。 

