import 'package:flutter/material.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';
import 'package:taskflow/ui/common/taskflow_button2.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taskflow/ui/dialogs/delete_task/delete_task_dialog_model.dart';

class DeleteTaskDialog extends StackedView<DeleteTaskDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const DeleteTaskDialog({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  Widget builder(
    BuildContext context,
    DeleteTaskDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete Task?',
              style: AppTextStyles.heading2(context).copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            verticalSpaceMedium,
            Text(
              'This action cannot be undone.',
              style: AppTextStyles.body(context).copyWith(
                fontSize: 16,
              ),
            ),
            verticalSpaceLarge,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TaskflowButton2(
                  title: 'CANCEL',
                  type: TaskflowButton2Type.secondary,
                  onTap: () => viewModel.cancel(completer),
                  width: 100,
                  height: 40,
                  noBorder: true,
                ),
                horizontalSpaceSmall,
                TaskflowButton2(
                  title: 'DELETE',
                  type: TaskflowButton2Type.danger,
                  onTap: () {
                    viewModel.delete(completer);
                  },
                  width: 100,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  DeleteTaskDialogModel viewModelBuilder(BuildContext context) =>
      DeleteTaskDialogModel();
}
