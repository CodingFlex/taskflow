import 'package:taskflow/commands/command_manager.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/biometrics_service.dart';
import 'package:taskflow/services/storage_service.dart';
import 'package:taskflow/services/task_service.dart';
import 'package:taskflow/ui/bottom_sheets/more_filters/more_filters_sheet.dart';
import 'package:taskflow/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:taskflow/ui/dialogs/delete_task/delete_task_dialog.dart';
import 'package:taskflow/ui/screens/biometric/biometric_view.dart';
import 'package:taskflow/ui/screens/home/home_view.dart';
import 'package:taskflow/ui/screens/splash/splash_view.dart';
import 'package:taskflow/ui/screens/statistics/statistics_view.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: BiometricView),
    MaterialRoute(page: TaskDetailsView),
    MaterialRoute(page: StatisticsView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BiometricsService),
    LazySingleton(classType: StorageService),
    LazySingleton(classType: TaskService),
    LazySingleton(classType: TaskRepository),
    LazySingleton(classType: ToastService),
    LazySingleton(classType: CommandManager),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: MoreFiltersSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: DeleteTaskDialog),
    // @stacked-dialog
  ],
)
class App {}
