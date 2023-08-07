import 'package:flutter/material.dart';
import '../widgets/todo_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> tasks = [];
  bool sortAscending = true;
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }

  void addTask(String task) {
    setState(() {
      tasks.add(task);
    });
    saveTasks();
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void editTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
    });
    saveTasks();
  }

  void sortTasks() {
    setState(() {
      if (sortAscending) {
        tasks.sort();
      } else {
        tasks.sort((a, b) => b.compareTo(a));
      }
      sortAscending = !sortAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF444444),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 55,
                  height: 55,
                  color: Color(0xFF00CCCC),
                  child: Icon(
                    Icons.menu,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Icon(
                    Icons.store,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
         
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'List Of Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                   ),
                  ],
              ),
            ],
          ),        
          actions: [         
            Padding(
              padding: EdgeInsets.only(right: 100.0),
              child: Row(
                children: [                 
                  IconButton(
                    icon: Icon(Icons.sort_by_alpha),
                    onPressed: sortTasks,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.fullscreen_exit),
                    onPressed: () {},
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle,
                          size: 24,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Text Text',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                  color: Color(0xFFFF3333),
                  width:55,
                  height:55,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

          ],
      ),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TodoListItem(
            key: Key('$index'),
            task: tasks[index],
            onDelete: () => deleteTask(index),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  String newTask = tasks[index];
                  return AlertDialog(
                    title: Text('Edit Task'),
                    content: TextField(
                      controller: TextEditingController(text: newTask),
                      onChanged: (text) {
                        newTask = text;
                      },
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          editTask(index, newTask);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final task = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, task);
          });
          saveTasks();
        },
      ),
      floatingActionButton: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                    builder: (context) {
                        String newTask = '';
                        return AlertDialog(
                          title: Text('Add Task'),
                          content: TextField(
                            onChanged: (text) {
                              newTask = text;
                            },
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Add'),
                              onPressed: () {
                                addTask(newTask);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                );
              },
              color: Colors.white,
            ),
      ),
    );
  }
}