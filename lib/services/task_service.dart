import 'package:taskflow/helpers/helpers/api_client.dart';
import 'package:taskflow/helpers/helpers/url_provider.dart';
import 'package:taskflow/models/task.dart';

class TaskService {
  final ApiClient _apiClient;
  final URLProvider _urlProvider;

  TaskService()
      : _apiClient = ApiClient(),
        _urlProvider = URLProvider();

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _apiClient.get(
        _urlProvider.tasksEndpoint,
        requiresAuth: false,
      );

      if (response.data is List) {
        final List<dynamic> tasksJson = response.data as List<dynamic>;
        return tasksJson
            .map((json) =>
                Task.fromJsonPlaceholder(json as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  Future<Task> fetchTask(int taskId) async {
    try {
      final response = await _apiClient.get(
        _urlProvider.taskEndpoint(taskId),
        requiresAuth: false,
      );

      return Task.fromJsonPlaceholder(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final taskData = task.toJsonPlaceholder();
      final response = await _apiClient.post(
        _urlProvider.createTaskEndpoint,
        data: taskData,
        requiresAuth: false,
      );

      return Task.fromJsonPlaceholder(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      final taskData = task.toJsonPlaceholder();
      final response = await _apiClient.put(
        _urlProvider.updateTaskEndpoint(task.id),
        data: taskData,
        requiresAuth: false,
      );

      return Task.fromJsonPlaceholder(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _apiClient.delete(
        _urlProvider.deleteTaskEndpoint(taskId),
        requiresAuth: false,
      );
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
