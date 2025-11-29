# Korean Word Learning V1.0 设计文档（2025-11-26）

本文档基于 `datebase/isar_notion_sync_starter` 目录下当前实现整理，覆盖 V1.0 的功能范围、架构设计、数据模型、同步策略与风险提醒，供产品、设计与开发协同使用。

## 1. 版本目标与范围
- 支持韩语单词学习的核心体验：阅读句子、做高亮、记录熟练度、批量整理。
- 在本地离线可用（Isar 数据库），同时与 Notion 三类数据库（句子、高亮、阅读偏好）做双向同步。
- 提供清晰的配置与排障界面，用户可自行绑定 token、触发同步、查看同步队列。
- 提供桌面级批量导入、导出 JSON 配置能力，方便迁移/备份。

## 2. 架构概览
- **Flutter UI 层**：路由在 `lib/main.dart` 注册，包含欢迎、学习、设置、同步队列四个页面。
- **本地存储**：`IsarService` 在应用启动后后台初始化，所有模型通过 Isar collection 持久化。
- **同步层**：
  - `NotionPullService` 在启动或手动触发时批量从 Notion 下行。
  - `NotionPushService` 负责即时推送高亮/句子 CRUD，失败则落入 `SyncSchedulerImpl` 队列。
  - `SyncSchedulerImpl` 承担重试、优先队列与持续运行，配合 `NotionRetrySyncHandler`。
  - `SyncProgressNotifier + SyncNotificationManager` 让同步状态常驻通知栏（Android）。
- **辅助模块**：`AppLogger` 将关键事件写入 `notion_sync.log`；`file_picker` 用于配置导入导出；`flutter_local_notifications` 管理保活通知。

## 3. 功能模块说明
### 3.1 欢迎页 (`lib/ui/pages/welcome_page.dart`)
- 展示产品标语与三个 CTA：开始学习（跳转 `/learn`）、设置 Notion（`/settings`）、查看同步队列（`/sync`）。

### 3.2 单词学习页 (`lib/ui/pages/learning_page.dart`)
- **数据流**：监听 `sentences`、`highlights` collection 的 `watch()` 流，实时反映变更。
- **阅读体验**：
  - 阅读样式：支持 light/sepia/dark 背景，字号 14–22，行距 1.4–2.0，段距 4–16；改动写入 `ReadingPrefs` 并即时渲染。
  - 滚动位置保存：退出时写入 prefs，进入后自动恢复。
- **句子操作**：
  - 左滑删除（带确认）、右滑循环熟练度。
  - 顶部熟练度筛选（`FamiliarState`）+ 批量模式（全选、批量熟练/不熟/一般/删除）。
  - CSV/纯文本导入：逐行解析、去重、生成 `externalKey`，并为新句子 enqueue `SyncScheduler`.
- **高亮与备注**：
  - 长按选区进入 selection palette，提供 4 种颜色和备注编辑。
  - 高亮点击呼出 bottom sheet，可切色、改备注、复制文本、删除。
  - 所有高亮更新走 `NotionPushService.upsertHighlight/deleteHighlight`，失败会 snackbar。

### 3.3 设置页 (`lib/ui/pages/settings_page.dart`)
- **配置管理**：
  - 存储 `NotionAuth`（token/status）与三条 `NotionDatabaseBinding`。
  - 支持从 `--dart-define` 预填默认值。
  - 解析 32 位数据库 ID，允许输入 URL 或纯 ID。
  - JSON 导入/导出 (`SettingsConfig`)：使用 `file_picker` 保存/读取，自动写入 Isar。
- **网络校验**：
  - “保存并测试”调用 `NotionApi.getDatabase`，展示数据库名称、更新时间，将结果写回 `NotionAuth.status/testedAt`。
- **同步工具**：
  - “手动同步”调用 `NotionPullService.pullAll()`，拉取最新数据，并记录 `lastSyncedAt`。
  - 展示上次同步时间与当前状态；支持一键触发。

### 3.4 同步队列页 (`lib/ui/pages/sync_queue_page.dart`)
- 监听 `SyncQueueItem` 流，提供搜索（queueId、本地键、远端 ID）、状态 FilterChip、实体类型 ChoiceChip、排序（更新时间/优先级/创建时间）。
- 列表项展示状态、操作（重试、强制置 pending、取消、删除），展开后可查看 payload 与错误。
- 批量操作菜单：重试所有失败、取消所有 pending、清理成功记录、删除全部。
- 下拉刷新触发 `scheduler.runOnce()`，AppBar 也可手动运行一次同步。

## 4. 数据模型

| Collection | 关键字段 | 说明 |
| --- | --- | --- |
| `Sentence` | `text`, `familiarState`, `externalKey`, `notionPageId`, `syncStatus`, `deletedAt` | 学习主体。`externalKey` 由文本 hash 生成，确保与 Notion 对齐。`syncStatus` 标记推送状态。 |
| `Highlight` | `sentenceLocalId`, `sentenceExternalKey`, `start/end`, `color`, `note`, `deletedAt` | 句内高亮，依赖 `Sentence` 外键。缺失句子时会在 pull 阶段跳过。 |
| `ReadingPrefs` | `theme`, `fontSize`, `lineHeight`, `paragraphSpacing`, `scrollOffset` | 仅保存一条（ID=1），同步到 Notion 的 prefs 库。 |
| `NotionAuth` | `token`, `status`, `testedAt`, `lastSyncedAt`, `errorMessage` | 用于鉴权与健康检查记录。 |
| `NotionDatabaseBinding` | `databaseId`, `databaseName`, `rawUrl`, `boundAt` | ID 1=句子，2=高亮，3=阅读偏好。 |
| `SyncQueueItem` | `entityType`, `op`, `entityLocalKey`, `status`, `priority`, `attempt/maxAttempt` | 后台重试队列，payload 为 JSON 字符串。 |

