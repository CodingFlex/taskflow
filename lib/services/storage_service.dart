// lib/services/storage_service.dart

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../models/task.dart';

/// Storage service using Hive for local data persistence
/// Handles all local database operations for tasks
class StorageService {
  static const String _taskBoxName = 'tasks_box';

  final Logger _logger = Logger();
  Box<Task>? _taskBox;

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
        Hive.registerAdapter(TaskAdapter());
        Hive.registerAdapter(TaskStatusAdapter());
        Hive.registerAdapter(TaskCategoryAdapter());
        Hive.registerAdapter(SortOptionAdapter());
      }

      _taskBox = await Hive.openBox<Task>(_taskBoxName);

      _logger.i('✅ Hive initialized successfully');
      _logger.i('📦 Tasks in storage: ${_taskBox!.length}');
    } catch (e) {
      _logger.e('❌ Error initializing Hive: $e');
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_taskBox == null || !_taskBox!.isOpen) {
      await init();
    }
  }

  Future<void> saveTask(Task task) async {
    await _ensureInitialized();
    try {
      await _taskBox!.put(task.id, task);
      _logger.i('💾 Task saved: ${task.title} (ID: ${task.id})');
    } catch (e) {
      _logger.i('❌ Error saving task: $e');
      rethrow;
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _ensureInitialized();
    try {
      final taskMap = {for (var task in tasks) task.id: task};
      await _taskBox!.putAll(taskMap);
      _logger.i('💾 Saved ${tasks.length} tasks to storage');
    } catch (e) {
      _logger.i('❌ Error saving tasks: $e');
      rethrow;
    }
  }

  Future<List<Task>> getTasks() async {
    await _ensureInitialized();
    try {
      final tasks = _taskBox!.values.toList();

      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _logger.i('📖 Retrieved ${tasks.length} tasks from storage');
      return tasks;
    } catch (e) {
      _logger.i('❌ Error getting tasks: $e');
      return [];
    }
  }

  Future<Task?> getTaskById(int id) async {
    await _ensureInitialized();
    try {
      final task = _taskBox!.get(id);
      if (task != null) {
        _logger.i('📖 Retrieved task: ${task.title} (ID: $id)');
      } else {
        _logger.i('⚠️ Task not found with ID: $id');
      }
      return task;
    } catch (e) {
      _logger.i('❌ Error getting task: $e');
      return null;
    }
  }

  Future<void> updateTask(Task task) async {
    await _ensureInitialized();
    try {
      if (_taskBox!.containsKey(task.id)) {
        await _taskBox!.put(task.id, task);
        _logger.i('✏️ Task updated: ${task.title} (ID: ${task.id})');
      } else {
        await saveTask(task);
      }
    } catch (e) {
      _logger.i('❌ Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    await _ensureInitialized();
    try {
      await _taskBox!.delete(id);
      _logger.i('🗑️ Task deleted (ID: $id)');
    } catch (e) {
      _logger.i('❌ Error deleting task: $e');
      rethrow;
    }
  }

  Future<void> deleteTasks(List<int> ids) async {
    await _ensureInitialized();
    try {
      await _taskBox!.deleteAll(ids);
      _logger.i('🗑️ Deleted ${ids.length} tasks');
    } catch (e) {
      _logger.i('❌ Error deleting tasks: $e');
      rethrow;
    }
  }

  Future<void> clearAllTasks() async {
    await _ensureInitialized();
    try {
      final count = _taskBox!.length;
      await _taskBox!.clear();
      _logger.i('🧹 Cleared $count tasks from storage');
    } catch (e) {
      _logger.i('❌ Error clearing tasks: $e');
      rethrow;
    }
  }

  Future<List<Task>> getTasksByStatus(bool completed) async {
    final allTasks = await getTasks();
    return allTasks.where((task) => task.completed == completed).toList();
  }

  Future<List<Task>> searchTasks(String query) async {
    final allTasks = await getTasks();
    final lowerQuery = query.toLowerCase();

    return allTasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    final allTasks = await getTasks();

    return allTasks.where((task) {
      return task.createdAt.year == date.year &&
          task.createdAt.month == date.month &&
          task.createdAt.day == date.day;
    }).toList();
  }

  Future<List<Task>> getRecentTasks(int limit) async {
    final allTasks = await getTasks();
    return allTasks.take(limit).toList();
  }

  Future<int> getTaskCount() async {
    await _ensureInitialized();
    return _taskBox!.length;
  }

  Future<int> getCompletedTaskCount() async {
    final allTasks = await getTasks();
    return allTasks.where((task) => task.completed).length;
  }

  Future<int> getPendingTaskCount() async {
    final allTasks = await getTasks();
    return allTasks.where((task) => !task.completed).length;
  }

  Future<bool> isEmpty() async {
    await _ensureInitialized();
    return _taskBox!.isEmpty;
  }

  /// Watch for changes in tasks (reactive)
  Stream<BoxEvent> watchTasks() {
    return _taskBox!.watch();
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    await _ensureInitialized();

    return {
      'total_tasks': _taskBox!.length,
      'completed_tasks': await getCompletedTaskCount(),
      'pending_tasks': await getPendingTaskCount(),
      'is_empty': _taskBox!.isEmpty,
    };
  }

  Future<void> close() async {
    try {
      await _taskBox?.close();
      _logger.i('✅ Storage closed successfully');
    } catch (e) {
      _logger.i('❌ Error closing storage: $e');
    }
  }

  Future<void> reset() async {
    await _ensureInitialized();
    try {
      await _taskBox!.clear();
      _logger.i('🔄 Storage reset successfully');
    } catch (e) {
      _logger.i('❌ Error resetting storage: $e');
      rethrow;
    }
  }
}
