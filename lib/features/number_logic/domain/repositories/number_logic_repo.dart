import 'package:dartz/dartz.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';

abstract class NumberLogicRepo{
  Future<Either<Failure, NumberLogic>> getUsersNumbers(int number);
  Future<Either<Failure, NumberLogic>> getRandomNumbers();
}