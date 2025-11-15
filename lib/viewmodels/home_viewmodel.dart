import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.bottomsheets.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/screens/statistics/statistics_view.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';
import 'package:stacked_services/stacked_services.dart';

enum TaskFilter {
  all,
  completed,
  pending,
}

class HomeViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();

  final TextEditingController searchController = TextEditingController();
  TaskFilter _selectedFilter = TaskFilter.all;
  SortOption _sortOption = SortOption.dueDate;
  TaskCategory? _selectedCategory;

  List<Task> _tasks = [];

  TaskFilter get selectedFilter => _selectedFilter;
  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;

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

  void toggleTheme() {
    // Theme toggle will be handled by AdaptiveTheme
  }

  void showMoreFilters() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.moreFilters,
    );
  }

  void navigateToTaskDetails(Task task) {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsView(
          taskId: task.id,
          heroTag: 'task_${task.id}',
        ),
        settings: const RouteSettings(name: Routes.taskDetailsView),
      ),
    );
  }

  void navigateToAddTask() {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const TaskDetailsView(
          heroTag: 'add_task_fab',
        ),
        settings: const RouteSettings(name: Routes.taskDetailsView),
      ),
    );
  }

  void navigateToStatistics() {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const StatisticsView(
          heroTag: 'statistics_view',
        ),
        settings: const RouteSettings(name: Routes.statisticsView),
      ),
    );
  }

  void toggleTaskComplete(Task task) {
    final updatedTask = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed,
      completedAt: task.status == TaskStatus.completed ? null : DateTime.now(),
    );
    _updateTask(updatedTask);
  }

  void _updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      rebuildUi();
    }
  }

  void loadTasks() {
    setBusy(true);
    // TODO: Load tasks from API
    _tasks = [
      Task(
        id: 1,
        title: 'Update dependencies',
        description: 'Upgrade Flutter packages to latest versions',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        dueDate: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Task(
        id: 2,
        title: 'Fix bug in login flow',
        description: 'Resolve authentication issue',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Task(
        id: 3,
        title: 'Review pull requests',
        description: 'Check and merge pending PRs',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    setBusy(false);
  }

  void initialize() {
    loadTasks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
