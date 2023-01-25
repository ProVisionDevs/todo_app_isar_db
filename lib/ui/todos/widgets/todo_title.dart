import 'package:flutter/material.dart';
import 'package:todo_app_isar_db/models/models.dart';
import 'package:todo_app_isar_db/repositories/todos_repository.dart';
import 'package:todo_app_isar_db/ui/todos/todos.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _changeStatus(context),
      leading: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: Icon(
          _emojiStatus(),
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.status == TodoStatus.completed
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: Text(
        DateFormat.yMMMd().format(todo.dueDate),
        style: TextStyle(
          decoration: todo.status == TodoStatus.completed
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      trailing: IconButton(
          onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => AddTodoDialog(todo: todo),
              ),
          icon: const Icon(
            Icons.edit_rounded,
            color: Colors.grey,
            size: 18,
          )),
    );
  }

  void _changeStatus(BuildContext context) {
    var nextStatus = TodoStatus.todo;
    switch (todo.status) {
      case TodoStatus.todo:
        nextStatus = TodoStatus.inProgress;
        break;
      case TodoStatus.inProgress:
        nextStatus = TodoStatus.completed;
        break;
      case TodoStatus.completed:
        nextStatus = TodoStatus.todo;
        break;
    }
    context.read<TodosRepository>().putTodo(todo..status = nextStatus);
  }

  IconData _emojiStatus() {
    switch (todo.status) {
      case TodoStatus.todo:
        return Icons.circle_outlined;
      case TodoStatus.inProgress:
        return Icons.check_circle_outline_outlined;
      case TodoStatus.completed:
        return Icons.check_circle;
    }
  }
}
