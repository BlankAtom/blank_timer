import 'package:flutter_test/flutter_test.dart';
import 'package:blank_timer/todo_data.dart';
import 'package:json/json.dart';

/// Entry point for the test file.
void main() {
  group('TodoProvider', () {
    late ToDoProvider todoProvider;
    // late Database db;

    setUp(() async {
      todoProvider = ToDoProvider();
      await todoProvider.openDb();
      print('Opened db');
      // db = await todoProvider.openDb();
    });

    tearDown(() async {
      await todoProvider.closeAsync();
    });

    test('Insert and query data', () async {
      final todo = TodoItem(
        1,
        'Test Todo',
        0,
        0,
        'Test content',
        'Test location',
        0,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      );

      await todoProvider.insertData(todo);

      final queriedData = await todoProvider.queryData();
      expect(queriedData.length, 1);
      expect(queriedData.first.title, 'Test Todo');
    });

    test('Update data', () async {
      final todo = TodoItem(
        1,
        'Test Todo',
        0,
        0,
        'Test content',
        'Test location',
        0,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      );

      await todoProvider.insertData(todo);

      final updatedTodo = TodoItem(
        1,
        'Updated Todo',
        1,
        0,
        'Updated content',
        'Updated location',
        1,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      );

      await todoProvider.updateData(updatedTodo);

      final queriedData = await todoProvider.queryData();
      expect(queriedData.length, 1);
      expect(queriedData.first.title, 'Updated Todo');
      expect(queriedData.first.isDone, 1);
    });

    test('Delete data', () async {
      final todo = TodoItem(
        1,
        'Test Todo',
        0,
        0,
        'Test content',
        'Test location',
        0,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      );

      await todoProvider.insertData(todo);

      await todoProvider.deleteData(todo);

      final queriedData = await todoProvider.queryData();
      expect(queriedData.length, 0);
    });
  });
}