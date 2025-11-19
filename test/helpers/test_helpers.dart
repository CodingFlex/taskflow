import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/repositories/task_repository.dart';
import 'package:taskflow/services/storage_service.dart';
import 'package:taskflow/services/task_service.dart';
import 'package:taskflow/ui/common/toast.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:taskflow/commands/command_manager.dart';

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<TaskRepository>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<StorageService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<TaskService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<ToastService>(onMissingStub: OnMissingStub.returnDefault),
    MockSpec<CommandManager>(onMissingStub: OnMissingStub.returnDefault),
  ],
)
void main() {}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService() {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();
  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockTaskRepository getAndRegisterTaskRepository() {
  _removeRegistrationIfExists<TaskRepository>();
  final service = MockTaskRepository();

  when(service.getTasks()).thenAnswer((_) async => []);
  when(service.syncWithServer()).thenAnswer((_) async => []);

  locator.registerSingleton<TaskRepository>(service);
  return service;
}

MockStorageService getAndRegisterStorageService() {
  _removeRegistrationIfExists<StorageService>();
  final service = MockStorageService();

  when(service.getTasks()).thenAnswer((_) async => []);
  when(service.init()).thenAnswer((_) async => {});

  locator.registerSingleton<StorageService>(service);
  return service;
}

MockTaskService getAndRegisterTaskService() {
  _removeRegistrationIfExists<TaskService>();
  final service = MockTaskService();
  locator.registerSingleton<TaskService>(service);
  return service;
}

MockToastService getAndRegisterToastService() {
  _removeRegistrationIfExists<ToastService>();
  final service = MockToastService();
  locator.registerSingleton<ToastService>(service);
  return service;
}

MockCommandManager getAndRegisterCommandManager() {
  _removeRegistrationIfExists<CommandManager>();
  final service = MockCommandManager();

  when(service.canUndo).thenReturn(false);

  locator.registerSingleton<CommandManager>(service);
  return service;
}

void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterTaskRepository();
  getAndRegisterStorageService();
  getAndRegisterTaskService();
  getAndRegisterToastService();
  getAndRegisterCommandManager();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