## 5. 同步策略
### 5.1 启动流程
1. `main()` 初始化通知插件并渲染 UI。
2. 通过 `Future.microtask` 异步执行：
   - `IsarService.init()` 打开数据库。
   - `ensureGlobalSchedulerStarted()`：创建 `SyncSchedulerImpl`、注册 `NotionRetrySyncHandler`、启动 `runContinuous()` 并绑定通知器。
   - `_maybeAutoSync()`：若 `NotionAuth` 存在且距离 `lastSyncedAt` ≥ 4 小时，则触发 `NotionPullService.pullAll()`。

### 5.2 下行（Pull）
- `NotionPullService` 依次处理句子/高亮/阅读偏好：
  - 查询 Notion 数据库，转换为模型（`Sentence.fromNotion` 等）。
  - 通过 `_remoteWins` 比较 `last_edited_time` 与本地 `updatedAtLocal`，解决冲突（最近编辑优先）。
  - 写入 Isar，并在高亮同步时按 `sentenceExternalKey` 回填 `sentenceLocalId`。
  - 同步成功后记录 `lastSyncedAt`。

### 5.3 上行（Push + Queue）
- **即时推送**：
  - 高亮、新建/删除句子等操作优先调用 `NotionPushService` 直接命中 API；成功后更新 `notionPageId` 与 `updatedAtRemote`。
  - 失败时 `_enqueueFailure()` 会将任务以高优先级写入 `SyncQueueItem`，并触发 `scheduler.runOnce()`。
- **延迟同步**：
  - `LearningPage` 在导入/批量更新时调用 `SyncSchedulerImpl.enqueue()`，写入 `SyncQueueItem`（`payload` 存放主数据）。
  - `SyncSchedulerImpl.runContinuous()` 每 300ms 批量拉取 pending（优先级降序、再按时间），调用 handler。
  - handler 成功则标记 `success`，失败按 `maxAttempt`（默认 5 次）重试，超过则置 `failed`。
  - `SyncProgressNotifier` 每次批次结束统计 pending/syncing/failed，并通过通知展示进度。

### 5.4 错误与容错
- `SyncQueuePage` 允许用户手动重试、取消、强制回退状态，便于解锁卡住任务。
- `NotionPushService` 针对缺少 token/数据库的情况直接返回 `skipped` 或 `error`，调用者以 snackbar 告警。
- `NotionPullService` 遇到缺失绑定/空 token 会记录 warning 并跳过，不会阻塞启动。

## 6. 关键用户流程（V1.0）
1. **首次启动**：欢迎页 → 设置页填写 token/数据库 → “保存并测试” → “手动同步” 拉取初始内容 → 返回学习页查看句子。
2. **学习与标注**：
   - 阅读句子，按照熟练度筛选，支持单条左/右滑或批量调整。
   - 长按文本高亮，加备注，或编辑现有高亮。同步成功后 `syncStatus` 置为 success。
3. **批量导入/维护**：
   - 通过 “导入句子” 粘贴多行、CSV（Title, Created, ExternalKey, Extra, Familiar），自动去重与结构化解析。
   - 修改阅读样式并持久化，便于不同设备共享（通过 Notion prefs 库）。
4. **同步排障**：
   - Settings 中查看上次同步时间并手动重拉。
   - Sync Queue 页面按状态筛查失败任务，查看 payload 与错误码，执行重试/取消。

## 7. 平台与依赖
- Flutter SDK >= 3.3，Material 3 UI。
- 主要依赖：`isar` + `isar_generator`、`path_provider`、`http`、`logger`、`flutter_local_notifications`、`file_picker`。
- Android 需开启通知权限用于前台服务保活；iOS/macOS 初始化了 `DarwinInitializationSettings`，但当前仅使用最基本功能。

## 8. 开发与测试建议
- 生成 Isar 代码：`dart run build_runner build --delete-conflicting-outputs`。
- 常规检查：`dart analyze .`、`flutter test`（当前测试覆盖集中在 `test/ui/pages/*`，后续需补全同步层单测）。
- 真机调试建议开启 `--dart-define` 注入测试 token/数据库，避免在源码中写入敏感信息。
- 建议在 Android 真机上验证通知保活与文件选择，在桌面端验证 JSON 导入导出。

## 9. 已知风险与后续计划
- **Notion API 速率限制**：目前无退避策略，大批量导入后可能遭遇 429；需在后续版本加入指数退避与任务分片。
- **高亮与句子耦合**：当本地缺少 `sentenceExternalKey` 匹配时，高亮下行会被跳过；需在导入/创建时强制写入并在 UI 上提示。
- **队列可视化**：当前仅手动刷新，后续可考虑 WebSocket/Stream 直接驱动 UI，同时展示任务耗时。
- **数据加密**：Isar 数据未加密，如涉及多用户需补充本地加密方案。

---
如需查阅交互细节，可结合 `designDoc/5b730e19-...` 等页面规格 PDF；若实现与文档出现差异，以本文档描述的 V1.0 功能为准。

