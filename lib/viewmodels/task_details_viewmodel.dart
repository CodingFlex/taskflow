import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.dialogs.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:intl/intl.dart';

class TaskDetailsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  final int? taskId;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  Task? _task;
  TaskCategory _selectedCategory = TaskCategory.work;
  DateTime? _selectedDueDate;

  Task? get task => _task;
  TaskCategory get selectedCategory => _selectedCategory;
  bool get isCompleted => _task?.status == TaskStatus.completed;

  TaskDetailsViewModel({this.taskId}) {
    _initialize();
  }

  void _initialize() {
    if (taskId != null) {
      _loadTask();
    } else {
      _selectedDueDate = DateTime.now().add(const Duration(days: 1));
      _updateDueDateController();
    }

    titleController.addListener(() => rebuildUi());
    descriptionController.addListener(() => rebuildUi());
  }

  void _loadTask() {
    setBusy(true);
    // TODO: Load task from API
    _task = Task(
      id: taskId!,
      title: 'Update dependencies',
      description: 'Upgrade Flutter packages to latest versions',
      status: TaskStatus.pending,
      category: TaskCategory.work,
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    );
    titleController.text = _task!.title;
    descriptionController.text = _task!.description;
    _selectedCategory = _task!.category;
    _selectedDueDate = _task!.dueDate;
    _updateDueDateController();
    setBusy(false);
  }

  void _updateDueDateController() {
    if (_selectedDueDate != null) {
      dueDateController.text =
          DateFormat('MM/dd/yyyy').format(_selectedDueDate!);
    } else {
      dueDateController.clear();
    }
  }

  DateTime? get selectedDueDate => _selectedDueDate;

  void setDueDate(DateTime date) {
    _selectedDueDate = date;
    _updateDueDateController();
    rebuildUi();
  }

  void clearDueDate() {
    _selectedDueDate = null;
    _updateDueDateController();
    rebuildUi();
  }

  void setCategory(TaskCategory category) {
    _selectedCategory = category;
    rebuildUi();
  }

  void toggleCompletion() {
    if (_task == null) return;

    final newStatus = _task!.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;

    _task = _task!.copyWith(
      status: newStatus,
      completedAt: newStatus == TaskStatus.completed ? DateTime.now() : null,
    );
    rebuildUi();
  }

  void navigateBack() {
    _navigationService.back();
  }

  void toggleTheme() {
    // Theme toggle handled by AdaptiveTheme
  }

  void showDeleteDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.deleteTask,
    );
  }

  Future<void> saveTask() async {
    if (titleController.text.trim().isEmpty) {
      // TODO: Show error message
      return;
    }

    setBusy(true);
    try {
      // TODO: Save task to API
      await Future.delayed(const Duration(milliseconds: 500));
      navigateBack();
    } catch (e) {
      // TODO: Handle error
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}
