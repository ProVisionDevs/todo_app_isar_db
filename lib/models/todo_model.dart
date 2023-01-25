import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Todo({required this.title, required this.dueDate});

  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String title;

  @Index(type: IndexType.value)
  DateTime dueDate;

  @enumerated
  TodoStatus status = TodoStatus.todo;
}

enum TodoStatus {
  todo,
  inProgress,
  completed,
}
