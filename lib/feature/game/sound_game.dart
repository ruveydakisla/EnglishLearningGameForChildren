import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:flutter_application/product/widget/cards/custom_sound_game_card.dart';
import 'package:kartal/kartal.dart';

class SoundGame extends StatefulWidget {
  const SoundGame({super.key});

  @override
  State<SoundGame> createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  final player = AudioPlayer();
  List<String> words = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eigth',
    'nine'
  ];
  String currentWord = '';
  int score = 0;
  bool gameStarted = false;
  late Timer timer;
  int gameTimeInSeconds = 60;
  late String word;

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
      gameTimeInSeconds = 30;
    });
  }

  void _playRandomWord() async {
    final Random random = Random();
    final int randomIndex = random.nextInt(words.length);
    final String selectedWord = words[randomIndex];
    setState(() {
      currentWord = selectedWord;
      word = selectedWord;
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
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          centerTitle: true,
          backgroundColor: ColorConstants.sunny,
          title: const Text('Numbers'),
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xff711DB0)),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          )),
      backgroundColor: ColorConstants.cherryPearl,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please choose correct Image',
              style: context.general.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Time: $gameTimeInSeconds seconds',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 170,
                height: 170,
                child: ElevatedButton(
                    onPressed: () {
                      SoundService().play(word);
                    },
                    child: IconConstants.icon_speaker.toImg)),
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                CustomSoundGameCard(
                  img: IconConstants.number_one.toImg,
                  onTap: () {
                    _checkAnswer('one');
                  },
                  // title: 'one',
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_two.toImg,
                  onTap: () {
                    _checkAnswer('two');
                  },
                  // title: 'five',
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_three.toImg,
                  onTap: () {
                    _checkAnswer('three');
                  },
                  // title: 'four',
                ),
              ],
            ),
            Row(
              children: [
                CustomSoundGameCard(
                  img: IconConstants.number_four.toImg,
                  onTap: () {
                    _checkAnswer('four');
                  },
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_five.toImg,
                  onTap: () {
                    _checkAnswer('five');
                  },
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_six.toImg,
                  onTap: () {
                    _checkAnswer('six');
                  },
                )
              ],
            ),
            Row(
              children: [
                CustomSoundGameCard(
                  img: IconConstants.number_seven.toImg,
                  onTap: () {
                    _checkAnswer('seven');
                  },
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_eight.toImg,
                  onTap: () {
                    _checkAnswer('eight');
                  },
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_nine.toImg,
                  onTap: () {
                    _checkAnswer('nine');
                  },
                )
              ],
            )
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
