import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'detail_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = List<Todo>.generate(
      20,
          (i) => Todo('Todo $i', 'A description for Todo $i'),
    );

    return Scaffold(
      appBar: AppBar(
          title: const Text("Navigation 2"),
          backgroundColor: Colors.blue[400]
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
