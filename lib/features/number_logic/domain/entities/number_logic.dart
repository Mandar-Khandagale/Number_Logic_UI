import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NumberLogic extends Equatable{

  final String text;
  final int number;

  NumberLogic({
    @required this.text,
    @required this.number,
  }) : super([text, number]);
  
}