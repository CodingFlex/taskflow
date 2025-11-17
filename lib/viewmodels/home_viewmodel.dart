import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.bottomsheets.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/app/app.router.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:taskflow/ui/screens/statistics/statistics_view.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';
import 'package:stacked_services/stacked_services.dart';

enum TaskFilter { all, completed, pending }

class HomeViewModel extends BaseViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _taskRepository = locator<TaskRepository>();
  final _toastService = locator<ToastService>();
  final _connectivity = Connectivity();

  final TextEditingController searchController = TextEditingController();
  TaskFilter _selectedFilter = TaskFilter.all;
  SortOption _sortOption = SortOption.dueDate;
  TaskCategory? _selectedCategory;

  List<Task> _tasks = [];
  String? _errorMessage;
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  TaskFilter get selectedFilter => _selectedFilter;
  SortOption get sortOption => _sortOption;
  TaskCategory? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

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

  Future<void> toggleTheme() async {
    final context = StackedService.navigatorKey!.currentContext;
    if (context == null) return;

    final adaptiveTheme = AdaptiveTheme.of(context);
    final currentMode = adaptiveTheme.mode;

    AdaptiveThemeMode newTheme;
    if (currentMode == AdaptiveThemeMode.light) {
      newTheme = AdaptiveThemeMode.dark;
    } else if (currentMode == AdaptiveThemeMode.dark) {
      newTheme = AdaptiveThemeMode.light;
    } else {
      final isCurrentlyDark = Theme.of(context).brightness == Brightness.dark;
      newTheme = isCurrentlyDark
          ? AdaptiveThemeMode.light
          : AdaptiveThemeMode.dark;
    }

    adaptiveTheme.setThemeMode(newTheme);
  }

  Future<void> showMoreFilters() async {
    final response = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.moreFilters,
      data: {
        'initialSortOption': _sortOption,
        'initialCategory': _selectedCategory,
      },
    );

    if (response?.confirmed == true && response?.data != null) {
      final data = response!.data as Map<String, dynamic>;
      if (data.containsKey('sortOption')) {
        _sortOption = data['sortOption'] as SortOption;
      }
      if (data.containsKey('category')) {
        _selectedCategory = data['category'] as TaskCategory?;
      }
      rebuildUi();
    }
  }

  Future<void> navigateToTaskDetails(Task task) async {
    final shouldRefresh =
        await Navigator.of(StackedService.navigatorKey!.currentContext!).push(
          MaterialPageRoute(
            builder: (context) =>
                TaskDetailsView(taskId: task.id, heroTag: 'task_${task.id}'),
            settings: const RouteSettings(name: Routes.taskDetailsView),
          ),
        );

    if (shouldRefresh == true) {
      await loadTasks(forceRefresh: true);
    }
  }

  Future<void> navigateToAddTask() async {
    final shouldRefresh =
        await Navigator.of(StackedService.navigatorKey!.currentContext!).push(
          MaterialPageRoute(
            builder: (context) =>
                const TaskDetailsView(heroTag: 'add_task_fab'),
            settings: const RouteSettings(name: Routes.taskDetailsView),
          ),
        );

    if (shouldRefresh == true) {
      await loadTasks(forceRefresh: true);
    }
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

    _updateTaskInList(updatedTask);

    try {
      await _taskRepository.updateTask(updatedTask);
      _toastService.showSuccess(
        message: updatedTask.status == TaskStatus.completed
            ? 'Task marked as completed'
            : 'Task marked as pending',
      );
    } on ApiException catch (e) {
      _updateTaskInList(task);
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
    final shouldToggleBusy = !forceRefresh;
    if (shouldToggleBusy) {
      setBusy(true);
    }
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
      if (shouldToggleBusy) {
        setBusy(false);
      } else {
        rebuildUi();
      }
    }
  }

  Future<void> refreshTasks() async {
    await loadTasks(forceRefresh: true);
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(results);
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    if (wasOnline != _isOnline) {
      rebuildUi();
    }
  }

  Future<void> syncWithServer() async {
    await _checkConnectivity();

    if (!_isOnline) {
      _toastService.showError(
        message: 'No internet connection. Please check your network.',
      );
      return;
    }

    setBusyForObject('sync', true);
    try {
      await _taskRepository.syncWithServer();
      await loadTasks(forceRefresh: true);
      _toastService.showSuccess(message: 'Sync completed successfully');
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusyForObject('sync', false);
    }
  }

  bool get isSyncing => busy('sync');

  void initialize() {
    loadTasks();
    _checkConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivityStatus,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
