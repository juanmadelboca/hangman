abstract class GameEvent {}

class GameRestarted extends GameEvent {}

class LetterPressed extends GameEvent {
  final String letter;

  LetterPressed(this.letter);
}
