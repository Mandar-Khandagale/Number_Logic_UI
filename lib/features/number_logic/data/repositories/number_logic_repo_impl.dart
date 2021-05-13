import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/platform/network_info.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_local_data_source.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_remote_data_source.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';
import 'package:number_logic/features/number_logic/domain/repositories/number_logic_repo.dart';

class NumberLogicRepoImpl implements NumberLogicRepo{

  final NumberLogicRemoteDataSource remoteDataSource;
  final NumberLogicLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberLogicRepoImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberLogic>> getRandomNumbers() async{
    if(await networkInfo.isConnected){
      try{
        final remoteLogic = await remoteDataSource.getRandomNumbers();
        localDataSource.cacheNumberLogic(remoteLogic);
        return Right(remoteLogic);
      } on ServerException{
        return Left(ServerFailure());
      }
    }else {
      try{
        final localLogic = await localDataSource.getLastNumberLogic();
        return Right(localLogic);
      } on CacheException{
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberLogic>> getUsersNumbers(int number) async{
    if(await networkInfo.isConnected){
      try{
        final remoteLogic = await remoteDataSource.getUsersNumbers(number);
        localDataSource.cacheNumberLogic(remoteLogic);
        return Right(remoteLogic);
      } on ServerException{
        return Left(ServerFailure());
      }
    }else {
      try{
        final localLogic = await localDataSource.getLastNumberLogic();
        return Right(localLogic);
      } on CacheException{
        return Left(CacheFailure());
      }
    }
  }

}