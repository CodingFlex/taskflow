import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/screens/task_details/task_details_view.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('TaskDetailsView Widget Tests', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    Widget buildTestableWidget(Widget child) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(home: child);
        },
      );
    }

    testWidgets('renders "New Task" title for create mode', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksNewTask), findsOneWidget);
    });

    testWidgets('renders "Edit Task" title for edit mode', (tester) async {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestableWidget(TaskDetailsView(taskId: 1, task: task)),
      );
      await tester.pumpAndSettle();

      expect(find.text(ksEditTask), findsOneWidget);
    });

    testWidgets('renders all form sections', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksTitleLabel), findsOneWidget);
      expect(find.text(ksCategoryLabel), findsOneWidget);
      expect(find.text(ksDueDateLabel), findsOneWidget);
      expect(find.text(ksDescriptionLabel), findsOneWidget);
    });

    testWidgets('renders category chips', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('renders Create button in create mode', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksCreate), findsOneWidget);
    });

    testWidgets('renders Update button in edit mode', (tester) async {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestableWidget(TaskDetailsView(taskId: 1, task: task)),
      );
      await tester.pumpAndSettle();

      expect(find.text(ksUpdate), findsOneWidget);
    });

    testWidgets('renders delete button in edit mode', (tester) async {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestableWidget(TaskDetailsView(taskId: 1, task: task)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('does not render delete button in create mode', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsNothing);
    });

    testWidgets('renders completion toggle in edit mode', (tester) async {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        category: TaskCategory.work,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        buildTestableWidget(TaskDetailsView(taskId: 1, task: task)),
      );
      await tester.pumpAndSettle();

      expect(find.text(ksMarkAsCompleted), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('renders character count for title', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text('0/100'), findsOneWidget);
    });

    testWidgets('renders character count for description', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const TaskDetailsView()));
      await tester.pumpAndSettle();

      expect(find.text('0/500'), findsOneWidget);
    });
  });
}
