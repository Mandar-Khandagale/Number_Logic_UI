import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_random_number.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_users_number.dart';
import 'package:number_logic/features/number_logic/presentation/number_logic/number_logic_bloc.dart';
import 'package:number_logic/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetUsersNumberLogic extends Mock implements GetUsersNumber {}

class MockGetRandomNumberLogic extends Mock implements GetRandomNumber {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberLogicBloc bloc;
  MockGetUsersNumberLogic mockGetUsersNumberLogic;
  MockGetRandomNumberLogic mockGetRandomNumberLogic;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetUsersNumberLogic = MockGetUsersNumberLogic();
    mockGetRandomNumberLogic = MockGetRandomNumberLogic();
    mockInputConverter = MockInputConverter();

    bloc = NumberLogicBloc(
      users: mockGetUsersNumberLogic,
      random: mockGetRandomNumberLogic,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group(
    'GetLogicForUsersNumber',
    () {
      final tNumberString = '1';
      final tNumberParsed = int.parse(tNumberString);
      final tNumberLogic = NumberLogic(text: 'test logic', number: 1);

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
          () async{
          when(mockInputConverter.stringToUnsignedIntegers(any))
              .thenReturn(Right(tNumberParsed));

          bloc.add(GetLogicForUserNumber(tNumberString));

          await untilCalled(mockInputConverter.stringToUnsignedIntegers(tNumberString));
          verify(mockInputConverter.stringToUnsignedIntegers(tNumberString));

          },
      );

      test(
        'should emit [Error] when the input is invalid',
            () async {
          when(mockInputConverter.stringToUnsignedIntegers(any))
              .thenReturn(Left(InvalidInputFailure()));

          final expected = [
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));

          bloc.add(GetLogicForUserNumber(tNumberString));
        },
      );
    },
  );

}