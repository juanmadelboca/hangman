abstract class GameState {}

class UpdateShownWord extends GameState {}

class InitialState extends GameState {}

class LostGame extends GameState {
  final String word;
  LostGame(this.word);
}

class WinGame extends GameState {
  final String word;
  WinGame(this.word);
}
