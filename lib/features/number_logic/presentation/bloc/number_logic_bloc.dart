import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/usecases/usecase.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_random_number.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_users_number.dart';
import 'package:number_logic/utils/input_converter.dart';

part 'number_logic_event.dart';

part 'number_logic_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberLogicBloc extends Bloc<NumberLogicEvent, NumberLogicState> {
  final GetUsersNumber getUsersNumber;
  final GetRandomNumber getRandomNumber;
  final InputConverter inputConverter;

  NumberLogicBloc({
    @required GetUsersNumber users,
    @required GetRandomNumber random,
    @required this.inputConverter,
  })  : assert(users != null),
        assert(random != null),
        assert(inputConverter != null),
        getUsersNumber = users,
        getRandomNumber = random;

  @override
  NumberLogicState get initialState => Empty();

  @override
  Stream<NumberLogicState> mapEventToState(
    NumberLogicEvent event,
  ) async* {
    if (event is GetLogicForUsersNumber) {
      final inputEither =
          inputConverter.stringToUnsignedIntegers(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrLogic = await getUsersNumber(Params(number: integer));
          yield failureOrLogic.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (logic) => Loaded(logic: logic),
          );
        },
      );
    } else if (event is GetLogicForRandomNumber) {
      yield Loading();
      final failureOrLogic = await getRandomNumber(NoParams());
      yield failureOrLogic.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (logic) => Loaded(logic: logic),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
