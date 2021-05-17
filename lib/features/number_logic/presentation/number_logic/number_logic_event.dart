part of 'number_logic_bloc.dart';

@immutable
abstract class NumberLogicEvent extends Equatable{
  NumberLogicEvent([List props = const <dynamic>[]]) : super(props);
}

class GetLogicForUserNumber extends NumberLogicEvent{
  final  String numberString;

  GetLogicForUserNumber(this.numberString) : super([numberString]);

}

class GetLogicForRandomNumber extends NumberLogicEvent {}