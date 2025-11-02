# Repository Guidelines

## Project Structure & Module Organization
- `datebase/isar_notion_sync_starter`: Flutter/Dart app and sync logic.
  - `lib/data`: adapters, local Isar schemas/services, models, remote API.
  - `lib/sync`: schedulers and handlers.
  - `lib/main.dart`: app entry. Config in `pubspec.yaml`.
- `designDoc`: architecture and database PDFs (read-only).
- `README.md`: high-level overview and context.

## Build, Test, and Development Commands
Run from `datebase/isar_notion_sync_starter`:
- Setup: `flutter pub get` (or `dart pub get` if no widgets).
- Run app: `flutter run` (optionally `-d windows|macos|ios|android|chrome`).
- Analyze: `dart analyze .` (or `flutter analyze`).
- Format: `dart format .` (add trailing commas to help).
- Tests: `flutter test` (or `dart test` for pure Dart).

## Coding Style & Naming Conventions
- Dart style, 2-space indent, no tabs; prefer `final`/`const`.
- Files `lower_snake_case.dart`; classes `UpperCamelCase`;
  variables/functions `lowerCamelCase`; enums `UpperCamelCase`.
- Keep modules small: `data/{models,local,remote,adapters}` and `sync/*`.
- Imports: prefer `package:<name>/...` over relative when possible.
- Lints: run `dart analyze` before pushing; ensure zero warnings.

## Testing Guidelines
- Framework: `flutter_test`/`test` under `test/` with `_test.dart` suffix
  (e.g., `test/notion_api_test.dart`). Use AAA and `group` judiciously.
- Mocks: favor fakes for models; isolate network with adapters.
- Coverage goal: 80%+ for `data/*` and `sync/*`. Run `flutter test` locally.

## Commit & Pull Request Guidelines
- Commits: imperative mood, concise subject (<72 chars). Optional types:
  `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
- PRs: clear description, linked issues, steps to validate, and screenshots
  for UI-affecting changes. Ensure analysis/formatting/tests pass.

## Security & Configuration Tips
- Do not commit secrets (e.g., Notion tokens). Load via env/config and
  add local files to `.gitignore`.
- Avoid network calls in unit tests; mock `remote` layer.

## Agent-Specific Notes
- Scope: this file governs the entire repo. Keep changes focused and
  consistent with existing module boundaries and naming.
