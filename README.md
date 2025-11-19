# TaskFlow

TaskFlow is an offline-first task manager built with Flutter, Hive, and the Stacked MVVM framework. It keeps local data authoritative, syncs with the JSONPlaceholder API for demo purposes, and adds polish such as biometric auth, animations, and undo/redo for critical actions. JSONPlaceholder provides the fake REST backend used in this project.[^jsonplaceholder]

[^jsonplaceholder]: JSONPlaceholder – free fake online REST API for testing <https://jsonplaceholder.typicode.com>

## Highlights
- Offline CRUD with Hive; API sync happens opportunistically when connectivity returns.
- Search, filters, sorting, due-date tracking, and a statistics dashboard.
- Undo/redo for delete and update via a Command Pattern history.
- Hero animations, Skeletonizer loading states, and RepaintBoundary wrappers around hot widgets (task cards, stat cards) to reduce repaint cost.
- Adaptive light/dark themes and optional biometric auth on app launch.

## Part 5 features
- Advanced search plus layered filters (status, category, sort by due date/title/created).
- Custom animations on hero transitions, checkbox toggles, pull-to-refresh, and skeleton loading.
- Dark mode switch with persisted preference via `adaptive_theme`.
- Real-time, animated inline validation using `AnimatedFieldError`.
- Performance tweaks such as const constructors, debounced search, and RepaintBoundary around frequently repainted widgets.

## Architecture & Data Flow
- **Presentation**: Views call ViewModels (Stacked) which only expose UI state and intents.
- **Domain/Data**: ViewModels talk to `TaskRepository`, which decides between Hive and the demo API, handles sync/debounced connectivity, and stores pending operations for offline replay.
- **Services**: `TaskService` wraps Dio + `ApiClient`, while `StorageService` encapsulates Hive boxes.
- **Patterns**: MVVM, Repository, Command Pattern (undo/redo), dependency injection via `get_it`.
- Pagination support exists for real APIs but stays disabled for Hive because local reads are effectively instant.

## State management
Stacked (MVVM) drives every screen. Views remain declarative, ViewModels expose state and actions, `CommandManager` supplies undo/redo for delete/update, and `get_it` wires dependencies together.

## How to run the app
1. **Clone & install**
   ```bash
   git clone <repository-url>
   cd taskflow
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
2. **Environment file**  
   Create a `.env` file at the project root before running the app:
   ```
   API_BASE_URL=https://jsonplaceholder.typicode.com
   ```
   Additional secrets can live here as needed.
3. **Run**
   ```bash
   flutter run
   ```

## Tests
- **Unit tests**
  ```bash
  flutter test test/models/task_test.dart test/viewmodels/home_viewmodel_test.dart
  ```
- **Widget tests**
  ```bash
  flutter test test/ui
  ```
- **Full sweep**
  ```bash
  flutter test
  ```
Unit tests cover model helpers and the HomeViewModel filter/search logic; widget tests ensure the primary screens render correctly under mocked services.

## Trade-offs
- Conflict resolution is “last write wins” from the device; merging strategies were deferred to keep the scope achievable.
- Background sync only runs while the app is alive (connectivity listener + manual WiFi button). WorkManager/Firebase jobs were out-of-scope.
- Pagination is wired but disabled because Hive loads instantly; fake paging would slow the offline experience.
- Test coverage concentrates on critical logic and smoke tests rather than full end-to-end flows due to time constraints.

## Known issues / limitations
- No automatic merge when both local and remote copies change while offline.
- No cloud backup or multi-device sync; Hive stays local.
- Notifications, recurring tasks, and calendar integrations are not yet implemented.
- Sync only triggers when connectivity returns or when the user taps the WiFi icon; background services do not fire after app termination.

## Notes & Future Enhancements
- Add timestamp-aware conflict handling before pushing updates to the API.
- Hook WorkManager/ForegroundService for reliable background sync.
- Flip `_usePagination` once a real paginated backend is available.