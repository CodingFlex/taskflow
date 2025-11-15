import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:stacked_services/stacked_services.dart';

class StatisticsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<Task> _tasks = [];

  int get totalTasks => _tasks.length;
  int get completedTasks =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get pendingTasks =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;

  int getCategoryCount(TaskCategory category) {
    return _tasks.where((t) => t.category == category).length;
  }

  void navigateBack() {
    _navigationService.back();
  }

  void loadStatistics() {
    setBusy(true);
    // TODO: Load tasks from API
    _tasks = [
      Task(
        id: 1,
        title: 'Update dependencies',
        description: 'Upgrade Flutter packages',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        dueDate: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Task(
        id: 2,
        title: 'Fix bug',
        description: 'Resolve issue',
        status: TaskStatus.completed,
        category: TaskCategory.work,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    setBusy(false);
  }
}

