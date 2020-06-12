import 'dart:io';
import 'dart:typed_data';

import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  List<String> pressedLetterList = [];
  List shownWord;
  String currentWord;
  int lives = 6;
  FlareControls flareControls = FlareControls();

  @override
  GameState get initialState => InitialState();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    switch (event.runtimeType) {
      case GameRestarted:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int wordCounter = (prefs.getInt('wordCounter') ?? 0);
        flareControls.play("0");
        lives = 6;
        currentWord = await getCurrentWord(wordCounter);
        shownWord = _generateShownWord(currentWord);
        yield UpdateShownWord();
        break;

      case LetterPressed:
        String pressedLetter = (event as LetterPressed).letter;
        pressedLetterList.add(pressedLetter);
        checkPressedWord(pressedLetter);
        yield UpdateShownWord();
        if (lives == 0) {
          yield LostGame();
        } else if (!shownWord.contains("_")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int wordCounter = (prefs.getInt('wordCounter') ?? 0) + 1;
          await prefs.setInt('wordCounter', wordCounter);
          yield WinGame();
        }
        break;
    }
  }

  checkPressedWord(String letter) {
    if (currentWord.contains(letter)) {
      for (int index = currentWord.indexOf(letter);
          index >= 0;
          index = currentWord.indexOf(letter, index + 1)) {
        shownWord[index] = letter;
      }
    } else {
      lives--;
      flareControls.play((6 - lives).toString());
    }
  }

  checkGameStatus() {}

  Future<String> getCurrentWord(int wordCounter) async {
    String data = await rootBundle.loadString("assets/words.txt");
    List<String> words = data.split('\r\n');
    words.map((word) => word.replaceAll('\n', ""));
    return words[wordCounter];
  }

  List _generateShownWord(String currentWord) {
    List<String> shownWord = currentWord.split('');
    for (int i = 0; i < shownWord.length; i++) {
      shownWord[i] = shownWord[i] == " " ? " " : "_";
    }
    return shownWord;
  }
}