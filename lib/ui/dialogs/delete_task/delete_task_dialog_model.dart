import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteTaskDialogModel extends BaseViewModel {
  void delete(Function(DialogResponse) completer) {
    completer(DialogResponse(confirmed: true));
  }

  void cancel(Function(DialogResponse) completer) {
    completer(DialogResponse(confirmed: false));
  }
}
