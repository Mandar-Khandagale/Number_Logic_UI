import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_logic/features/number_logic/presentation/bloc/number_logic_bloc.dart';

class ButtonControls extends StatefulWidget {
  const ButtonControls({Key key}) : super(key: key);

  @override
  _ButtonControlsState createState() => _ButtonControlsState();
}

class _ButtonControlsState extends State<ButtonControls> {
  final controller = TextEditingController();
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) {
            displayUsers();
          },
        ),
        SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: RaisedButton(
                  child: Text('Search'),
                  onPressed: displayUsers,
                  color: Colors.blue,
                ),
            ),
            SizedBox(width: 10.0,),
            Expanded(
              child: RaisedButton(
                child: Text('Random Numbers'),
                onPressed: displayRandom,

              ),
            ),
          ],
        ),
      ],
    );
  }

  void displayUsers() {
    controller.clear();
    BlocProvider.of<NumberLogicBloc>(context)
        .add(GetLogicForUsersNumber(inputString));
  }

  void displayRandom() {
  controller.clear();
  BlocProvider.of<NumberLogicBloc>(context)
      .add(GetLogicForRandomNumber());
  }
}
