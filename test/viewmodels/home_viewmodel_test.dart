import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/viewmodels/home_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late HomeViewModel viewModel;
  late MockTaskRepository taskRepository;

  List<Task> buildSampleTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 1,
        title: 'Grocery shopping',
        description: 'Buy fruits',
        category: TaskCategory.shopping,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
        dueDate: now.add(const Duration(days: 2)),
      ),
      Task(
        id: 2,
        title: 'Team sync',
        description: 'Weekly catch-up',
        category: TaskCategory.work,
        status: TaskStatus.completed,
        createdAt: now.subtract(const Duration(days: 3)),
        completedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 3,
        title: 'Call mom',
        description: 'Check in on weekend',
        category: TaskCategory.personal,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }

  setUp(() {
    locator.reset();
    getAndRegisterNavigationService();
    getAndRegisterBottomSheetService();
    getAndRegisterDialogService();
    taskRepository = getAndRegisterTaskRepository();
    getAndRegisterStorageService();
    getAndRegisterTaskService();
    getAndRegisterToastService();
    getAndRegisterCommandManager();

    viewModel = HomeViewModel();
  });

  tearDown(() => locator.reset());

  group('HomeViewModel', () {
    test('loadTasks populates filteredTasks', () async {
      final tasks = buildSampleTasks();
      when(
        taskRepository.getTasks(forceRefresh: anyNamed('forceRefresh')),
      ).thenAnswer((_) async => tasks);
      when(taskRepository.getTasks()).thenAnswer((_) async => tasks);

      await viewModel.loadTasks(forceRefresh: true);

      expect(viewModel.filteredTasks, hasLength(3));
    });

    test('setFilter shows only completed tasks', () async {
      final tasks = buildSampleTasks();
      when(
        taskRepository.getTasks(forceRefresh: anyNamed('forceRefresh')),
      ).thenAnswer((_) async => tasks);
      when(taskRepository.getTasks()).thenAnswer((_) async => tasks);

      await viewModel.loadTasks(forceRefresh: true);
      viewModel.setFilter(TaskFilter.completed);

      expect(viewModel.filteredTasks, hasLength(1));
      expect(
        viewModel.filteredTasks.first.status,
        equals(TaskStatus.completed),
      );
    });

    test('search query filters by title and description', () async {
      final tasks = buildSampleTasks();
      when(
        taskRepository.getTasks(forceRefresh: anyNamed('forceRefresh')),
      ).thenAnswer((_) async => tasks);
      when(taskRepository.getTasks()).thenAnswer((_) async => tasks);

      await viewModel.loadTasks(forceRefresh: true);
      viewModel.searchController.text = 'call';
      viewModel.onSearchChanged('call');

      expect(viewModel.filteredTasks, hasLength(1));
      expect(viewModel.filteredTasks.first.title, contains('Call'));
    });
  });
}
