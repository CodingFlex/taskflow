// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/delete_task/delete_task_dialog.dart';

enum DialogType { deleteTask }

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.deleteTask: (context, request, completer) =>
        DeleteTaskDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
