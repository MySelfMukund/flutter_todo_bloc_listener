import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_bloc_listener/blocs/todo_filter/todo_filter_bloc.dart';
import 'package:flutter_todo_bloc_listener/blocs/todo_search/todo_search_bloc.dart';

import '../../models/todo_model.dart';
import '../blocs/filtered_todos/filtered_todos_bloc.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  List<Todo> setFilteredTodos(Filter filter, List<Todo> todos, String searchText) {
    List<Todo> filteredTodos;

    switch (filter) {
      case Filter.active:
        filteredTodos = todos.where((Todo todo) => !todo.isCompleted).toList();
        break;

      case Filter.completed:
        filteredTodos = todos.where((Todo todo) => todo.isCompleted).toList();
      case Filter.all:
      default:
        filteredTodos = todos;
    }
    if (searchText.isNotEmpty) {
      filteredTodos = filteredTodos.where((Todo todo) => todo.desc.toLowerCase().contains(searchText)).toList();
    }
    return filteredTodos;

    // add(CalculateFilteredTodoEvent(filteredTodos: _filteredTodos));
  }

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;

    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
                context.read<TodoFilterBloc>().state.filter, state.todos, context.read<TodoSearchBloc>().state.searchText);
            context.read<FilteredTodosBloc>().add(CalculateFilteredTodoEvent(filteredTodos: filteredTodos));
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
                state.filter, context.read<TodoListBloc>().state.todos, context.read<TodoSearchBloc>().state.searchText);
            context.read<FilteredTodosBloc>().add(CalculateFilteredTodoEvent(filteredTodos: filteredTodos));
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            final filteredTodos = setFilteredTodos(
                context.read<TodoFilterBloc>().state.filter, context.read<TodoListBloc>().state.todos, state.searchText);
            context.read<FilteredTodosBloc>().add(CalculateFilteredTodoEvent(filteredTodos: filteredTodos));
          },
        ),
      ],
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: todos.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todos[index].id), //ValueKey(todos[index].id),
            background: showBackGround(0),
            secondaryBackground: showBackGround(1),
            child: TodoListItem(
              todo: todos[index],
            ),
            onDismissed: (_) {
              context.read<TodoListBloc>().add(RemoveTodoEvent(todo: todos[index]));
            },
            confirmDismiss: (_) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you really want to delete?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('NO')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('YES'))
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget showBackGround(int direction) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 50.0,
        color: Colors.white,
      ),
    );
  }
}

class TodoListItem extends StatefulWidget {
  final Todo todo;
  const TodoListItem({required this.todo, super.key});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              bool _error = false;
              textEditingController.text = widget.todo.desc;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Edit Todo'),
                    content: TextFormField(
                      controller: textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        errorText: _error ? 'Value cannot be empty' : null,
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCEL')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _error = textEditingController.text.isEmpty ? true : false;
                              if (!_error) {
                                context.read<TodoListBloc>().add(EditTodoEvent(
                                    id: widget.todo.id,
                                    todoDesc:
                                        textEditingController.text)); //editTodo(widget.todo.id, textEditingController.text);
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          child: const Text('EDIT'))
                    ],
                  );
                },
              );
            });
      },
      leading: Checkbox(
        value: widget.todo.isCompleted,
        onChanged: (bool? checked) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(id: widget.todo.id));
        },
      ),
      title: Text(
        widget.todo.desc,
        style: const TextStyle(fontSize: 20.0),
      ),
    );
  }
}
