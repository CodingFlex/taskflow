# TaskFlow Architecture Documentation

This document provides an in-depth look at the architectural decisions and patterns used in TaskFlow.


TaskFlow follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────┐
│          UI Layer (Views)           │
│  - Screens, Widgets, Components     │
└──────────────┬──────────────────────┘
               │ User Interactions
┌──────────────▼──────────────────────┐
│     ViewModel Layer (State)         │
│  - Business Logic, State Management │
└──────────────┬──────────────────────┘
               │ Data Requests
┌──────────────▼──────────────────────┐
│    Repository Layer (Data)          │
│  - Data Aggregation, Caching        │
└──────────────┬──────────────────────┘
               │
      ┌────────┴────────┐
      │                 │
┌─────▼──────┐   ┌─────▼──────┐
│  Services  │   │  Services  │
│   (API)    │   │  (Local)   │
└────────────┘   └────────────┘
```

## MVVM Pattern

### Model
**Location:** `lib/models/`

Immutable data classes representing domain entities:
```dart
@freezed
class Task with _$Task {
  const Task._();
  
  @HiveType(typeId: 0)
  factory Task({
    required int id,
    required String title,
    String? description,
    required DateTime createdAt,
    // ...
  }) = _Task;
}
```

**Benefits:**
- Type safety
- Immutability
- Built-in equality and copyWith
- Serialization/Deserialization

### View
**Location:** `lib/ui/screens/`

Stateless widgets that observe ViewModels:
```dart
class HomeView extends StackedView<HomeViewModel> {
  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      // UI builds from viewModel state
      body: viewModel.isBusy 
        ? LoadingWidget() 
        : TaskListWidget(tasks: viewModel.tasks),
    );
  }
  
  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
```

**Characteristics:**
- No business logic
- Purely presentation
- Reacts to ViewModel changes
- Delegates user actions to ViewModel

### ViewModel
**Location:** `lib/viewmodels/`

Manages state and business logic:
```dart
class HomeViewModel extends BaseViewModel {
  final _repository = locator<TaskRepository>();
  
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  
  Future<void> loadTasks() async {
    setBusy(true);
    _tasks = await _repository.getTasks();
    setBusy(false);
  }
  
  void deleteTask(int id) {
    _repository.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners(); // UI rebuilds
  }
}
```

**Responsibilities:**
- State management
- User interaction handling
- Coordinating service calls
- UI state (loading, error, success)
- Navigation

## Offline-First Strategy

### Core Principle
**Local storage is the single source of truth.**

### Implementation

```dart
class TaskRepository {
  /// Toggle: false = Hive (instant), true = API (paginated)
  static const bool _usePagination = false;
  
  Future<List<Task>> getTasks() async {
    // 1. Return cached data immediately
    final localTasks = await _storageService.getTasks();
    if (localTasks.isNotEmpty) {
      _fetchInBackground(); // Non-blocking sync
      return localTasks;
    }
    
    // 2. Fetch from API only if cache is empty
    try {
      final apiTasks = await _taskService.fetchTasks();
      // Note: Not saving to cache for demo purposes
      return localTasks; // Still return local
    } catch (e) {
      // 3. Graceful degradation
      return localTasks; // Return whatever we have
    }
  }
  
  Future<Task> createTask(Task task) async {
    // 1. Save locally first
    await _storageService.saveTask(task);
    
    // 2. Sync with API (fire-and-forget)
    try {
      await _taskService.createTask(task);
    } catch (e) {
      // Log but don't fail - task already saved locally
    }
    
    return task;
  }
}
```

### Benefits
- Instant UI updates
- Works without internet  
- No loading spinners for writes  
- Resilient to network failures  
- Better user experience

## Pagination Architecture

**Key Insight:** Pagination is implemented but disabled for Hive since local storage loads instantly. It's ready for future API integration.

### Why Disabled for Hive?
- Hive loads all tasks instantly (no network latency)
- Pagination would create artificial delays
- Goes against offline-first principle

### Implementation
```dart
class TaskRepository {
  static const bool _usePagination = false; // Toggle for API mode
  
