import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';
import 'package:number_logic/features/number_logic/domain/usecase/get_users_number.dart';

class MockNumberLogicRepo extends Mock implements NumberLogicRepo{}

void main() {
  GetUsersNumber usecase;
  MockNumberLogicRepo mockNumberLogicRepo;

  setUp((){
    mockNumberLogicRepo = MockNumberLogicRepo();
    usecase = GetUsersNumber(mockNumberLogicRepo);
  });

  final tNumber = 1;
  final tNumberLogic = NumberLogic(text: 'test', number: 1);

  test(
      'should get logic for the number from the repository',
      () async{
        when(mockNumberLogicRepo.getUsersNumbers(any)).thenAnswer((_) async=> Right(tNumberLogic));

        final result = await usecase(Params(number: tNumber));
        expect(result, Right(tNumberLogic));
        verify(mockNumberLogicRepo.getUsersNumbers(tNumber));
        verifyNoMoreInteractions(mockNumberLogicRepo);

      }
  );
}