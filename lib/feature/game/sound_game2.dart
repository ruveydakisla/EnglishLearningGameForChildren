import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final player = AudioPlayer();
  List<String> words = ['apple', 'banana', 'orange', 'grape', 'cherry'];
  String currentWord = '';
  int score = 0;
  bool gameStarted = false;
  late Timer timer;
  int gameTimeInSeconds = 60;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    if (!gameStarted) {
      _resetGame(); // Oyun başlamadan önce sıfırla
      _playRandomWord();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          gameTimeInSeconds--;
          if (gameTimeInSeconds <= 0) {
            timer.cancel();
            _showEndGameDialog();
          }
        });
      });
      gameStarted = true;
    }
  }

  void _resetGame() {
    setState(() {
      score = 0;
      gameTimeInSeconds = 10;
    });
  }

  void _playRandomWord() async {
    final Random random = Random();
    final int randomIndex = random.nextInt(words.length);
    final String selectedWord = words[randomIndex];
    setState(() {
      currentWord = selectedWord;
    });
    await player.play(UrlSource(
        'https://translate.google.com/translate_tts?ie=UTF-8&q=$currentWord&tl=en&client=tw-ob')); // Sesi çal
  }

  void _checkAnswer(String selectedWord) {
    int points;
    if (selectedWord == currentWord) {
      // Doğru cevap
      points = 5;
    } else {
      // Yanlış cevap
      points = -4;
    }

    setState(() {
      score += points;
    });

    _playRandomWord(); // Sonraki kelimeye geç
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                _resetGame(); // Oyun bittikten sonra sıfırla
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('  Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Listen to the word and select the correct one:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkAnswer('apple');
              },
              child: const Text('Apple'),
            ),
            ElevatedButton(
              onPressed: () {
                _checkAnswer('banana');
              },
              child: const Text('Banana'),
            ),
            ElevatedButton(
              onPressed: () {
                _checkAnswer('orange');
              },
              child: const Text('Orange'),
            ),
            ElevatedButton(
              onPressed: () {
                _checkAnswer('grape');
              },
              child: const Text('Grape'),
            ),
            ElevatedButton(
              onPressed: () {
                _checkAnswer('cherry');
              },
              child: const Text('Cherry'),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Time: $gameTimeInSeconds seconds',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel(); // Widget kapatıldığında timer'ı iptal et
    super.dispose();
  }
}
