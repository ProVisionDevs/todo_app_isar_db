import 'package:flutter/material.dart';
import 'package:todo_app_isar_db/models/todo_model.dart';
import 'package:todo_app_isar_db/repositories/repositories.dart';
import 'package:todo_app_isar_db/ui/ui.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  late TextEditingController _searchController;

  String _contains = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        title: const Text(
          'Todos',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const AddTodoDialog(),
        ),
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28, right: 28, top: 12),
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              controller: _searchController,
              onChanged: (val) => setState(() => _contains = val),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                hintText: 'Search Todos',
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                suffixIcon: Icon(
                  Icons.data_exploration_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: context
                  .watch<TodosRepository>()
                  .streamTodos(contains: _contains),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final todos = snapshot.data ?? [];
                  if (todos.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Text(
                          _contains.isEmpty ? 'Add a todo +' : 'No todos found',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final todo = todos[index];
                      return TodoTile(todo: todo);
                      //
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
