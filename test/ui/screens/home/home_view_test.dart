import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/app/app.locator.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/screens/home/home_view.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('HomeView Widget Tests', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    Widget buildTestableWidget(Widget child) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(home: child);
        },
      );
    }

    testWidgets('renders app name in AppBar', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      expect(find.text(ksAppName), findsOneWidget);
    });

    testWidgets('renders search field', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
    });

    testWidgets('renders filter chips', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      await tester.pumpAndSettle();

      expect(find.text(ksFilterAll), findsOneWidget);
      expect(find.text(ksFilterCompleted), findsOneWidget);
      expect(find.text(ksFilterPending), findsOneWidget);
    });

    testWidgets('renders FloatingActionButton', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.plus), findsOneWidget);
    });

    testWidgets('renders connectivity indicator', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              (widget.icon == FontAwesomeIcons.wifi ||
                  widget.icon == FontAwesomeIcons.circleXmark),
        ),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('renders statistics button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      expect(find.byIcon(FontAwesomeIcons.chartBar), findsOneWidget);
    });

    testWidgets('renders theme toggle button', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Icon &&
              (widget.icon == FontAwesomeIcons.sun ||
                  widget.icon == FontAwesomeIcons.moon),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows "No tasks found" when tasks are empty', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const HomeView()));
      await tester.pumpAndSettle();

      expect(find.text(ksNoTasksFound), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.magnifyingGlass), findsOneWidget);
    });
  });
}
