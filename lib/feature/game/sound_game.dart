import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:flutter_application/product/widget/cards/custom_sound_game_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

class SoundGame extends StatefulWidget {
  final List<Word>? words;

  const SoundGame({this.words, Key? key}) : super(key: key);

  @override
  State<SoundGame> createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  final player = AudioPlayer();
  late List<String> words;
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
                CloudServices().addScoreToUser(
                    FirebaseAuth.instance.currentUser!.email!, score);
                _resetGame();
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
    Firebase.initializeApp();
    words = widget.words!.map((word) => word.name).toList();
    _startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: ColorConstants.cherryPearl,
      ),
      backgroundColor: ColorConstants.cherryPearl,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please choose correct Image',
              style: GoogleFonts.martelSans().copyWith(fontSize: 20),
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
              height: 40,
            ),
            Wrap(
              children: widget.words!
                  .map((word) => CustomSoundGameCard(
                        img: Image.network(word.url),
                        size: widget.words!.length > 12 ? 100 : 120,
                        onTap: () {
                          _checkAnswer(word.name);
                        },
                      ))
                  .toList(),
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
