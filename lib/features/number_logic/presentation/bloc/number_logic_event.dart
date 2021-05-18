part of 'number_logic_bloc.dart';

@immutable
abstract class NumberLogicEvent extends Equatable {
  NumberLogicEvent([List props = const <dynamic>[]]) : super(props);
}

class GetLogicForUsersNumber extends NumberLogicEvent{
  final String numberString;

  GetLogicForUsersNumber(this.numberString) : super([numberString]);
}

class GetLogicForRandomNumber extends NumberLogicEvent {}