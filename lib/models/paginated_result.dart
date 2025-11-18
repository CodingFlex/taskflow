import 'package:taskflow/models/task.dart';

/// Result object for paginated task queries
/// Used when fetching tasks from API with client-side pagination
class PaginatedTaskResult {
  final List<Task> tasks;
  final int page;
  final int pageSize;
  final int totalTasks;
  final bool hasMore;

  const PaginatedTaskResult({
    required this.tasks,
    required this.page,
    required this.pageSize,
    required this.totalTasks,
    required this.hasMore,
  });

  bool get isFirstPage => page == 0;
  bool get isLastPage => !hasMore;
  int get totalPages => (totalTasks / pageSize).ceil();

  @override
  String toString() {
    return 'PaginatedTaskResult(page: $page, tasks: ${tasks.length}/$totalTasks, hasMore: $hasMore)';
  }
}
