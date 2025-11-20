import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.bottomsheets.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/commands/command_manager.dart';
import 'package:taskflow/commands/update_task_command.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/models/paginated_result.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:taskflow/helpers/logger_helper.dart';

import 'package:taskflow/ui/screens/statistics/statistics_view.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';
import 'package:stacked_services/stacked_services.dart';

enum TaskFilter { all, completed, pending }

/// Manages home screen state including task filtering, sorting, search, and connectivity
class HomeViewModel extends BaseViewModel {
  final _logger = createLogger();
  final _bottomSheetService = locator<BottomSheetService>();
  final _taskRepository = locator<TaskRepository>();
  final _toastService = locator<ToastService>();
  final _commandManager = locator<CommandManager>();

  final TextEditingController searchController = TextEditingController();
  TaskFilter _selectedFilter = TaskFilter.all;
  SortOption _sortOption = SortOption.dueDate;
  TaskCategory? _selectedCategory;

  List<Task> _tasks = [];
  String? _errorMessage;
  InternetStatus _connectionStatus = InternetStatus.connected;
  StreamSubscription<InternetStatus>? _internetSubscription;

  Timer? _statusDebounceTimer;
  InternetStatus? _lastStableStatus;
  int _consecutiveOnlineEvents = 0;
  int _consecutiveOfflineEvents = 0;
  int _capturedConsecutiveOnlineEvents = 0;
  int _capturedConsecutiveOfflineEvents = 0;
  static const int _requiredStableEvents = 1;
  static const _statusStabilizationDuration = Duration(seconds: 3);

  TaskFilter get selectedFilter => _selectedFilter;
  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _connectionStatus == InternetStatus.connected;

  /// Check if pagination is enabled (for API mode)
  bool get usePagination => _taskRepository.shouldUsePagination;

  List<Task> get filteredTasks {
    var tasks = List<Task>.from(_tasks);

    if (searchController.text.isNotEmpty) {
      final query = searchController.text.toLowerCase();
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    switch (_selectedFilter) {
      case TaskFilter.completed:
        tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
        break;
      case TaskFilter.pending:
        tasks = tasks.where((t) => t.status == TaskStatus.pending).toList();
        break;
      case TaskFilter.all:
        break;
    }

    if (_selectedCategory != null) {
      tasks = tasks.where((t) => t.category == _selectedCategory).toList();
    }

    switch (_sortOption) {
      case SortOption.dateCreated:
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.title:
        tasks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.dueDate:
        tasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
    }

    return tasks;
  }

  void setFilter(TaskFilter filter) {
    _selectedFilter = filter;
    rebuildUi();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    rebuildUi();
  }

  void setCategory(TaskCategory? category) {
    _selectedCategory = category;
    rebuildUi();
  }

  void onSearchChanged(String value) {
    rebuildUi();
  }

  Future<void> toggleTheme() async {
    final context = StackedService.navigatorKey!.currentContext;
    if (context == null) return;

    final adaptiveTheme = AdaptiveTheme.of(context);
    final currentMode = adaptiveTheme.mode;

    AdaptiveThemeMode newTheme;
    if (currentMode == AdaptiveThemeMode.light) {
      newTheme = AdaptiveThemeMode.dark;
    } else if (currentMode == AdaptiveThemeMode.dark) {
      newTheme = AdaptiveThemeMode.light;
    } else {
      final isCurrentlyDark = Theme.of(context).brightness == Brightness.dark;
      newTheme = isCurrentlyDark
          ? AdaptiveThemeMode.light
          : AdaptiveThemeMode.dark;
    }

    adaptiveTheme.setThemeMode(newTheme);
  }

  Future<void> showMoreFilters() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.moreFilters,
      data: {
        'initialSortOption': _sortOption,
        'initialCategory': _selectedCategory,
      },
    );

