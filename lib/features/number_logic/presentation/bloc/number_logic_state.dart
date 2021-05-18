part of 'number_logic_bloc.dart';

@immutable
abstract class NumberLogicState extends Equatable {
  NumberLogicState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends NumberLogicState {}

class Loading extends NumberLogicState {}

class Loaded extends NumberLogicState {
  final NumberLogic logic;

  Loaded({@required this.logic}) : super([logic]);
}

class Error extends NumberLogicState {
  final String message;

  Error({@required this.message}) : super([message]);
}