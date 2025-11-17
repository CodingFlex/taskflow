import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.bottomsheets.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/ui/common/toast.dart';

import 'package:taskflow/ui/screens/statistics/statistics_view.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';
import 'package:stacked_services/stacked_services.dart';

enum TaskFilter { all, completed, pending }

class HomeViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _taskRepository = locator<TaskRepository>();
  final _toastService = locator<ToastService>();

  final TextEditingController searchController = TextEditingController();
  TaskFilter _selectedFilter = TaskFilter.all;
  SortOption _sortOption = SortOption.dueDate;
  TaskCategory? _selectedCategory;

  List<Task> _tasks = [];
  String? _errorMessage;

  TaskFilter get selectedFilter => _selectedFilter;
  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

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

  void toggleTheme() {}

  void showMoreFilters() {
    _bottomSheetService.showCustomSheet(variant: BottomSheetType.moreFilters);
  }

  void navigateToTaskDetails(Task task) {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailsView(taskId: task.id, heroTag: 'task_${task.id}'),
        settings: const RouteSettings(name: Routes.taskDetailsView),
      ),
    );
  }

  void navigateToAddTask() {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const TaskDetailsView(heroTag: 'add_task_fab'),
        settings: const RouteSettings(name: Routes.taskDetailsView),
      ),
    );
  }

  void navigateToStatistics() {
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => const StatisticsView(heroTag: 'statistics_view'),
        settings: const RouteSettings(name: Routes.statisticsView),
      ),
    );
  }

  Future<void> toggleTaskComplete(Task task) async {
    final updatedTask = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed,
      completedAt: task.status == TaskStatus.completed ? null : DateTime.now(),
    );

    try {
      await _taskRepository.updateTask(updatedTask);
      _updateTaskInList(updatedTask);
      _toastService.showSuccess(
        message: updatedTask.status == TaskStatus.completed
            ? 'Task marked as completed'
            : 'Task marked as pending',
      );
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    }
  }

  void _updateTaskInList(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      rebuildUi();
    }
  }

  Future<void> loadTasks({bool forceRefresh = false}) async {
    setBusy(true);
    _errorMessage = null;

    try {
      _tasks = await _taskRepository.getTasks(forceRefresh: forceRefresh);
    } on ApiException catch (e) {
      _errorMessage = e.userMessage;
      _toastService.showError(message: e.userMessage);
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _toastService.showError(message: 'Failed to load tasks');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshTasks() async {
    await loadTasks(forceRefresh: true);
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
