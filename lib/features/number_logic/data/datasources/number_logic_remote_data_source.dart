import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';

abstract class NumberLogicRemoteDataSource{
  
  Future<NumberLogicModel> getUsersNumbers(int number);
  Future<NumberLogicModel> getRandomNumbers();
}