  // When false: Returns all tasks from Hive
  Future<List<Task>> getTasks() async {
    return await _storageService.getTasks();
  }
  
  // When true: Paginates API results
  Future<PaginatedTaskResult> getTasksPaginated({
    required int page,
    required int pageSize,
  }) async {
    final allTasks = await _taskService.fetchTasks();
    // Client-side slicing logic...
    return PaginatedTaskResult(tasks: pagedTasks, hasMore: hasMore);
  }
}
```

### UI Components Ready
- `PaginatedTaskList` widget with "Load More" button
- `HomeView` conditionally renders based on `usePagination` flag
- All features work (filters, search, sorting)

**Enable when:** Migrating to real backend API with large datasets. Just flip `_usePagination = true`.  

## Data Flow

### Read Operation (GET)
```
User Taps Screen
       │
       ▼
    ViewModel
       │
       ▼
   Repository ──┬──> Local Storage (Hive)
                │         │
                │         ▼
                │    Return Data ──> Update UI
                │
                └──> API Call (Background)
                          │
                          ▼
                     Log Result
                     (Don't merge)
```

### Write Operation (CREATE/UPDATE/DELETE)
```
User Saves Task
       │
       ▼
    ViewModel
       │
       ▼
   Repository ──> Local Storage (Hive)
       │               │
       │               ▼
       │          Immediate Success
       │               │
       │               ▼
       │          Update UI
       │
       └──> API Call (Background)
                    │
                    ▼
               Log Result
            (Success/Failure)
```

## Key Design Patterns

### 1. Repository Pattern
**Purpose:** Abstract data sources

```dart
class TaskRepository {
  final TaskService _apiService;
  final StorageService _localService;
  
  // Single interface for both sources
  Future<List<Task>> getTasks();
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<bool> deleteTask(int id);
}
```

**Benefits:**
- ViewModels don't know about data sources
- Easy to swap implementations
- Centralized caching logic
- Testable with mocks

### 2. Service Locator (Dependency Injection)
**Implementation:** `get_it` package

```dart
// app/app.dart
@StackedApp(
  routes: [...],
  dependencies: [
    LazySingleton(classType: TaskRepository),
    LazySingleton(classType: StorageService),
    LazySingleton(classType: TaskService),
  ],
)
class App {}

// Usage in ViewModel
class HomeViewModel extends BaseViewModel {
  final _repository = locator<TaskRepository>();
}
```

**Benefits:**
- Loose coupling
- Easy testing (swap with mocks)
- Single instance management
- Clean initialization

### 3. Observer Pattern
**Implementation:** `notifyListeners()` from `ChangeNotifier`

```dart
class HomeViewModel extends BaseViewModel {
  void updateFilter(TaskFilter filter) {
    _filter = filter;
    rebuildUi(); // All observers rebuild note: Could also use notifyListeners();
  }
}
```

## Service Layer

### 1. StorageService (Hive)
**Responsibility:** Local data persistence

```dart
class StorageService {
  Box<Task>? _taskBox;
  
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    _taskBox = await Hive.openBox<Task>('tasks');
  }
  
  Future<List<Task>> getTasks() async {
    return _taskBox?.values.toList() ?? [];
  }
  
  Future<void> saveTask(Task task) async {
    await _taskBox?.put(task.id, task);
  }
}
```

### 2. TaskService (API)
**Responsibility:** Remote API communication

```dart
class TaskService {
  final ApiClient _client;
  final URLProvider _urlProvider;
  
  Future<List<Task>> fetchTasks() async {
    final response = await _client.get(_urlProvider.tasksEndpoint);
    return (response.data as List)
        .map((json) => Task.fromJson(json))
        .toList();
  }
}
```

### 3. BiometricsService
**Responsibility:** Device authentication

```dart
class BiometricsService {
  final LocalAuthentication _auth = LocalAuthentication();
  
