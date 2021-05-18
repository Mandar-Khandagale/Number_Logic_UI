import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/usecases/usecase.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_random_number.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_users_number.dart';
import 'package:number_logic/features/number_logic/presentation/bloc/number_logic_bloc.dart';
import 'package:number_logic/utils/input_converter.dart';

class MockGetUsersNumber extends Mock implements GetUsersNumber {}

class MockGetRandomNumber extends Mock implements GetRandomNumber {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberLogicBloc bloc;
  MockGetUsersNumber mockGetUsersNumber;
  MockGetRandomNumber mockGetRandomNumber;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetUsersNumber = MockGetUsersNumber();
    mockGetRandomNumber = MockGetRandomNumber();
    mockInputConverter = MockInputConverter();

    bloc = NumberLogicBloc(
      users: mockGetUsersNumber,
      random: mockGetRandomNumber,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetLogicForUsersNumber', () {
    final tNumberString = '1';
    final tnumberParsed = 1;
    final tNumberLogic = NumberLogic(text: 'test Logic', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedIntegers(any))
            .thenReturn(Right(tnumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetLogicForUsersNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedIntegers(any));

      verify(mockInputConverter.stringToUnsignedIntegers(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedIntegers(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetLogicForUsersNumber(tNumberString));
    });

    test('should get data from the user use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetUsersNumber(any))
          .thenAnswer((_) async => Right(tNumberLogic));

      bloc.add(GetLogicForUsersNumber(tNumberString));
      await untilCalled(mockGetUsersNumber(any));

      verify(mockGetUsersNumber(Params(number: tnumberParsed)));
    });

    test(
      'should emit [Loading, Loaded] when the data is gotten successfully',
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetUsersNumber(any))
        .thenAnswer((_) async=> Right(tNumberLogic));

        final expected = [
          Empty(),
          Loading(),
          Loaded(logic: tNumberLogic),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForUsersNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fail',
          () async {
        setUpMockInputConverterSuccess();
        when(mockGetUsersNumber(any))
            .thenAnswer((_) async=> Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForUsersNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
          () async {
        setUpMockInputConverterSuccess();
        when(mockGetUsersNumber(any))
            .thenAnswer((_) async=> Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForUsersNumber(tNumberString));
      },
    );
  });

  group('GetLogicForRandomNumber', () {
    final tNumberLogic = NumberLogic(text: 'test Logic', number: 1);

    test('should get data from the random use case', () async {
      when(mockGetRandomNumber(any))
          .thenAnswer((_) async => Right(tNumberLogic));

      bloc.add(GetLogicForRandomNumber());
      await untilCalled(mockGetRandomNumber(any));

      verify(mockGetRandomNumber(NoParams()));
    });

    test(
      'should emit [Loading, Loaded] when the data is gotten successfully',
          () async {
        when(mockGetRandomNumber(any))
            .thenAnswer((_) async=> Right(tNumberLogic));

        final expected = [
          Empty(),
          Loading(),
          Loaded(logic: tNumberLogic),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fail',
          () async {
            when(mockGetRandomNumber(any))
                .thenAnswer((_) async=> Left(ServerFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
          () async {
            when(mockGetRandomNumber(any))
                .thenAnswer((_) async=> Left(CacheFailure()));

        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

        bloc.add(GetLogicForRandomNumber());
      },
    );
  });

}
