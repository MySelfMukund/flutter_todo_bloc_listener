// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'active_todo_count_bloc.dart';

sealed class ActiveTodoCountEvent extends Equatable {
  const ActiveTodoCountEvent();

  @override
  List<Object> get props => [];
}

class CalculateActiveTodoCountEvent extends ActiveTodoCountEvent {
  final int activeTodoCount;

  CalculateActiveTodoCountEvent({required this.activeTodoCount});

  @override
  String toString() => 'CalculateActiveTodoCountEvent(activeTodoCount: $activeTodoCount)';
}
