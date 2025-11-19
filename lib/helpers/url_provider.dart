import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides API endpoint URLs for task operations using JSONPlaceholder endpoints.
class URLProvider {
  static URLProvider? _instance;

  factory URLProvider() {
    _instance ??= URLProvider._internal();
    return _instance!;
  }

  URLProvider._internal();

  String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  // Task Endpoints (JSONPlaceholder)
  // GET all tasks
  String get tasksEndpoint => '/todos';

  // GET single task
  String taskEndpoint(int taskId) => '/todos/$taskId';

  // POST new task (returns created task)
  String get createTaskEndpoint => '/todos';

  // PUT update task
  String updateTaskEndpoint(int taskId) => '/todos/$taskId';

  // DELETE task
  String deleteTaskEndpoint(int taskId) => '/todos/$taskId';

  // Helper methods for building URLs
  String addQueryParams(String url, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return url;

    final uri = Uri.parse(url);
    final queryParams = Map<String, dynamic>.from(uri.queryParameters)
      ..addAll(params);

    return uri.replace(queryParameters: queryParams).toString();
  }

  String addPathSegments(String url, List<String> segments) {
    final uri = Uri.parse(url);
    final pathSegments = List<String>.from(uri.pathSegments)..addAll(segments);

    return uri.replace(pathSegments: pathSegments).toString();
  }
}
