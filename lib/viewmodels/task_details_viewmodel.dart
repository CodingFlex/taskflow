import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:stacked_services/stacked_services.dart';

class TaskDetailsViewModel extends BaseViewModel {
  final int? taskId;
  final _navigationService = locator<NavigationService>();
  final _taskRepository = locator<TaskRepository>();
  final _toastService = locator<ToastService>();
  final _dialogService = locator<DialogService>();

  TaskDetailsViewModel({this.taskId});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  Task? _task;
  TaskCategory? _selectedCategory;
  DateTime? _selectedDueDate;
  bool _isCompleted = false;

  Task? get task => _task;
  TaskCategory? get selectedCategory => _selectedCategory;
  DateTime? get selectedDueDate => _selectedDueDate;
  bool get isCompleted => _isCompleted;
  bool get isEditMode => taskId != null;

  Future<void> initialize() async {
    if (taskId != null) {
      await _loadTask();
    }
  }

  Future<void> _loadTask() async {
    setBusy(true);

    try {
      _task = await _taskRepository.getTaskById(taskId!);

      if (_task != null) {
        titleController.text = _task!.title;
        descriptionController.text = _task!.description;
        _selectedCategory = _task!.category;
        _selectedDueDate = _task!.dueDate;
        _isCompleted = _task!.status == TaskStatus.completed;

        if (_selectedDueDate != null) {
          dueDateController.text =
              '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}';
        }
      }
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusy(false);
    }
  }

  void setCategory(TaskCategory? category) {
    _selectedCategory = category;
    rebuildUi();
  }

  void setDueDate(DateTime date) {
    _selectedDueDate = date;
    dueDateController.text = '${date.day}/${date.month}/${date.year}';
    rebuildUi();
  }

  void clearDueDate() {
    _selectedDueDate = null;
    dueDateController.clear();
    rebuildUi();
  }

  void toggleCompletion() {
    _isCompleted = !_isCompleted;
    rebuildUi();
  }

  Future<void> saveTask() async {
    if (!_validateForm()) {
      return;
    }

    setBusy(true);

    try {
      if (isEditMode) {
        await _updateTask();
      } else {
        await _createTask();
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> _createTask() async {
    try {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: _isCompleted ? TaskStatus.completed : TaskStatus.pending,
        category: _selectedCategory!,
        dueDate: _selectedDueDate,
        createdAt: DateTime.now(),
        completedAt: _isCompleted ? DateTime.now() : null,
      );

      await _taskRepository.createTask(newTask);
      _toastService.showSuccess(message: 'Task created successfully');
      _navigationService.back();
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    }
  }

  Future<void> _updateTask() async {
    if (_task == null) return;

    try {
      final updatedTask = _task!.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: _isCompleted ? TaskStatus.completed : TaskStatus.pending,
        category: _selectedCategory!,
        dueDate: _selectedDueDate,
        completedAt: _isCompleted && _task!.status != TaskStatus.completed
            ? DateTime.now()
            : _task!.completedAt,
      );

      await _taskRepository.updateTask(updatedTask);
      _toastService.showSuccess(message: 'Task updated successfully');
      _navigationService.back();
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    }
  }

  Future<void> showDeleteDialog() async {
    if (!isEditMode) return;

    final response = await _dialogService.showConfirmationDialog(
      title: 'Delete Task',
      description:
          'Are you sure you want to delete this task? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (response?.confirmed == true) {
      await _deleteTask();
    }
  }

  Future<void> _deleteTask() async {
    if (taskId == null) return;

    setBusy(true);

    try {
      final success = await _taskRepository.deleteTask(taskId!);

      if (success) {
        _toastService.showSuccess(message: 'Task deleted successfully');
        _navigationService.back();
      } else {
        _toastService.showError(message: 'Failed to delete task');
      }
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusy(false);
    }
  }

  bool _validateForm() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      _toastService.showError(message: 'Please enter a task title');
      return false;
    }

    if (title.length < 3) {
      _toastService.showError(message: 'Title must be at least 3 characters');
      return false;
    }

    if (title.length > 100) {
      _toastService.showError(
        message: 'Title must be less than 100 characters',
      );
      return false;
    }

    if (descriptionController.text.length > 500) {
      _toastService.showError(
        message: 'Description must be less than 500 characters',
      );
      return false;
    }

    return true;
  }

  void navigateBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}
