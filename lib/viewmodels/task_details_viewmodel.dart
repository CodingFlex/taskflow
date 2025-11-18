import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/api_exceptions.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:stacked_services/stacked_services.dart';

/// Manages task creation/editing screen with form validation and task operations
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
  bool _isFormValid = false;
  bool _listenersAttached = false;

  Task? get task => _task;
  TaskCategory? get selectedCategory => _selectedCategory;
  DateTime? get selectedDueDate => _selectedDueDate;
  bool get isCompleted => _isCompleted;
  bool get isEditMode => taskId != null;
  bool get canSave => _isFormValid;
  bool get isSaving => busy('save');

  // Validation getters for UI
  bool get isTitleValid =>
      titleController.text.trim().length >= 3 &&
      titleController.text.trim().length <= 100;

  bool get isTitleEmpty => titleController.text.trim().isEmpty;

  int get titleLength => titleController.text.length;

  Future<void> initialize() async {
    if (taskId != null) {
      await _loadTask();
    } else {
      _selectedCategory = null;
      _selectedDueDate = null;
      _attachListeners();
      _updateFormValidity();
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

        _attachListeners();
        _updateFormValidity();
      }
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusy(false);
    }
  }

  void _attachListeners() {
    if (_listenersAttached) return;
    titleController.addListener(_onTitleChanged);
    descriptionController.addListener(_updateFormValidity);
    dueDateController.addListener(_updateFormValidity);
    _listenersAttached = true;
  }

  void _onTitleChanged() {
    // Trigger rebuild for validator animation
    notifyListeners();
    _updateFormValidity();
  }

  void setCategory(TaskCategory category) {
    _selectedCategory = category;
    _updateFormValidity();
    rebuildUi();
  }

  void setDueDate(DateTime date) {
    _selectedDueDate = date;
    dueDateController.text = '${date.day}/${date.month}/${date.year}';
    _updateFormValidity();
  }

  void clearDueDate() {
    _selectedDueDate = null;
    dueDateController.clear();
    _updateFormValidity();
  }

  void toggleCompletion() {
    _isCompleted = !_isCompleted;
    rebuildUi();
  }

  Future<void> saveTask() async {
    if (!_validateForm()) {
      return;
    }

    setBusyForObject('save', true);

    try {
      if (isEditMode) {
        await _updateTask();
      } else {
        await _createTask();
      }
    } finally {
      setBusyForObject('save', false);
    }
  }

  Future<void> _createTask() async {
    try {
      final newTask = Task(
        id: 0,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: _isCompleted ? TaskStatus.completed : TaskStatus.pending,
        category: _selectedCategory ?? TaskCategory.other,
        dueDate: _selectedDueDate,
        createdAt: DateTime.now(),
        completedAt: _isCompleted ? DateTime.now() : null,
      );

      await _taskRepository.createTask(newTask);
      _toastService.showSuccess(message: ksTaskCreatedSuccess);
      _navigationService.back(result: true);
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
        category: _selectedCategory ?? TaskCategory.other,
        dueDate: _selectedDueDate,
        completedAt: _isCompleted && _task!.status != TaskStatus.completed
            ? DateTime.now()
            : _task!.completedAt,
      );

      await _taskRepository.updateTask(updatedTask);
      _toastService.showSuccess(message: ksTaskUpdatedSuccess);
      _navigationService.back(result: true);
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
        _toastService.showSuccess(message: ksTaskDeletedSuccess);
        _navigationService.back(result: true);
      } else {
        _toastService.showError(message: ksFailedToDeleteTask);
      }
    } on ApiException catch (e) {
      _toastService.showError(message: e.userMessage);
    } finally {
      setBusy(false);
    }
  }

  bool _validateForm() {
    _updateFormValidity();
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      _toastService.showError(message: ksEnterTaskTitleError);
      return false;
    }

    if (title.length < 3) {
      _toastService.showError(message: ksTitleMinLengthError);
      return false;
    }

    if (title.length > 100) {
      _toastService.showError(message: ksTitleMaxLengthError);
      return false;
    }

    if (description.isEmpty) {
      _toastService.showError(message: ksEnterDescriptionError);
      return false;
    }

    if (description.length > 500) {
      _toastService.showError(message: ksDescriptionMaxLengthError);
      return false;
    }

    if (_selectedDueDate == null) {
      _toastService.showError(message: ksSelectDueDateError);
      return false;
    }

    return true;
  }

  void _updateFormValidity() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    final hasValidTitle =
        title.isNotEmpty && title.length >= 3 && title.length <= 100;
    final hasValidDescription =
        description.isNotEmpty && description.length <= 500;
    final hasDueDate = _selectedDueDate != null;
    final nextState = hasValidTitle && hasValidDescription && hasDueDate;

    if (_isFormValid != nextState) {
      _isFormValid = nextState;
      rebuildUi();
    }
  }

  void navigateBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    if (_listenersAttached) {
      titleController.removeListener(_onTitleChanged);
      descriptionController.removeListener(_updateFormValidity);
      dueDateController.removeListener(_updateFormValidity);
    }
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}