  Future<bool> isBiometricsAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final available = await _auth.getAvailableBiometrics();
    return canCheck && available.isNotEmpty;
  }
  
  Future<bool> authenticateUser() async {
    return await _auth.authenticate(
      localizedReason: 'Authenticate to access TaskFlow',
    );
  }
}
```

### 4. ToastService
**Responsibility:** User notifications

```dart
class ToastService {
  void showSuccess({required String message}) {
    toastification.show(
      type: ToastificationType.success,
      title: Text('Success'),
      description: Text(message),
    );
  }
  
  void showError({required String message}) {
    toastification.show(
      type: ToastificationType.error,
      title: Text('Error'),
      description: Text(message),
    );
  }
}
```

## Error Handling

### Layered Error Handling

```
┌────────────────────────────┐
│  UI Layer (Toast/Snackbar) │
└─────────────┬──────────────┘
              │ User-Friendly Messages
┌─────────────▼──────────────┐
│  ViewModel (Try-Catch)      │
└─────────────┬──────────────┘
              │ ApiException
┌─────────────▼──────────────┐
│  Repository (Transform)     │
└─────────────┬──────────────┘
              │ HTTP/Dio Errors
┌─────────────▼──────────────┐
│  Service (Raw Exceptions)   │
└────────────────────────────┘
```

### ApiException Class

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ErrorType type;
  
  String get userMessage {
    return switch (type) {
      ErrorType.network => 'No internet connection',
      ErrorType.timeout => 'Request timed out',
      ErrorType.notFound => 'Resource not found',
      ErrorType.server => 'Server error occurred',
      _ => message,
    };
  }
}
```

### ViewModel Error Handling

```dart
Future<void> loadTasks() async {
  try {
    setBusy(true);
    _tasks = await _repository.getTasks();
  } on ApiException catch (e) {
    _toastService.showError(message: e.userMessage);
  } catch (e) {
    _toastService.showError(message: 'An unexpected error occurred');
    _logger.e('Error loading tasks', error: e);
  } finally {
    setBusy(false);
  }
}
```

## State Management

### Busy States

```dart
// Global busy state
setBusy(true); // Entire ViewModel busy
bool get isBusy => busy(this);

// Object-specific busy states
setBusyForObject('delete', true);
bool get isDeleting => busy('delete');

setBusyForObject('sync', true);
bool get isSyncing => busy('sync');
```

### Reactive Updates

```dart
// Automatic notification
void setFilter(TaskFilter filter) {
  _filter = filter;
  rebuildUi(); // UI rebuilds
}

// Manual notification (when mutating lists)
void addTask(Task task) {
  _tasks.add(task);
  notifyListeners();
}
```

## Navigation

### Stacked Router

```dart
// Declarative routing
@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: BiometricView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: TaskDetailsView),
  ],
)

// Programmatic navigation
_navigationService.navigateToTaskDetailsView(taskId: 123);
_navigationService.back();
_navigationService.replaceWithHomeView();
```

## Testing Strategy

### Unit Tests (ViewModels)
```dart
test('should load tasks from repository', () async {
  final mockRepo = MockTaskRepository();
  when(mockRepo.getTasks()).thenAnswer((_) async => [task1, task2]);
  
  final viewModel = HomeViewModel();
  await viewModel.loadTasks();
  
  expect(viewModel.tasks.length, 2);
  verify(mockRepo.getTasks()).called(1);
});
```

### Widget Tests (UI)
```dart
testWidgets('displays task card correctly', (tester) async {
  await tester.pumpWidget(
    TaskCard(
      task: testTask,
      onTap: () {},
    ),
  );
  
  expect(find.text('Test Task'), findsOneWidget);
  expect(find.byType(MSHCheckbox), findsOneWidget);
});
```


## Scalability

### Current Scale
- Supports thousands of tasks
- In-memory filtering/sorting
- Single-user architecture

### Future Scale
- Implement database-level filtering
- Add pagination to database queries
- Multi-user with backend sync
- Cloud backup and restore


