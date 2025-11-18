import 'dart:math';
import 'package:logger/logger.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/models/paginated_result.dart';
import 'package:taskflow/services/task_service.dart';
import 'package:taskflow/services/storage_service.dart';
import 'package:taskflow/services/api_exceptions.dart';

/// Repository implementing offline-first architecture
/// Local storage is source of truth; API calls are for demo purposes only
class TaskRepository {
  final TaskService _taskService;
  final StorageService _storageService;
  final Logger _logger = Logger();

  /// Toggle pagination: false = Hive (all at once), true = API (client-side pagination)
  static const bool _usePagination = false;

  TaskRepository({TaskService? taskService, StorageService? storageService})
    : _taskService = taskService ?? locator<TaskService>(),
      _storageService = storageService ?? locator<StorageService>();

  bool get shouldUsePagination => _usePagination;

  /// Fetches all tasks using offline-first approach
  /// Returns local cache immediately, then syncs with API in background
  Future<List<Task>> getTasks({bool forceRefresh = false}) async {
    try {
      final localTasks = await _storageService.getTasks();

      if (!forceRefresh && localTasks.isNotEmpty) {
        _logger.i('Loaded ${localTasks.length} tasks from local storage');
        _fetchAndCacheTasksInBackground();
        return localTasks;
      }

      _logger.i('Fetching tasks from API (local cache only)');
      final remote = await _taskService.fetchTasks();
      _logger.i('API responded with ${remote.length} tasks');

      return await _storageService.getTasks();
    } on ApiException catch (e) {
      _logger.w('API Error (${e.statusCode}): ${e.message}');

      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('Falling back to ${localTasks.length} cached tasks');
        return localTasks;
      }

      throw ApiException(
        'Unable to fetch tasks. ${e.userMessage}',
        statusCode: e.statusCode,
        type: e.type,
        originalError: e,
        endpoint: e.endpoint,
      );
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error fetching tasks',
        error: e,
        stackTrace: stackTrace,
      );

      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('Falling back to ${localTasks.length} cached tasks');
        return localTasks;
      }

      throw ApiException(
        'Failed to load tasks: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<PaginatedTaskResult> getTasksPaginated({
    required int page,
    required int pageSize,
  }) async {
    if (!_usePagination) {
      throw StateError(
        'Pagination disabled. Enable _usePagination or use getTasks()',
      );
    }

    try {
      // Fetch from API to simulate network pagination
      _logger.i('Fetching from API for pagination test');
      final allTasks = await _taskService.fetchTasks();
      _logger.i(
        'Client-side pagination: page $page, size $pageSize (${allTasks.length} total from API)',
      );

      final startIndex = page * pageSize;
      final endIndex = min(startIndex + pageSize, allTasks.length);

      if (startIndex >= allTasks.length && allTasks.isNotEmpty) {
        return PaginatedTaskResult(
          tasks: [],
          page: page,
          pageSize: pageSize,
          totalTasks: allTasks.length,
          hasMore: false,
        );
      }

      final pagedTasks = startIndex < allTasks.length
          ? allTasks.sublist(startIndex, endIndex)
          : <Task>[];

      final hasMore = endIndex < allTasks.length;
      _logger.i(
        'Page $page: ${pagedTasks.length} tasks (${startIndex + 1}-${startIndex + pagedTasks.length} of ${allTasks.length})',
      );

      // Simulate network delay for realistic pagination feel
      if (page > 0) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      return PaginatedTaskResult(
        tasks: pagedTasks,
        page: page,
        pageSize: pageSize,
        totalTasks: allTasks.length,
        hasMore: hasMore,
      );
    } catch (e, stackTrace) {
      _logger.e('Error in paginated fetch', error: e, stackTrace: stackTrace);
      throw ApiException(
        'Failed to load tasks: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Retrieves a single task by ID from local storage
  Future<Task?> getTaskById(int id) async {
    try {
      final localTask = await _storageService.getTaskById(id);
      if (localTask != null) {
        _logger.i('Task $id found in local storage');
        return localTask;
      }

      _logger.i('Task $id not in local storage, fetching from API');
      await _taskService.fetchTask(id);
      _logger.i('Task $id fetched from API');

      return localTask;
    } on ApiException catch (e) {
      _logger.w('Failed to fetch task $id from API: ${e.message}');
      return null;
    } catch (e, stackTrace) {
      _logger.e('Error fetching task $id', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Creates a new task locally, then syncs with API
  /// Task is immediately available even if API fails
  Future<Task> createTask(Task task) async {
    try {
      final assignedTask = task.id == 0
          ? task.copyWith(id: await _storageService.getNextTaskId())
          : task;

      await _storageService.saveTask(assignedTask);
      _logger.i('Task saved locally: ${assignedTask.title}');

      try {
        final apiTask = await _taskService.createTask(assignedTask);
        _logger.d('API payload received for ${apiTask.title}');
        _logger.i('Task creation acknowledged by API');
      } on ApiException catch (e) {
        _logger.w('API sync failed for task creation: ${e.message}');
        _logger.i('Task still available locally');
      }

      return assignedTask;
    } catch (e, stackTrace) {
      _logger.e(
        'Critical error: Failed to save task locally',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to create task: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates existing task locally, then syncs with API
  Future<Task> updateTask(Task task) async {
    try {
      await _storageService.updateTask(task);
      _logger.i('Task updated locally: ${task.title}');

      try {
        final apiTask = await _taskService.updateTask(task);
        _logger.d('API payload received for ${apiTask.title}');
        _logger.i('Task update acknowledged by API');
      } on ApiException catch (e) {
        _logger.w('API sync failed for task update: ${e.message}');
        _logger.i('Task still updated locally');
      }

      return task;
    } catch (e, stackTrace) {
      _logger.e(
        'Critical error: Failed to update task locally',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to update task: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Deletes task from local storage, then syncs with API
  Future<bool> deleteTask(int taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      _logger.i('Task deleted locally: $taskId');

      try {
        await _taskService.deleteTask(taskId);
        _logger.i('Task deletion acknowledged by API');
      } on ApiException catch (e) {
        _logger.w('API sync failed for task deletion: ${e.message}');
        _logger.i('Task still deleted locally');
      }

      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Critical error: Failed to delete task locally',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clears all tasks from local storage
  Future<void> clearLocalData() async {
    try {
      await _storageService.clearAllTasks();
      _logger.i('All local tasks cleared');
    } catch (e, stackTrace) {
      _logger.e('Error clearing local data', error: e, stackTrace: stackTrace);
      throw ApiException(
        'Failed to clear local data: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Manual sync with server (triggered by pull-to-refresh)
  Future<void> syncWithServer() async {
    try {
      _logger.i('Starting manual sync with server');

      final serverTasks = await _taskService.fetchTasks();
      _logger.i('Sync simulated: ${serverTasks.length} tasks returned by API');
    } on ApiException catch (e) {
      _logger.e('Sync failed: ${e.message}');
      throw ApiException(
        'Failed to sync with server. ${e.userMessage}',
        statusCode: e.statusCode,
        type: e.type,
        originalError: e,
      );
    } catch (e, stackTrace) {
      _logger.e('Unexpected sync error', error: e, stackTrace: stackTrace);
      throw ApiException(
        'Sync failed: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _fetchAndCacheTasksInBackground() {
    _taskService
        .fetchTasks()
        .then((tasks) {
          _logger.i('Background sync completed: ${tasks.length} API tasks');
        })
        .catchError((error) {
          _logger.d('Background sync failed (non-critical): $error');
        });
  }

  /// Returns task statistics from local storage
  Future<Map<String, int>> getTaskStatistics() async {
    try {
      final info = await _storageService.getStorageInfo();
      return {
        'total': info['total_tasks'] as int,
        'completed': info['completed_tasks'] as int,
        'pending': info['pending_tasks'] as int,
      };
    } catch (e, stackTrace) {
      _logger.e(
        'Error getting task statistics',
        error: e,
        stackTrace: stackTrace,
      );
      return {'total': 0, 'completed': 0, 'pending': 0};
    }
  }
}
