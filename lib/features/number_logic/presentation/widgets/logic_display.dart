import 'package:flutter/material.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';

class LogicDisplay extends StatelessWidget {
  final NumberLogic numberLogic;
  const LogicDisplay({Key key, @required this.numberLogic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: Column(
        children: [
          Text(numberLogic.number.toString(),
          style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 10.0,),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(numberLogic.text,
                style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
