import 'package:flutter/material.dart';

import 'create_todo.dart';
import 'search_and_filter_todo.dart';
import 'show_todos.dart';
import 'todo_header.dart';

class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  TextEditingController todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                TodoHeader(),
                CreateTodo(),
                SizedBox(
                  height: 20,
                ),
                SearchAndFilterTodo(),
                ShowTodos(),
              ],
            ),
          )),
    );
  }
}
