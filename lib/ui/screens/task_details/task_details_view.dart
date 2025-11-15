import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroine/heroine.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/common/taskflow_input_field.dart';
import 'package:taskflow/ui/screens/task_details/widgets/category_selector.dart';
import 'package:taskflow/viewmodels/task_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TaskDetailsView extends StackedView<TaskDetailsViewModel> {
  final int? taskId;

  const TaskDetailsView({super.key, this.taskId});

  @override
  Widget builder(
    BuildContext context,
    TaskDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Heroine(
      tag: taskId != null ? 'task_$taskId' : 'new_task',
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A90E2),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            onPressed: viewModel.navigateBack,
          ),
          title: const Text(
            'Task Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.trash, color: Colors.white),
              onPressed: viewModel.showDeleteDialog,
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.sun, color: Colors.white),
              onPressed: viewModel.toggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleSection(viewModel: viewModel),
              verticalSpaceMedium,
              _CategorySection(viewModel: viewModel),
              verticalSpaceMedium,
              _DueDateSection(viewModel: viewModel),
              verticalSpaceMedium,
              _DescriptionSection(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }

  @override
  TaskDetailsViewModel viewModelBuilder(BuildContext context) =>
      TaskDetailsViewModel(taskId: taskId);
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
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
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
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
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
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpaceSmall,
        TaskflowInputField(
          controller: viewModel.dueDateController,
          placeholder: 'Select due date',
          leading: const Icon(FontAwesomeIcons.calendar),
          enabled: false,
          onChanged: (_) {},
        ),
        if (isOverdue) ...[
          verticalSpaceTiny,
          Row(
            children: [
              const Icon(FontAwesomeIcons.circleExclamation,
                  color: Colors.red, size: 16),
              horizontalSpaceSmall,
              Text(
                'This task is overdue',
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.red,
                  fontSize: 12,
                ),
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
          style: AppTextStyles.caption(context).copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
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
