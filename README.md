# TaskFlow

TaskFlow is an offline-first task manager built with Flutter, Hive, and the Stacked MVVM framework. It keeps local data authoritative, syncs with the JSONPlaceholder API for demo purposes, and adds polish such as biometric auth, animations, and undo/redo for critical actions. JSONPlaceholder provides the fake REST backend used in this project.[^jsonplaceholder]

[^jsonplaceholder]: JSONPlaceholder – free fake online REST API for testing <https://jsonplaceholder.typicode.com>

## Highlights
- Offline CRUD with Hive; API sync happens opportunistically when connectivity returns.
- Search, filters, sorting, due-date tracking, and a statistics dashboard.
- Undo/redo for delete and update via a Command Pattern history.
- Hero animations, Skeletonizer loading states, and RepaintBoundary wrappers around hot widgets (task cards, stat cards) to reduce repaint cost.
- Adaptive light/dark themes and optional biometric auth on app launch.

## Part 5 features (details)
1. **Search & Filter**
   - Case-insensitive search on title/description.
   - Filters for status (all/completed/pending) and category.
   - Sort modes: due date, date created, alphabetical.
2. **Custom Animations**
   - Checkbox animation via `MSHCheckbox`.
   - Hero transitions when opening task details/Statistics.
   - Smooth list insert/remove and pull-to-refresh motion.
3. **Dark Mode**
   - One-tap toggle, powered by `adaptive_theme`.
   - Preference persists locally and restores on boot.
   - Animated brightness change so the switch feels instant.
4. **Form Validation**
   - Title requires ≥3 characters; description limited to 500.
   - Animated inline errors using `AnimatedFieldError`.
   - Save button stays disabled until the form is valid.
5. **Performance Optimization**
   - Lazy-ish loading via “Load More” fallback and pagination-ready repository (flagged off for Hive).
   - Consistent use of const constructors and `Sizer` to avoid layout jank.
   - RepaintBoundary applied to task cards and stat widgets to reduce overdraw.

### Bonus features delivered
- **Task categories** with color coding, wrap layout chips, and filtering.
- **Due dates** with date picker, overdue warning, and sorting.
- **Undo/redo** via Command Pattern history (last five operations, delete/update only).
- **Biometric authentication** using `local_auth`, optional face/fingerprint gate.
- **Data sync** that queues offline POST/PUT/DELETE operations and replays them when the device reconnects.

## Architecture & Data Flow
- **Views** (Flutter widgets) render UI only. They listen to a ViewModel’s state via `StackedView`.
- **ViewModels** hold screen state, handle events, call `TaskRepository`, and expose simple getters (e.g., `filteredTasks`). They use `CommandManager` for undo/redo and `setBusy` for loading indicators.
- **Repository layer** decides if an operation should hit Hive or the remote API. It also keeps track of offline changes and flushes them when the network becomes available.
- **Services**: `StorageService` (Hive) and `TaskService` (Dio + JSONPlaceholder) do the actual persistence/network work.
- **Dependency injection**: `get_it` registers all services, so ViewModels stay easy to test.
- **Design patterns**: MVVM for separation of concerns, Repository for data abstraction, Command Pattern for undo, and Locator for DI.

## State management
- Powered by **Stacked** (an MVVM take). Each screen has a ViewModel that:
  - Exposes derived UI state (`filteredTasks`, `isSyncing`, inline validation errors).
  - Handles user intent (tapping filters, toggling completion, saving/deleting).
  - Calls `rebuildUi()` to notify the view.
- `CommandManager` keeps a small undo history for destructive operations.
- `setBusy` / `setBusyForObject` provide loading flags per widget (e.g., Save button vs Global skeleton).

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