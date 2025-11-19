import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:taskflow/ui/common/toast.dart';

/// Manages statistics screen state including task counts, completion rates, and category breakdowns.
class StatisticsViewModel extends BaseViewModel {
  final List<Task>? tasks;
  final _navigationService = locator<NavigationService>();
  final _taskRepository = locator<TaskRepository>();
  final _toastService = locator<ToastService>();

  List<Task> _tasks = [];

  StatisticsViewModel({this.tasks});

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

  void toggleTheme() {
    AdaptiveTheme.of(
      StackedService.navigatorKey!.currentContext!,
    ).toggleThemeMode();
  }

  Future<void> loadStatistics() async {
    setBusy(true);

    try {
      _tasks = await _taskRepository.getTasks();
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusy(false);
    }
  }

  void initialize() {
    if (tasks != null) {
      _tasks = tasks!;
      rebuildUi();
    } else {
      loadStatistics();
    }
  }
}
