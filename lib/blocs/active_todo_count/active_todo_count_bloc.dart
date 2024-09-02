// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_bloc_listener/blocs/blocs.dart';

import '../../models/todo_model.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  final int initialActiveTodocount;
  // final TodoListBloc todoListBloc;

  ActiveTodoCountBloc({
    required this.initialActiveTodocount,
    // required this.todoListBloc,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodocount)) {
    on<CalculateActiveTodoCountEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }
}
