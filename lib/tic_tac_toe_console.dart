import 'dart:io';
import 'dart:math';

class TicTacToe {
  List<List<String>> board;
  String humanPlayer;
  String aiPlayer;
  bool vsAI;

  TicTacToe({this.vsAI = false})
    : board = List.generate(3, (_) => List.filled(3, ' ')),
      humanPlayer = 'X',
      aiPlayer = 'O';

  void start() {
    print("\n🎮 Welcome to Dart Tic-Tac-Toe!");
    _chooseMode();

    while (true) {
      _printBoard();

      if (vsAI && _currentPlayer() == aiPlayer) {
        print("🤖 AI is thinking...");
        _aiMove();
      } else {
        _playerMove();
      }

      if (_checkWinner(_currentPlayer())) {
        _printBoard();
        print(
          "🎉 ${_currentPlayer() == humanPlayer ? 'You' : (vsAI ? 'AI' : 'Player')} (${_currentPlayer()}) wins!",
        );
        if (!_askReplay()) break;
        _resetGame();
        continue;
      }

      if (_isDraw()) {
        _printBoard();
        print("⚖️ It's a draw!");
        if (!_askReplay()) break;
        _resetGame();
        continue;
      }

      print("Next turn...");
    }

    print("👋 Thanks for playing!");
  }

  void _chooseMode() {
    stdout.write("Play vs AI? (y/n): ");
    String? input = stdin.readLineSync();
    vsAI = input?.toLowerCase().startsWith('y') ?? false;

    stdout.write("Choose your marker (X/O): ");
    String? choice = stdin.readLineSync();
    if (choice != null && choice.toUpperCase() == 'O') {
      humanPlayer = 'O';
      aiPlayer = 'X';
    } else {
      humanPlayer = 'X';
      aiPlayer = 'O';
    }
  }

  String _currentPlayer() {
    int totalMoves = board.expand((r) => r).where((c) => c != ' ').length;
    return totalMoves % 2 == 0 ? 'X' : 'O';
  }

  void _printBoard() {
    print("\nCurrent Board:");
    for (int i = 0; i < 3; i++) {
      print(" ${board[i][0]} | ${board[i][1]} | ${board[i][2]} ");
      if (i < 2) print("---|---|---");
    }
  }

  void _playerMove() {
    while (true) {
      stdout.write("Your move (${_currentPlayer()}), choose 1-9: ");
      String? input = stdin.readLineSync();

      if (input == null || int.tryParse(input) == null) {
        print("⚠️ Invalid input. Enter a number between 1 and 9.");
        continue;
      }

      int pos = int.parse(input);
      if (pos < 1 || pos > 9) {
        print("⚠️ Number out of range.");
        continue;
      }

      int row = (pos - 1) ~/ 3;
      int col = (pos - 1) % 3;

      if (board[row][col] != ' ') {
        print("❌ Cell already taken. Try again.");
        continue;
      }

      board[row][col] = _currentPlayer();
      break;
    }
  }

  void _aiMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < 9; i++) {
      int row = i ~/ 3;
      int col = i % 3;
      if (board[row][col] == ' ') emptyCells.add(i);
    }

    // Simple random AI move
    int move = emptyCells[Random().nextInt(emptyCells.length)];
    int row = move ~/ 3;
    int col = move % 3;
    board[row][col] = aiPlayer;
  }

  bool _checkWinner(String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player)) return true;
      if (board.every((row) => row[i] == player)) return true;
    }

    if (board[0][0] == player && board[1][1] == player && board[2][2] == player)
      return true;
    if (board[0][2] == player && board[1][1] == player && board[2][0] == player)
      return true;

    return false;
  }

  bool _isDraw() {
    return board.expand((row) => row).every((cell) => cell != ' ');
  }

  bool _askReplay() {
    stdout.write("🔁 Play again? (y/n): ");
    String? input = stdin.readLineSync();
    return input?.toLowerCase().startsWith('y') ?? false;
  }

  void _resetGame() {
    board = List.generate(3, (_) => List.filled(3, ' '));
  }
}

void main() {
  TicTacToe game = TicTacToe();
  game.start();
}
