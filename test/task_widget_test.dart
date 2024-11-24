import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/data/models/task.dart';
import 'package:task_manager/widgets/task_widget.dart';

void main() {
  group('TaskWidget', () {
    late Task testTask;
    late bool editTapped;
    late bool deleteTapped;
    late bool doneTapped;

    setUp(() {
      testTask = Task(
        userId: 'gakngkang',
        id: '1',
        name: 'Test Task',
        category: 'Work',
        priority: 'Urgent',
        dueTime: DateTime.now(),
        done: false,
      );
      editTapped = false;
      deleteTapped = false;
      doneTapped = false;
    });

    testWidgets('displays task details', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {},
            onDelete: () {},
            onDone: () {},
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);
      expect(find.text(DateFormat('dd MMM yyyy').format(testTask.dueTime)),
          findsOneWidget);
    });

    testWidgets('triggers onEdit callback when edit button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {
              editTapped = true;
            },
            onDelete: () {},
            onDone: () {},
          ),
        ),
      );

      // Tap the edit button
      await tester.tap(find.byTooltip('Edit Task'));
      await tester.pump();

      // Verify that the onEdit callback was triggered
      expect(editTapped, isTrue);
    });

    testWidgets('triggers onDelete callback when delete button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {},
            onDelete: () {
              deleteTapped = true;
            },
            onDone: () {},
          ),
        ),
      );

      // Tap the delete button
      await tester.tap(find.byTooltip('Delete Task'));
      await tester.pump();

      // Verify that the onDelete callback was triggered
      expect(deleteTapped, isTrue);
    });

    testWidgets('triggers onDone callback when done button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {},
            onDelete: () {},
            onDone: () {
              doneTapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byTooltip('Mark as Done'));
      await tester.pump();

      expect(doneTapped, isTrue);
    });

    testWidgets('displays correct icon based on task completion status',
        (WidgetTester tester) async {
      // Test with task not done
      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {},
            onDelete: () {},
            onDone: () {},
          ),
        ),
      );

      expect(
        find.byIcon(Icons.radio_button_unchecked),
        findsOneWidget,
      );
      expect(
        find.byTooltip('Mark as Done'),
        findsOneWidget,
      );

      testTask = testTask.copyWith(done: true);

      await tester.pumpWidget(
        MaterialApp(
          home: TaskWidget(
            task: testTask,
            onEdit: () {},
            onDelete: () {},
            onDone: () {},
          ),
        ),
      );

      expect(
        find.byIcon(Icons.check_circle),
        findsOneWidget,
      );
      expect(
        find.byTooltip('Task Completed'),
        findsOneWidget,
      );
    });
  });
}
