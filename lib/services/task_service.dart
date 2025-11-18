import 'package:logger/logger.dart';
import 'package:taskflow/helpers/helpers/api_client.dart';
import 'package:taskflow/helpers/helpers/url_provider.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/services/api_exceptions.dart';

/// Handles API calls to JSONPlaceholder for task operations (demo purposes)
class TaskService {
  final ApiClient _apiClient;
  final URLProvider _urlProvider;
  final Logger _logger = Logger();

  TaskService() : _apiClient = ApiClient(), _urlProvider = URLProvider();

  Future<List<Task>> fetchTasks() async {
    try {
      _logger.i('Fetching tasks from API...');

      final response = await _apiClient.get(
        _urlProvider.tasksEndpoint,
        requiresAuth: false,
      );

      if (response.data is! List) {
        throw ApiException(
          'Invalid response format: Expected List, got ${response.data.runtimeType}',
          type: ErrorType.validation,
          endpoint: _urlProvider.tasksEndpoint,
        );
      }

      final List<dynamic> tasksJson = response.data as List<dynamic>;
      final tasks = tasksJson
          .map((json) => Task.fromJsonPlaceholder(json as Map<String, dynamic>))
          .toList();

      _logger.i('Successfully fetched ${tasks.length} tasks from API');
      return tasks;
    } on ApiException {
      _logger.e('Failed to fetch tasks from API');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error fetching tasks',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to fetch tasks: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: _urlProvider.tasksEndpoint,
      );
    }
  }

  Future<Task> fetchTask(int taskId) async {
    try {
      _logger.i('Fetching task $taskId from API...');

      final response = await _apiClient.get(
        _urlProvider.taskEndpoint(taskId),
        requiresAuth: false,
      );

      if (response.data is! Map<String, dynamic>) {
        throw ApiException(
          'Invalid response format for task $taskId',
          type: ErrorType.validation,
          endpoint: _urlProvider.taskEndpoint(taskId),
        );
      }

      final task = Task.fromJsonPlaceholder(
        response.data as Map<String, dynamic>,
      );
      _logger.i('Successfully fetched task: ${task.title}');

      return task;
    } on ApiException {
      _logger.e('Failed to fetch task $taskId');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error fetching task $taskId',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to fetch task $taskId: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: _urlProvider.taskEndpoint(taskId),
      );
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      _logger.i('Creating task via API: ${task.title}');

      final taskData = task.toJsonPlaceholder();
      await _apiClient.post(
        _urlProvider.createTaskEndpoint,
        data: taskData,
        requiresAuth: false,
      );

      _logger.i('API returned success for task creation');
      return task;
    } on ApiException catch (e) {
      _logger.w('API error creating task (non-critical): ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error creating task',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to create task: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: _urlProvider.createTaskEndpoint,
      );
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      _logger.i('Updating task via API: ${task.title}');

      final taskData = task.toJsonPlaceholder();
      await _apiClient.put(
        _urlProvider.updateTaskEndpoint(task.id),
        data: taskData,
        requiresAuth: false,
      );

      _logger.i('API returned success for task update');
      return task;
    } on ApiException catch (e) {
      _logger.w('API error updating task (non-critical): ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error updating task',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to update task: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: _urlProvider.updateTaskEndpoint(task.id),
      );
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      _logger.i('Deleting task via API: $taskId');

      await _apiClient.delete(
        _urlProvider.deleteTaskEndpoint(taskId),
        requiresAuth: false,
      );

      _logger.i('API returned success for task deletion');
    } on ApiException catch (e) {
      _logger.w('API error deleting task (non-critical): ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error deleting task',
        error: e,
        stackTrace: stackTrace,
      );
      throw ApiException(
        'Failed to delete task: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
        endpoint: _urlProvider.deleteTaskEndpoint(taskId),
      );
    }
  }
}
