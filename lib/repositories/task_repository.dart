import 'package:logger/logger.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/services/task_service.dart';
import 'package:taskflow/services/storage_service.dart';
import 'package:taskflow/services/api_exceptions.dart';

// / Repository pattern implementation for task management
// / Implements offline-first architecture per PRD requirements
// / - Local storage is the source of truth
// / - API calls demonstrate CRUD capability but don't affect local data
// / - All operations work offline
class TaskRepository {
  final TaskService _taskService;
  final StorageService _storageService;
  final Logger _logger = Logger();

  TaskRepository({TaskService? taskService, StorageService? storageService})
    : _taskService = taskService ?? locator<TaskService>(),
      _storageService = storageService ?? locator<StorageService>();

  Future<List<Task>> getTasks({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final localTasks = await _storageService.getTasks();
        if (localTasks.isNotEmpty) {
          _logger.i('📦 Loaded ${localTasks.length} tasks from local storage');
          _fetchAndCacheTasksInBackground();
          return localTasks;
        }
      }

      _logger.i('🔄 Fetching tasks from API...');
      final tasks = await _taskService.fetchTasks();
      _logger.i('✅ API responded with ${tasks.length} tasks');
      // await _storageService.saveTasks(tasks);

      return tasks;
    } on ApiException catch (e) {
      _logger.w('⚠️ API Error (${e.statusCode}): ${e.message}');

      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('📦 Falling back to ${localTasks.length} cached tasks');
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
        '❌ Unexpected error fetching tasks',
        error: e,
        stackTrace: stackTrace,
      );

      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('📦 Falling back to ${localTasks.length} cached tasks ');
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

  Future<Task?> getTaskById(int id) async {
    try {
      final localTask = await _storageService.getTaskById(id);
      if (localTask != null) {
        _logger.i('📦 Task $id found in local storage');
        return localTask;
      }

      _logger.i('🔄 Task $id not in local storage, fetching from API...');
      final task = await _taskService.fetchTask(id);
      _logger.i('✅ Task $id fetched from API ');
      // await _storageService.saveTask(task);

      return task;
    } on ApiException catch (e) {
      _logger.w('⚠️ Failed to fetch task $id from API: ${e.message}');
      return null;
    } catch (e, stackTrace) {
      _logger.e('❌ Error fetching task $id', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      _logger.i('✅ Task saved locally: ${task.title}');

      try {
        final apiTask = await _taskService.createTask(task);
        _logger.d('☁️ API payload received for ${apiTask.title}');
        // await _storageService.updateTask(apiTask);

        _logger.i('☁️ Task creation acknowledged by API');
      } on ApiException catch (e) {
        _logger.w('⚠️ API sync failed for task creation: ${e.message}');
        _logger.i('✓ Task still available locally');
      }

      return task;
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Critical error: Failed to save task locally',
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

  Future<Task> updateTask(Task task) async {
    try {
      await _storageService.updateTask(task);
      _logger.i('✅ Task updated locally: ${task.title}');

      try {
        final apiTask = await _taskService.updateTask(task);
        _logger.d('☁️ API payload received for ${apiTask.title}');
        // await _storageService.updateTask(apiTask);

        _logger.i('☁️ Task update acknowledged by API  ');
      } on ApiException catch (e) {
        _logger.w('⚠️ API sync failed for task update: ${e.message}');
        _logger.i('✓ Task still updated locally');
      }

      return task;
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Critical error: Failed to update task locally',
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

  Future<bool> deleteTask(int taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      _logger.i('✅ Task deleted locally: $taskId');

      try {
        await _taskService.deleteTask(taskId);
        _logger.i('☁️ Task deletion acknowledged by API');
      } on ApiException catch (e) {
        _logger.w('⚠️ API sync failed for task deletion: ${e.message}');
        _logger.i('✓ Task still deleted locally');
      }

      return true;
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Critical error: Failed to delete task locally',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> clearLocalData() async {
    try {
      await _storageService.clearAllTasks();
      _logger.i('🧹 All local tasks cleared');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Error clearing local data',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to clear local data: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> syncWithServer() async {
    try {
      _logger.i('🔄 Starting manual sync with server...');

      final serverTasks = await _taskService.fetchTasks();
      _logger.i(
        '✅ Sync simulated: ${serverTasks.length} tasks returned by API',
      );
      // await _storageService.saveTasks(serverTasks);
    } on ApiException catch (e) {
      _logger.e('❌ Sync failed: ${e.message}');
      throw ApiException(
        'Failed to sync with server. ${e.userMessage}',
        statusCode: e.statusCode,
        type: e.type,
        originalError: e,
      );
    } catch (e, stackTrace) {
      _logger.e('❌ Unexpected sync error', error: e, stackTrace: stackTrace);
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
          _logger.i(
            '🔄 Background sync completed: ${tasks.length} API tasks (cache unchanged)',
          );
          // await _storageService.saveTasks(tasks);
        })
        .catchError((error) {
          _logger.d('⚠️ Background sync failed (non-critical): $error');
        });
  }

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
        '❌ Error getting task statistics',
        error: e,
        stackTrace: stackTrace,
      );
      return {'total': 0, 'completed': 0, 'pending': 0};
    }
  }
}
