import 'package:flutter/material.dart';
import '../views/todo_list_screen.dart';
void main() {
  runApp(TodoList());
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(),
    );
  }
}


