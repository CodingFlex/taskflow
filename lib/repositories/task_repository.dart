import 'package:flutter/foundation.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/services/task_service.dart';
import 'package:taskflow/services/storage_service.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:logger/logger.dart';

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

      final tasks = await _taskService.fetchTasks();
      await _storageService.saveTasks(tasks);
      _logger.i('✅ Fetched and cached ${tasks.length} tasks from API');
      return tasks;
    } on ApiException catch (e) {
      _logger.i('❌ API Error: ${e.message}');
      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('📦 Falling back to ${localTasks.length} cached tasks');
        return localTasks;
      }
      rethrow;
    } catch (e) {
      _logger.i('❌ Unexpected error: $e');
      final localTasks = await _storageService.getTasks();
      if (localTasks.isNotEmpty) {
        _logger.i('📦 Falling back to ${localTasks.length} cached tasks');
        return localTasks;
      }
      rethrow;
    }
  }

  Future<Task?> getTaskById(int id) async {
    try {
      final localTask = await _storageService.getTaskById(id);
      if (localTask != null) {
        return localTask;
      }

      final task = await _taskService.fetchTask(id);
      await _storageService.saveTask(task);
      return task;
    } catch (e) {
      _logger.i('❌ Error fetching task $id: $e');
      return await _storageService.getTaskById(id);
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      await _storageService.saveTask(task);
      _logger.i('📝 Task saved locally: ${task.title}');

      try {
        final apiTask = await _taskService.createTask(task);
        await _storageService.updateTask(apiTask);
        _logger.i('☁️ Task synced with API: ${apiTask.id}');
        return apiTask;
      } on ApiException catch (e) {
        _logger.i('⚠️ Could not sync with API: ${e.message}');
        return task;
      }
    } catch (e) {
      _logger.i('❌ Error creating task: $e');
      rethrow;
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      await _storageService.updateTask(task);
      _logger.i('📝 Task updated locally: ${task.title}');

      try {
        final apiTask = await _taskService.updateTask(task);
        await _storageService.updateTask(apiTask);
        _logger.i('☁️ Task synced with API: ${apiTask.id}');
        return apiTask;
      } on ApiException catch (e) {
        _logger.i('⚠️ Could not sync with API: ${e.message}');
        return task;
      }
    } catch (e) {
      _logger.i('❌ Error updating task: $e');
      rethrow;
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      await _storageService.deleteTask(taskId);
      _logger.i('🗑️ Task deleted locally: $taskId');

      try {
        await _taskService.deleteTask(taskId);
        _logger.i('☁️ Task deleted from API: $taskId');
        return true;
      } on ApiException catch (e) {
        _logger.i('⚠️ Could not sync deletion with API: ${e.message}');
        return true;
      }
    } catch (e) {
      _logger.i('❌ Error deleting task: $e');
      return false;
    }
  }

  Future<void> clearLocalData() async {
    await _storageService.clearAllTasks();
    _logger.i('🧹 All local tasks cleared');
  }

  Future<void> syncWithServer() async {
    try {
      _logger.i('🔄 Starting sync with server...');
      final serverTasks = await _taskService.fetchTasks();
      await _storageService.saveTasks(serverTasks);
      _logger.i('✅ Sync completed: ${serverTasks.length} tasks synced');
    } catch (e) {
      _logger.i('❌ Sync failed: $e');
      rethrow;
    }
  }

  void _fetchAndCacheTasksInBackground() async {
    try {
      final tasks = await _taskService.fetchTasks();
      await _storageService.saveTasks(tasks);
      _logger.i('🔄 Background sync: ${tasks.length} tasks updated');
    } catch (e) {
      _logger.i('⚠️ Background sync failed: $e');
    }
  }
}
