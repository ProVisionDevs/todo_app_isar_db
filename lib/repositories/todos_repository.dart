import 'package:isar/isar.dart';
import 'package:todo_app_isar_db/models/models.dart';

class TodosRepository {
  const TodosRepository({required Isar db}) : _db = db;

  // Allows for mock testing
  final Isar _db;

  Future<int> putTodo(Todo todo) async {
    // Asynchronous read-write transaction
    return await _db.writeTxn(() async {
      return await _db.todos.put(todo);
    });
  }

  Future<bool> deleteTodo(int todoId) async {
    return await _db.writeTxn(() async {
      return await _db.todos.delete(todoId);
    });
  }

  Stream<List<Todo>> streamTodos({required String contains}) {
    return _db.todos
        .filter()
        .titleContains(contains, caseSensitive: false)
        .sortByDueDateDesc()
        .watch(fireImmediately: true);
  }
}
