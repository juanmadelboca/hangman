import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/game_bloc.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String alphabet = 'abcdefghijklmnopqrstuvwxyz';
  Color backgroundColor = Color(0xFF3F51B5);
  Color buttonColor = Color(0xFFab47bc);
  GameBloc _gameBloc;

  @override
  Widget build(BuildContext context) {
    _gameBloc = GameBloc()..add(GameRestarted());
    return BlocListener<GameBloc, GameState>(
      bloc: _gameBloc,
      listener: (context, state) {

        switch (state.runtimeType) {
          case WinGame:
            return _finishGameDialog(context,"You win");
            break;
          case LostGame:
            return _finishGameDialog(context, "You loose");
            break;
        }
    },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 450,
                alignment: Alignment.center,
                child: Image.asset('assets/hangman.png'),
              ),
              Container(
                  height: 90,
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<GameBloc, GameState>(
                      bloc: _gameBloc,
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case UpdateShownWord:
                            return Text(
                              (state as UpdateShownWord).shownWord,
                              style: TextStyle(fontSize: 40, color: Colors.white),
                            );
                            break;
                        }

                      })),

              //Container(height: 310,),
              Container(
                height: 310,
                child: GridView.builder(
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () =>
                            _gameBloc.add(LetterPressed(alphabet[position])),
                        child: Card(
                          color: buttonColor,
                          elevation: 2,
                          child: Center(
                            child: Text(
                              alphabet[position].toUpperCase(),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: alphabet.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _finishGameDialog(BuildContext context, String text) {
    return AlertDialog(
      content: Container(
        width: 400,
        height: 500,
        color: buttonColor,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text(text)),
            RaisedButton(child: Text("ok"), onPressed: () {Navigator.of(context).pop();},)
          ],
        ),
      ),
    );
  }
}
