import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_logic/core/usecases/usecase.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_random_number.dart';

class MockNumberLogicRepo extends Mock implements NumberLogicRepo{}

void main() {
  GetRandomNumber usecase;
  MockNumberLogicRepo mockNumberLogicRepo;

  setUp((){
    mockNumberLogicRepo = MockNumberLogicRepo();
    usecase = GetRandomNumber(mockNumberLogicRepo);
  });

  final tNumberLogic = NumberLogic(text: 'test', number: 1);

  test(
      'should get logic from the repository',
          () async{
        when(mockNumberLogicRepo.getRandomNumbers()).thenAnswer((_) async=> Right(tNumberLogic));

        final result = await usecase(NoParams());
        expect(result, Right(tNumberLogic));
        verify(mockNumberLogicRepo.getRandomNumbers());
        verifyNoMoreInteractions(mockNumberLogicRepo);

      }
  );
}