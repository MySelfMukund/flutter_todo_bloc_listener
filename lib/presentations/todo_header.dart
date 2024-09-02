import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc_listener/blocs/todo_list/todo_list_bloc.dart';

import '../blocs/active_todo_count/active_todo_count_bloc.dart';
import '../models/todo_model.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(fontSize: 35),
        ),
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final activeTodoCount = state.todos.where((Todo todo) => !todo.isCompleted).toList().length;
            context.read<ActiveTodoCountBloc>().add(CalculateActiveTodoCountEvent(activeTodoCount: activeTodoCount));
          },
          child: BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
            builder: (context, state) {
              return Text('${state.activeTodoCount.toString()} items left', style: TextStyle(fontSize: 20, color: Colors.red));
            },
          ),
        )
      ],
    );
  }
}
