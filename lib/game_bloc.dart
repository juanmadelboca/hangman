import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  List<String> pressedLetterList = [];
  List shownWord;
  String currentWord;
  int lives;

  @override
  GameState get initialState => InitialState();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    switch (event.runtimeType) {
      case GameRestarted:
        lives = 5;
        currentWord = "hockey";
        shownWord = List.generate(currentWord.length, (_) => "_");
        yield UpdateShownWord(shownWord.join(" ").toString());
        break;

      case LetterPressed:
        String pressedLetter = (event as LetterPressed).letter;
        pressedLetterList.add(pressedLetter);
        checkPressedWord(pressedLetter);
        yield UpdateShownWord(shownWord.join(" ").toString());
        if(lives == 0){
          yield LostGame();
        }
        if(!shownWord.contains("_")){
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
    }
  }

  checkGameStatus() {}
}

abstract class GameState {}

class UpdateShownWord extends GameState {
  final String shownWord;

  UpdateShownWord(this.shownWord);
}

class InitialState extends GameState {}

class LostGame extends GameState {}

class WinGame extends GameState {}

abstract class GameEvent {}

class GameRestarted extends GameEvent {}

class LetterPressed extends GameEvent {
  final String letter;

  LetterPressed(this.letter);
}
