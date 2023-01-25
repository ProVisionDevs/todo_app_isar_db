import 'package:flutter/material.dart';
import 'package:todo_app_isar_db/models/models.dart';
import 'package:todo_app_isar_db/repositories/repositories.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

import 'ui/ui.dart';

Future<void> main() async {
  final db = await Isar.open([TodoSchema]);
  runApp(
    Provider(
      create: (_) => TodosRepository(db: db),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App Isar DB',
      theme: ThemeData(primaryColor: Colors.black),
      builder: (_, child) => _Unfocus(child: child!),
      home: const TodosScreen(),
    );
  }
}

class _Unfocus extends StatelessWidget {
  const _Unfocus({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
