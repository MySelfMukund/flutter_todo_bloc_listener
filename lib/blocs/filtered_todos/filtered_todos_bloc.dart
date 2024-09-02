import 'dart:async';

import 'package:flutter_todo_bloc_listener/blocs/blocs.dart';

import '../../models/todo_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final List<Todo> initialTodos;

  FilteredTodosBloc({required this.initialTodos}) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    on<CalculateFilteredTodoEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.filteredTodos));
    });
  }

  // void setFilteredTodos() {
  //   List<Todo> _filteredTodos;

  //   switch (todoFilterBloc.state.filter) {
  //     case Filter.active:
  //       _filteredTodos = todoListBloc.state.todos.where((Todo todo) => !todo.isCompleted).toList();
  //       break;

  //     case Filter.completed:
  //       _filteredTodos = todoListBloc.state.todos.where((Todo todo) => todo.isCompleted).toList();
  //     case Filter.all:
  //     default:
  //       _filteredTodos = todoListBloc.state.todos;
  //   }
  //   if (todoSearchBloc.state.searchText.isNotEmpty) {
  //     _filteredTodos =
  //         _filteredTodos.where((Todo todo) => todo.desc.toLowerCase().contains(todoSearchBloc.state.searchText)).toList();
  //   }

  //   add(CalculateFilteredTodoEvent(filteredTodos: _filteredTodos));
  // }
}
