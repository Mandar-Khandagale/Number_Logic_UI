import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';

abstract class NumberLogicLocalDataSource{

  Future<NumberLogicModel> getLastNumberLogic();
  Future<void> cacheNumberLogic(NumberLogicModel logicToCache);
}