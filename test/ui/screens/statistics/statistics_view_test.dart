import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/screens/statistics/statistics_view.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('StatisticsView Widget Tests', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    Widget buildTestableWidget(Widget child) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(home: child);
        },
      );
    }

    testWidgets('renders Statistics title', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      expect(find.text(ksStatistics), findsOneWidget);
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      expect(find.byIcon(FontAwesomeIcons.arrowLeft), findsOneWidget);
    });

    testWidgets('renders stats overview cards', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksTotalTasks), findsOneWidget);
      expect(find.text(ksCompletedTasks), findsOneWidget);
      expect(find.text(ksPendingTasks), findsOneWidget);
    });

    testWidgets('renders stat card icons', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.byIcon(FontAwesomeIcons.listCheck), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.circleCheck), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.clock), findsOneWidget);
    });

    testWidgets('renders category stats section', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksTasksByCategory), findsOneWidget);
    });

    testWidgets('renders all category items', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
      expect(find.text('Shopping'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });

    testWidgets('renders completion rate section', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.text(ksCompletionRate), findsOneWidget);
    });

    testWidgets('renders circular progress indicator for completion rate', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays 0% completion when no tasks', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('displays correct stats with tasks', (tester) async {
      final tasks = [
        Task(
          id: 1,
          title: 'Task 1',
          description: 'Description 1',
          status: TaskStatus.completed,
          category: TaskCategory.work,
          createdAt: DateTime.now(),
        ),
        Task(
          id: 2,
          title: 'Task 2',
          description: 'Description 2',
          status: TaskStatus.pending,
          category: TaskCategory.personal,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(StatisticsView(tasks: tasks)),
      );
      await tester.pumpAndSettle();

      expect(find.text('2'), findsWidgets);
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('renders LinearProgressIndicator for each category', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget(const StatisticsView()));
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsNWidgets(5));
    });
  });
}
