import 'package:taskflow/models/task.dart';
import 'package:taskflow/services/task_service.dart';

class TaskRepository {
  final TaskService _taskService;

  TaskRepository() : _taskService = TaskService();

  Future<List<Task>> getAllTasks() async {
    try {
      return await _taskService.fetchTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> getTaskById(int taskId) async {
    try {
      return await _taskService.fetchTask(taskId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      return await _taskService.createTask(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      return await _taskService.updateTask(task);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
    } catch (e) {
      rethrow;
    }
  }
}
