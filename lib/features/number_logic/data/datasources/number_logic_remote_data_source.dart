import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberLogicRemoteDataSource{
  
  Future<NumberLogicModel> getUsersNumbers(int number);
  Future<NumberLogicModel> getRandomNumbers();
}

class NumberLogicRemoteDataSourceImpl implements NumberLogicRemoteDataSource{

  final http.Client client;

  NumberLogicRemoteDataSourceImpl({ @required this.client});

  @override
  Future<NumberLogicModel> getRandomNumbers() async{
    final response = await client.get(
      'http://numbersapi.com/random',
      headers: {'Content-Type' : 'application/json'},
    );
    if(response.statusCode == 200){
      return NumberLogicModel.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }

  @override
  Future<NumberLogicModel> getUsersNumbers(int number) async{
    final response = await client.get(
      'http://numbersapi.com/$number',
      headers: {'Content-Type' : 'application/json'},
    );
    if(response.statusCode == 200){
      return NumberLogicModel.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }



}