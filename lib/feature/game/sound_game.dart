import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/Vocabulary/index.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:flutter_application/product/widget/cards/index.dart';
import 'package:google_fonts/google_fonts.dart';

class SoundGame extends StatefulWidget {
  final List<Word>? words;

  const SoundGame({this.words, Key? key}) : super(key: key);

  @override
  State<SoundGame> createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  late ConfettiController _controllerCenter;
  final AudioCache audioCache = AudioCache();

// ...

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

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
        'https://translate.google.com/translate_tts?ie=UTF-8&q=$currentWord&tl=en&client=tw-ob'));
  }

  Future<void> _checkAnswer(String selectedWord) async {
    int points;
    if (selectedWord == currentWord) {
      // Correct answer
      points = 5;
      SoundService().playCorrect();
      _controllerCenter.play();
      Future.delayed(const Duration(seconds: 1), () {
        _playRandomWord();
      });
    } else {
      points = -4;
      SoundService().playWrong();
    }

    setState(() {
      score += points;
    });
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game End'),
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
    words = widget.words!.map((word) => word.name).toList();
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 50));
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
        backgroundColor: ColorConstants.cremeDeMenth,
      ),
      backgroundColor: ColorConstants.cremeDeMenth,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            SizedBox(
                width: 170,
                height: 170,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.cremeDeMenth),
                    onPressed: () {
                      SoundService().play(word);
                    },
                    child: IconConstants.icon_speaker.toImg)),
            const SizedBox(
              height: 40,
            ),
            Wrap(
              runSpacing: 5,
              spacing: 20,
              alignment: WrapAlignment.center,
              children: widget.words!
                  .map((word) => CustomSoundGameCard(
                        img: Image.network(word.url),
                        size: widget.words!.length > 12 ? 90 : 100,
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
    _controllerCenter.dispose();
  }
}
