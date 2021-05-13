import 'package:flutter/material.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';

class NumberLogicModel extends NumberLogic {
  NumberLogicModel({
    @required String text,
    @required int number}) : super(text: text, number: number);

  factory NumberLogicModel.fromJson(Map<String, dynamic> json){
    return NumberLogicModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'text': text,
      'number': number,
    };
  }
}
