import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task.dart';

void main() {
  group('Task model', () {
    test(
      'isOverdue returns true only for pending tasks with past due date',
      () {
        final task = Task(
          id: 1,
          title: 'Submit report',
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        );

        expect(task.isOverdue, isTrue);

        final completedTask = task.copyWith(status: TaskStatus.completed);
        expect(completedTask.isOverdue, isFalse);
      },
    );

    test('daysUntilDue returns difference when due date in future', () {
      final task = Task(
        id: 2,
        title: 'Plan trip',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now(),
      );

      expect(task.daysUntilDue, greaterThanOrEqualTo(2));
    });

    test('formattedDate returns Today for same-day tasks', () {
      final task = Task(
        id: 3,
        title: 'Daily standup',
        createdAt: DateTime.now(),
      );

      expect(task.formattedDate, equals('Today'));
    });
  });
}
