import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/pages/game/game_bloc.dart';

import 'game_event.dart';
import 'game_state.dart';

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
    _gameBloc.listen((state) {
      switch (state.runtimeType) {
        case WinGame:
          gameFinishedMenu(context);
          break;
      }
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
                height: 450,
                alignment: Alignment.center,
                child: Container(
                  height: 350,
                  child: FlareActor(
                    "assets/hangman.flr",
                    controller: _gameBloc.flareControls,
                  ),
                )),
            Container(
                height: 90,
                alignment: Alignment.bottomCenter,
                child: BlocBuilder<GameBloc, GameState>(
                    bloc: _gameBloc,
                    condition: (GameState previous, GameState current) =>
                        previous.runtimeType != WinGame,
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case UpdateShownWord:
                          return Text(
                            _gameBloc.shownWord?.join(" ").toString(),
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          );
                          break;
                        default:
                          return SizedBox();
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
    );
  }

  void gameFinishedMenu(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        color: backgroundColor,
        height: 500.0,
        width: 400.0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Text(
                "You win",
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
              SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      child: Text(
                        "MENU",
                        style: TextStyle(color: buttonColor, fontSize: 22),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/MenuPage');
                      }),
                  RaisedButton(
                    child: Text("CONTINUE",
                        style: TextStyle(color: buttonColor, fontSize: 22)),
                    onPressed: () {
                      _gameBloc..add(GameRestarted());
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }
}
