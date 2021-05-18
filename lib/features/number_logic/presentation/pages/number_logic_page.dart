import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_logic/features/number_logic/presentation/bloc/number_logic_bloc.dart';
import 'package:number_logic/features/number_logic/presentation/widgets/button_controls.dart';
import 'package:number_logic/features/number_logic/presentation/widgets/loading_widget.dart';
import 'package:number_logic/features/number_logic/presentation/widgets/logic_display.dart';
import 'package:number_logic/features/number_logic/presentation/widgets/message_display.dart';
import 'package:number_logic/injection_container.dart';

class NumberLogicPage extends StatelessWidget {
  const NumberLogicPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Number Logic'),
      ),
      body:SingleChildScrollView(
          child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberLogicBloc> buildBody(BuildContext context){
    return BlocProvider(
        create: (_) => sl<NumberLogicBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              BlocBuilder<NumberLogicBloc, NumberLogicState>(
                builder: (context, state){
                  if(state is Empty){
                    return MessageDisplay(
                      message: 'Start Searching',
                    );
                  }else if(state is Loading){
                    return LoadingWidget();
                  }else if(state is Loaded){
                    return LogicDisplay(numberLogic: state.logic);
                  }else if(state is Error){
                    return MessageDisplay(
                      message: state.message,
                    );
                  }else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 10.0,),
              ButtonControls(),
            ],
          ),
        ),
      ),
    );
  }
}
