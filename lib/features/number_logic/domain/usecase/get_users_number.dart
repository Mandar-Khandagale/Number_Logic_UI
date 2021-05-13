import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/usecases/usecase.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';

class GetUsersNumber implements UseCase<NumberLogic, Params>{

  final NumberLogicRepo repo;
  GetUsersNumber(this.repo);

  @override
  Future<Either<Failure, NumberLogic>> call(Params params) async{
    return await repo.getUsersNumbers(params.number);
  }
}

class Params extends Equatable{
  final int number;
  Params({@required this.number}) : super([number]);
}