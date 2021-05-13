import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/usecases/usecase.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';

class GetRandomNumber implements UseCase<NumberLogic, NoParams>{

  final NumberLogicRepo repo;
  GetRandomNumber(this.repo);

  @override
  Future<Either<Failure, NumberLogic>> call(NoParams params) async{
    return await repo.getRandomNumbers();
  }

}

