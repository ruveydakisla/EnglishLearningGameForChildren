import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'components/custom_card.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key, required this.vocabulary}) : super(key: key);
  final List<Word>? vocabulary;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<MatchingGame> {
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;
  List<Word> words = [];
  List<bool> isTappedList = [];
  List<bool> isVisibleList = [];
  int matchedCount = 0;
  int elapsedTime = 0;
  int totalScore = 0;
  bool gameEnded = false;
  late Timer timer;
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

  @override
  void initState() {
    super.initState();
    resetGame();
    startGame();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startGame() {
    if (gameEnded) {
      resetGame();
    }

    setState(() {
      isVisibleList = List.generate(words.length * 2, (index) => true);
    });

    isTappedList = List.generate(words.length * 2, (index) => false);
    matchedCount = 0;
    elapsedTime = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });

      if (matchedCount == words.length) {
        endGame();
      }
    });
  }

  void endGame() {
    _controllerTopCenter.play();
    _controllerBottomCenter.play();

    gameEnded = true;
    timer.cancel();

    CloudServices()
        .addScoreToUser(FirebaseAuth.instance.currentUser!.email!, totalScore);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game end'),
        content: Text(
            'Total time: $elapsedTime seconds\nMatched: $matchedCount\nScore: $totalScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Okay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
              isVisibleList = List.generate(words.length * 2, (index) => true);
              startGame();
            },
            child: const Text('Start Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    List<Word> vocabularyCopy = [];
    for (var word in widget.vocabulary!) {
      vocabularyCopy.add(word);

      // İlk kelimenin kopyasını ekler
      vocabularyCopy.add(Word(name: word.name, url: word.url, isImage: false));
    }
    vocabularyCopy.shuffle();
    setState(() {
      isTappedList = List.generate(vocabularyCopy.length, (index) => false);
      isVisibleList = List.generate(vocabularyCopy.length, (index) => false);
      matchedCount = 0;
      elapsedTime = 0;
      gameEnded = false;
    });

    words = vocabularyCopy;
  }

  void onCardTapped(int index) {
    if (!isTappedList[index] && isVisibleList[index]) {
      setState(() {
        isTappedList[index] = true;

        if (isTappedList.where((element) => element).length == 2) {
          Future.delayed(const Duration(milliseconds: 500), () {
            checkMatched();
          });
        }
      });
    }
  }

  void checkMatched() {
    List<int> tappedIndices = isTappedList
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (tappedIndices.length == 2) {
      int firstIndex = tappedIndices[0];
      int secondIndex = tappedIndices[1];

      if (words[firstIndex].name == words[secondIndex].name) {
        setState(() {
          SoundService().playCorrect();
          isVisibleList[firstIndex] = false;
          isVisibleList[secondIndex] = false;
          totalScore += 10;
          matchedCount++;
          if (matchedCount == words.length / 2) {
            endGame();
          }
        });
      } else {
        SoundService().playWrong();

        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            isTappedList[firstIndex] = false;
            isTappedList[secondIndex] = false;
          });
        });
      }

      setState(() {
        isTappedList = List.generate(words.length, (index) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  //BOTTOM CENTER
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConfettiWidget(
                      confettiController: _controllerBottomCenter,
                      blastDirection: -pi / 2,
                      emissionFrequency: 0.01,
                      numberOfParticles: 20,
                      maxBlastForce: 100,
                      minBlastForce: 80,
                      gravity: 0.3,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _controllerTopCenter,
                      blastDirection: pi / 2,
                      maxBlastForce: 5, // set a lower max blast force
                      minBlastForce: 2, // set a lower min blast force
                      emissionFrequency: 0.05,
                      numberOfParticles: 50, // a lot of particles at once
                      gravity: 1,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: ColorConstants.actOfWrath,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    margin: EdgeInsets.zero,
                    width: 300,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Time',
                            style: context.general.textTheme.bodyLarge
                                ?.copyWith(color: ColorConstants.white),
                          ),
                          Text(
                            elapsedTime.toString(),
                            style: GoogleFonts.bungeeSpice()
                                .copyWith(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    width: 500,
                    color: ColorConstants.darkKnight,
                    child: Column(
                      children: [
                        Text(
                          'Matched ',
                          style: context.general.textTheme.bodyLarge?.copyWith(
                              fontSize: 20, color: ColorConstants.white),
                        ),
                        Text(
                          matchedCount.toString(),
                          style:
                              GoogleFonts.bungeeSpice().copyWith(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    isImage: words[index].isImage ?? true,
                    word: words[index],
                    isVisible:
                        isVisibleList.isNotEmpty && index < isVisibleList.length
                            ? isVisibleList[index]
                            : false,
                    onTap: () {
                      onCardTapped(index);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