    if (response?.confirmed == true && response?.data != null) {
      final data = response!.data as Map<String, dynamic>;
      if (data.containsKey('sortOption')) {
        _sortOption = data['sortOption'] as SortOption;
      }
      if (data.containsKey('category')) {
        _selectedCategory = data['category'] as TaskCategory?;
      }
      rebuildUi();
    }
  }

  Future<void> navigateToTaskDetails(Task task) async {
    final shouldRefresh =
        await Navigator.of(StackedService.navigatorKey!.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(
              taskId: task.id,
              heroTag: 'task_${task.id}',
              task: task,
              onTaskChanged: () => loadTasks(forceRefresh: true),
            ),
            settings: const RouteSettings(name: Routes.taskDetailsView),
          ),
        );

    if (shouldRefresh == true) {
      await loadTasks(forceRefresh: true);
    }
  }

  Future<void> navigateToAddTask() async {
    final shouldRefresh =
        await Navigator.of(StackedService.navigatorKey!.currentContext!).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(
              heroTag: 'add_task_fab',
              onTaskChanged: () => loadTasks(forceRefresh: true),
            ),
            settings: const RouteSettings(name: Routes.taskDetailsView),
          ),
        );

    if (shouldRefresh == true) {
      await loadTasks(forceRefresh: true);
    }
  }

  void navigateToStatistics() {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => StatisticsView(
          heroTag: 'statistics_button',
          tasks:
              filteredTasks, // Pass the already-loaded tasks - no loading needed!
        ),
        settings: const RouteSettings(name: Routes.statisticsView),
      ),
    );
  }

  Future<void> toggleTaskComplete(Task task) async {
    final updatedTask = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed,
      completedAt: task.status == TaskStatus.completed ? null : DateTime.now(),
    );

    _updateTaskInList(updatedTask);

    try {
      final command = UpdateTaskCommand(
        oldTask: task,
        newTask: updatedTask,
        repository: _taskRepository,
      );

      await _commandManager.executeCommand(command);

      _toastService.showSuccess(
        message: updatedTask.status == TaskStatus.completed
            ? ksTaskMarkedCompleted
            : ksTaskMarkedPending,
        duration: const Duration(seconds: 4),
        onUndoPressed: () async {
          await _commandManager.undo();
          await loadTasks(forceRefresh: true);
        },
      );
    } on ApiException catch (e) {
      _updateTaskInList(task);
      _toastService.showError(message: e.userMessage);
    }
  }

  void _updateTaskInList(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      rebuildUi();
    }
  }

  Future<void> loadTasks({
    bool forceRefresh = false,
    bool syncFirst = false,
  }) async {
    final shouldToggleBusy = !forceRefresh;
    if (shouldToggleBusy) {
      setBusy(true);
    }
    _errorMessage = null;

    try {
      // Sync offline changes first if requested
      if (syncFirst && isOnline) {
        await _syncOfflineChanges();
      }

      _tasks = await _taskRepository.getTasks(forceRefresh: forceRefresh);
    } on ApiException catch (e) {
      _errorMessage = e.userMessage;
      _toastService.showError(message: e.userMessage);
    } catch (e) {
      _errorMessage = ksUnexpectedError;
      _toastService.showError(message: ksFailedToLoadTasks);
    } finally {
      if (shouldToggleBusy) {
        setBusy(false);
      } else {
        rebuildUi();
      }
    }
  }

  Future<void> refreshTasks() async {
    await loadTasks(forceRefresh: true);
  }

  /// Fetches tasks with pagination (only when usePagination is true)
  /// Applies same filtering/sorting as filteredTasks
  Future<PaginatedTaskResult> getTasksPaginated({
    required int page,
    required int pageSize,
  }) async {
    try {
      // Get paginated result from repository
      final result = await _taskRepository.getTasksPaginated(
        page: page,
        pageSize: pageSize,
      );

      // Apply filtering and sorting to paginated tasks
      var tasks = result.tasks;

      // Search filter
      if (searchController.text.isNotEmpty) {
        final query = searchController.text.toLowerCase();
        tasks = tasks.where((task) {
          return task.title.toLowerCase().contains(query) ||
              task.description.toLowerCase().contains(query);
        }).toList();
      }

      // Status filter
      switch (_selectedFilter) {
        case TaskFilter.completed:
          tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
          break;
        case TaskFilter.pending:
          tasks = tasks.where((t) => t.status == TaskStatus.pending).toList();
          break;
        case TaskFilter.all:
          break;
      }

      // Category filter
      if (_selectedCategory != null) {
        tasks = tasks.where((t) => t.category == _selectedCategory).toList();
      }

      // Sorting
      switch (_sortOption) {
        case SortOption.dateCreated:
          tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortOption.title:
          tasks.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortOption.dueDate:
          tasks.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
          break;
      }

      return PaginatedTaskResult(
        tasks: tasks,
        page: result.page,
        pageSize: result.pageSize,
        totalTasks: result.totalTasks,
        hasMore: result.hasMore,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _onInternetStatusChanged(InternetStatus status) {
    _logger.i('Internet status changed: $status');

    if (status == InternetStatus.connected) {
      _consecutiveOnlineEvents++;
      _consecutiveOfflineEvents = 0;
    } else {
      _consecutiveOfflineEvents++;
      _consecutiveOnlineEvents = 0;
    }

    _connectionStatus = status;
    rebuildUi();

    _statusDebounceTimer?.cancel();

    _capturedConsecutiveOnlineEvents = _consecutiveOnlineEvents;
    _capturedConsecutiveOfflineEvents = _consecutiveOfflineEvents;
    final capturedStatus = status;

    _statusDebounceTimer = Timer(_statusStabilizationDuration, () async {
      final wasOnline = _lastStableStatus == InternetStatus.connected;
      final isNowOnline = capturedStatus == InternetStatus.connected;

      _logger.i(
        'Debounce completed: wasOnline=$wasOnline, isNowOnline=$isNowOnline, '
        'consecutiveOnline=$_capturedConsecutiveOnlineEvents, '
        'consecutiveOffline=$_capturedConsecutiveOfflineEvents',
      );

      final hasRequiredStability = capturedStatus == InternetStatus.connected
          ? _capturedConsecutiveOnlineEvents >= _requiredStableEvents
          : _capturedConsecutiveOfflineEvents >= _requiredStableEvents;

      if (!hasRequiredStability) {
        _logger.i(
          'Status change skipped - insufficient consecutive confirmations (required: $_requiredStableEvents, got: ${capturedStatus == InternetStatus.connected ? _capturedConsecutiveOnlineEvents : _capturedConsecutiveOfflineEvents})',
        );
        return;
      }

      if (_lastStableStatus == capturedStatus) {
        _logger.i('Status unchanged, skipping');
        return;
      }

      // Update stable status BEFORE checking for pending operations
      final previousStableStatus = _lastStableStatus;
      _lastStableStatus = capturedStatus;
      _consecutiveOnlineEvents = 0;
      _consecutiveOfflineEvents = 0;

      _logger.i(
        'Status transition confirmed: ${previousStableStatus?.name ?? "unknown"} -> ${capturedStatus.name}',
      );

      // Check if transitioning from offline to online
      final wasActuallyOffline =
          previousStableStatus == InternetStatus.disconnected;

      if (wasActuallyOffline && isNowOnline) {
        _logger.i('Coming back online - checking for pending operations...');
        final hasPending = await _taskRepository.hasPendingOperations();
        _logger.i('Pending operations check result: $hasPending');

        if (hasPending) {
          _logger.i('Pending operations found - triggering auto-sync');
          _syncOfflineChanges().catchError((error) {
            _logger.e('Error in automatic sync: $error');
          });
        } else {
          _logger.i('No pending operations, skipping sync');
        }
      }
    });
  }

  Future<void> _syncOfflineChanges() async {
    try {
      _logger.i('Triggering offline changes sync...');
      final hadPendingChanges = await _taskRepository.syncOfflineChanges();

      if (hadPendingChanges) {
        _logger.i('Offline changes synced successfully');
        _toastService.showSuccess(
          message: ksOfflineChangesSynced,
          duration: const Duration(seconds: 3),
        );
        await loadTasks(forceRefresh: true, syncFirst: false);
      } else {
        _logger.i('No pending changes to sync');
      }
    } catch (e, stackTrace) {
      _logger.e('Sync failed: $e', error: e, stackTrace: stackTrace);
      _toastService.showError(
        message: 'Failed to sync offline changes',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> syncWithServer() async {
    if (!isOnline) {
      _toastService.showError(message: ksNoInternetConnection);
      return;
    }

    setBusyForObject('sync', true);
    try {
      _logger.i('Manual sync: checking for offline changes...');
      final hadPendingChanges = await _taskRepository.syncOfflineChanges();

      if (hadPendingChanges) {
        _logger.i('Manual sync: offline changes synced successfully');
        _toastService.showSuccess(
          message: ksOfflineChangesSynced,
          duration: const Duration(seconds: 2),
        );
      }

      _logger.i('Manual sync: fetching latest from server...');
      await _taskRepository.syncWithServer();
      await loadTasks(forceRefresh: true);
      _toastService.showSuccess(message: ksSyncCompletedSuccess);
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusyForObject('sync', false);
    }
  }

  bool get isSyncing => busy('sync');

  void initialize() {
    // Don't set _lastStableStatus here - let it remain null initially
    // This allows the first status change to be properly detected
    loadTasks(syncFirst: true);

    _internetSubscription = InternetConnection.createInstance(
      checkInterval: const Duration(seconds: 2),
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse('https://icanhazip.com/')),
        InternetCheckOption(uri: Uri.parse('https://google.com')),
      ],
    ).onStatusChange.listen(_onInternetStatusChanged);
  }

  @override
  void dispose() {
    _statusDebounceTimer?.cancel();
    _internetSubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
