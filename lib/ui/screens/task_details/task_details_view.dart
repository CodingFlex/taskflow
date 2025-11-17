import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/keyboard_unfocus_wrapper.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/common/taskflow_input_field.dart';
import 'package:taskflow/ui/common/taskflow_button.dart';
import 'package:taskflow/ui/common/date_input_field.dart';
import 'package:taskflow/ui/screens/task_details/widgets/category_selector.dart';
import 'package:taskflow/viewmodels/task_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TaskDetailsView extends StackedView<TaskDetailsViewModel> {
  final int? taskId;
  final String? heroTag;

  const TaskDetailsView({super.key, this.taskId, this.heroTag});

  @override
  Widget builder(
    BuildContext context,
    TaskDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: kcPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: viewModel.navigateBack,
        ),
        title: Text(
          viewModel.isEditMode ? 'Edit Task' : 'New Task',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: viewModel.isEditMode
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.red,
                      size: 18,
                    ),
                    onPressed: viewModel.showDeleteDialog,
                  ),
                ),
              ]
            : null,
      ),
      body: Hero(
        tag: heroTag ?? (taskId != null ? 'task_$taskId' : 'add_task_fab'),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: KeyboardUnfocusWrapper(
            child: Skeletonizer(
              enabled: viewModel.isBusy,
              effect: const ShimmerEffect(
                baseColor: Color(0xFFE5E7EB),
                highlightColor: Color(0xFFF6F7FB),
                duration: Duration(milliseconds: 1200),
              ),
              enableSwitchAnimation: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleSection(viewModel: viewModel),
                    verticalSpaceMedium,
                    _CategorySection(viewModel: viewModel),
                    verticalSpaceMedium,
                    _DueDateSection(viewModel: viewModel),
                    if (viewModel.isEditMode) ...[
                      verticalSpaceMedium,
                      _CompletionToggleSection(viewModel: viewModel),
                    ],
                    verticalSpaceMedium,
                    _DescriptionSection(viewModel: viewModel),
                    verticalSpaceLarge,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: TaskflowButton(
                          title: viewModel.isEditMode ? 'Update' : 'Create',
                          onTap: viewModel.saveTask,
                          state: viewModel.canSave
                              ? TaskflowButtonState.enabled
                              : TaskflowButtonState.disabled,
                          width: screenWidth(context) * 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  TaskDetailsViewModel viewModelBuilder(BuildContext context) =>
      TaskDetailsViewModel(taskId: taskId);

  @override
  void onViewModelReady(TaskDetailsViewModel viewModel) {
    viewModel.initialize();
    super.onViewModelReady(viewModel);
  }
}

class _CompletionToggleSection extends StatelessWidget {
  final TaskDetailsViewModel viewModel;

  const _CompletionToggleSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = viewModel.isCompleted;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mark as completed',
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              verticalSpaceTiny,
              Text(
                isCompleted
                    ? 'This task is completed'
                    : 'Toggle to mark this task as completed',
                style: AppTextStyles.caption(context).copyWith(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        horizontalSpaceMedium,
        Switch(
          thumbColor: WidgetStateProperty.all(Colors.white),
          inactiveTrackColor: isDark
              ? kcDarkGreyColor2
              : const Color(0xFFE4E7EC),
          trackOutlineColor: isDark
              ? WidgetStateProperty.all(kcDarkGreyColor2)
              : WidgetStateProperty.all(const Color(0xFFE4E7EC)),
          value: isCompleted,
          onChanged: (_) => viewModel.toggleCompletion(),
          activeThumbColor: Colors.green,
        ),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  final TaskDetailsViewModel viewModel;

  const _TitleSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title *',
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        verticalSpaceSmall,
        TaskflowInputField(
          controller: viewModel.titleController,
          placeholder: 'Enter task title',
          maxLines: 1,
        ),
        verticalSpaceTiny,
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${viewModel.titleController.text.length}/100',
            style: AppTextStyles.caption(context).copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final TaskDetailsViewModel viewModel;

  const _CategorySection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        verticalSpaceSmall,
        CategorySelector(
          selectedCategory: viewModel.selectedCategory,
          onCategorySelected: viewModel.setCategory,
        ),
      ],
    );
  }
}

class _DueDateSection extends StatelessWidget {
  final TaskDetailsViewModel viewModel;

  const _DueDateSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isOverdue = viewModel.task?.isOverdue ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        verticalSpaceSmall,
        DateInputField(
          controller: viewModel.dueDateController,
          placeholder: 'Select due date',
          initialDate: viewModel.selectedDueDate,
          onDateSelected: (date) {
            viewModel.setDueDate(date);
          },
          onChanged: () {
            viewModel.clearDueDate();
          },
        ),
        if (isOverdue) ...[
          verticalSpaceTiny,
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.circleExclamation,
                color: Colors.red,
                size: 16,
              ),
              horizontalSpaceSmall,
              Text(
                'This task is overdue',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final TaskDetailsViewModel viewModel;

  const _DescriptionSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        verticalSpaceSmall,
        TaskflowInputField(
          controller: viewModel.descriptionController,
          placeholder: 'Enter task description',
          maxLines: 5,
        ),
        verticalSpaceTiny,
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${viewModel.descriptionController.text.length}/500',
            style: AppTextStyles.caption(context).copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
