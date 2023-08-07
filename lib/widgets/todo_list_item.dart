import 'package:flutter/material.dart';

class TodoListItem extends StatelessWidget {
  final String task;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TodoListItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      title: Text(task),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDelete,
      ),
      onTap: onTap,
    ),
  );
}
}