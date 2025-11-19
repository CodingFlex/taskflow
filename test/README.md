# TaskFlow Tests

This directory contains widget tests for the main screens of the TaskFlow app.

## Setup

### 1. Generate Mock Files

Before running tests, you need to generate the mock files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate `test/helpers/test_helpers.mocks.dart` which contains mocks for all services.

### 2. Run Tests

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/ui/screens/home/home_view_test.dart
```

Run tests with coverage:
```bash
flutter test --coverage
```

View coverage report:
```bash
# Install genhtml first (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## Test Structure

```
test/
├── helpers/
│   ├── test_helpers.dart           # Service mocks and registration
│   └── test_helpers.mocks.dart     # Generated mock implementations
└── ui/
    └── screens/
        ├── home/
        │   └── home_view_test.dart        # HomeView widget tests
        ├── task_details/
        │   └── task_details_view_test.dart # TaskDetailsView widget tests
        └── statistics/
            └── statistics_view_test.dart   # StatisticsView widget tests
```

## What's Tested

### HomeView Tests
- ✅ App name renders in AppBar
- ✅ Search field is present
- ✅ Filter chips render correctly
- ✅ FloatingActionButton is present
- ✅ Connectivity indicator displays
- ✅ Statistics button is present
- ✅ Theme toggle button works
- ✅ Empty state shows correctly

### TaskDetailsView Tests
- ✅ Correct title for create/edit mode
- ✅ All form sections render
- ✅ Category chips display
- ✅ Create/Update button shows based on mode
- ✅ Delete button only in edit mode
- ✅ Completion toggle in edit mode
- ✅ Character counts display

### StatisticsView Tests
- ✅ Title and navigation
- ✅ Stats overview cards render
- ✅ Category statistics display
- ✅ Completion rate shows correctly
- ✅ Progress indicators render
- ✅ Handles empty state
- ✅ Displays correct stats with data

## Adding New Tests

1. Create test file in appropriate directory
2. Import test helpers:
   ```dart
   import '../../../helpers/test_helpers.dart';
   ```

3. Set up and tear down:
   ```dart
   setUp(() => registerServices());
   tearDown(() => locator.reset());
   ```

4. Write your tests using Flutter's `testWidgets`:
   ```dart
   testWidgets('description', (tester) async {
     await tester.pumpWidget(MaterialApp(home: YourWidget()));
     await tester.pumpAndSettle();
     
     expect(find.text('Expected Text'), findsOneWidget);
   });
   ```

## Common Testing Patterns

### Finding Widgets
```dart
// By text
find.text('Button Label')

// By type
find.byType(FloatingActionButton)

// By icon
find.byIcon(Icons.add)

// By key
find.byKey(Key('my_key'))
```

### Interacting with Widgets
```dart
// Tap a button
await tester.tap(find.byType(ElevatedButton));
await tester.pumpAndSettle();

// Enter text
await tester.enterText(find.byType(TextField), 'Hello');

// Scroll
await tester.drag(find.byType(ListView), Offset(0, -300));
await tester.pumpAndSettle();
```

### Assertions
```dart
// Widget exists
expect(find.text('Hello'), findsOneWidget);

// Multiple widgets
expect(find.byType(ListTile), findsNWidgets(3));

// Widget doesn't exist
expect(find.text('Missing'), findsNothing);

// At least one
expect(find.byIcon(Icons.star), findsWidgets);
```

## Notes

- All services are mocked using Mockito
- Tests run against a clean locator instance (setUp/tearDown)
- Stacked ViewModels are tested through the Views
- No actual API calls or database operations occur during tests

