import 'package:flutter/material.dart';
import 'package:todo_app_isar_db/models/models.dart';
import 'package:todo_app_isar_db/repositories/repositories.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key, this.todo});

// (step 1) To be able to delete a todo
  final Todo? todo;

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _dateController;

  late DateTime _dueDate;

// (step 2)
  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState(); // (step3)
    _titleController = TextEditingController(text: widget.todo?.title ?? '');

    // (step4)
    _dueDate = widget.todo?.dueDate ?? DateTime.now();
    // (step5)
    _dateController = TextEditingController(
      text: DateFormat.yMMMd().format(_dueDate),
    );
    _dateController = TextEditingController();

    _dueDate = DateTime.now();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // (step6 change hard coded text to this)
              Text(
                '${_isEditing ? 'Update' : 'Add'} Todo',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (val) =>
                    val!.trim().isEmpty ? 'Title is Required.' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(hintText: 'Due Date'),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 2),
                    ),
                  );
                  if (date != null) {
                    _dueDate = date;
                    _dateController.text = DateFormat.yMMMd().format(date);
                  }
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // (step7 add !isEditing)
                  if (_formKey.currentState!.validate()) {
                    context.read<TodosRepository>().putTodo(
                          !_isEditing
                              ? Todo(
                                  title: _titleController.text.trim(),
                                  dueDate: _dueDate,
                                )
                              : (widget.todo!
                                ..title = _titleController.text.trim()
                                ..dueDate = _dueDate),
                        );
                  }
                  Navigator.of(context).pop();
                },
                // (setp 8 add _isEditing to button text and then add new delete button)
                child: Text(_isEditing ? 'Update' : 'Add'),
              ),
              if (_isEditing)
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                  onPressed: () {
                    context.read<TodosRepository>().deleteTodo(widget.todo!.id);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
