import 'package:flutter/material.dart';
import 'package:flutter_todo_bloc_listener/utils/app_bloc_observer.dart';
import 'blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as fBloc;
import 'package:bloc/bloc.dart' as bloc;

import 'presentations/todo_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bloc.Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return fBloc.MultiBlocProvider(
      providers: [
        fBloc.BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        fBloc.BlocProvider<TodoFilterBloc>(
          create: (context) => TodoFilterBloc(),
        ),
        fBloc.BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        fBloc.BlocProvider<ActiveTodoCountBloc>(
          create: (context) => ActiveTodoCountBloc(
            initialActiveTodocount: context.read<TodoListBloc>().state.todos.length,
          ),
        ),
        fBloc.BlocProvider<TodoSearchBloc>(
          create: (context) => TodoSearchBloc(),
        ),
        fBloc.BlocProvider<FilteredTodosBloc>(
            create: (context) => FilteredTodosBloc(
                  initialTodos: context.read<TodoListBloc>().state.todos,
                ))
      ],
      child: MaterialApp(
        title: 'ToDo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: TodoPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
