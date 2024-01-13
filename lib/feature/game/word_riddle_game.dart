import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import '../../product/Vocabulary/index.dart';

class WordRiddle extends StatefulWidget {
  final List<Word>? wordList;
  const WordRiddle({Key? key, required this.wordList}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends WordRiddlee {
  @override
  Widget build(BuildContext context) {
    const sizedBox30 = SizedBox(
      height: 30,
    );
    const sizedBox25 = SizedBox(height: 25);
    const sizedBox5 = SizedBox(
      width: 5,
    );
    var removeIcon = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: PageSizes.elevetadButtonRemove,
          height: PageSizes.elevetadButtonRemove,
          child: IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              deleteLetter();
            },
            icon: IconConstants.removeIcon.toImg,
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.actOfWrath,
      ),
      body: Container(
        color: ColorConstants.cremeDeMenth,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  currentImageUrl,
                  height: PageSizes.imgSize,
                  width: PageSizes.imgSize,
                  fit: BoxFit.cover,
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
                sizedBox30,
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: PageSizes.wrapSpacing,
                  runSpacing: PageSizes.wrapRunSpacing,
                  children: targetWord
                      .split('')
                      .asMap()
                      .entries
                      .map(
                        (entry) => Container(
                          width: PageSizes.containerWidth,
                          height: PageSizes.containerHeight,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ColorConstants.darkKnight,
                            border:
                                Border.all(color: ColorConstants.cherryPearl),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              entry.key < filledLetters.length
                                  ? filledLetters[entry.key]
                                  : '',
                              style: TextStyle(
                                  fontSize: PageSizes.fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                sizedBox25,
                Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: PageSizes.wrapSpacing,
                      runSpacing: PageSizes.wrapRunSpacing,
                      children: StringConstants.alphabet.map((letter) {
                        Color randomColor = Color(
                                (Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                            .withOpacity(1.0);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: randomColor,
                          ),
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < targetWord.length; i++) {
                                if (filledLetters[i].isEmpty) {
                                  filledLetters[i] = letter;
                                  break;
                                }
                              }
                            });
                          },
                          child: Text(
                            letter,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                    removeIcon,
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: PageSizes.elevetadButtonCheckWidth,
                      height: PageSizes.elevetadButtonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.darkKnight),
                        onPressed: () {
                          checkWord();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              StringConstants.check,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: ColorConstants.white),
                            ),
                            SizedBox(
                              width: PageSizes.checkIconWidth,
                            ),
                            IconConstants.checkIcon.toImg
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: PageSizes.elevetadButtonAgainWidth,
                      height: PageSizes.elevetadButtonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.darkKnight),
                        onPressed: () {
                          resetGame();
                        },
                        child: Row(
                          children: [
                            Text(
                              StringConstants.startAgain,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorConstants.white),
                            ),
                            sizedBox5,
                            SizedBox(
                              width: PageSizes.iconWidth,
                              height: PageSizes.iconWidth,
                              child: IconConstants.startAgainIcon.toImg,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract class WordRiddlee extends State<WordRiddle> {
  String targetWord = '';
  String currentImageUrl = '';
  List<String> filledLetters = [];
  Duration gameDuration = const Duration();
  bool isGameFinished = false;
  Stopwatch stopwatch = Stopwatch();
  int currentWordIndex = 0;
  bool isGameStarted = false;
  late ConfettiController _controllerCenter;
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
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 50));
  }

  void startGame() {
    if (!isGameStarted) {
      setState(() {
        isGameStarted = true;
      });
      stopwatch.start();
    }
  }

  void initializeWord() {
    final randomWord = generateRandomWord();
    setState(() {
      targetWord = randomWord.name.toUpperCase();
      currentImageUrl = randomWord.url;
      filledLetters = List.generate(targetWord.length, (index) => '');
    });
  }

  void checkWord() {
    startGame();

    if (isGameFinished) {
      return;
    }

    bool isCorrect = true;

    for (int i = 0; i < targetWord.length; i++) {
      if (targetWord[i].toUpperCase() != filledLetters[i].toUpperCase()) {
        isCorrect = false;
        SoundService().playWrong(); // nedennn??
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        currentImageUrl = generateRandomWord().url;
        SoundService().playCorrect();
        _controllerCenter.play();
      });

      if (filledLetters.join() == targetWord) {
        setState(() {
          currentWordIndex++;
        });

        if (currentWordIndex < widget.wordList!.length) {
          resetGame();
        } else {
          endGame();
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(StringConstants.sorry),
            content: const Text(StringConstants.wrongGuess),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(StringConstants.ok),
              ),
            ],
          );
        },
      );
    }
  }

  void deleteLetter() {
    if (isGameFinished) {
      return;
    }

    for (int i = targetWord.length - 1; i >= 0; i--) {
      if (filledLetters[i].isNotEmpty) {
        setState(() {
          filledLetters[i] = '';
          return;
        });
      }
    }
  }

  void resetGame() {
    if (isGameFinished) {
      setState(() {
        isGameFinished = false;
      });
    }

    final randomWord = generateRandomWord();
    setState(() {
      targetWord = randomWord.name.toUpperCase();
      currentImageUrl = randomWord.url;
      filledLetters = List.generate(targetWord.length, (index) => '');
      stopwatch.reset();
      stopwatch.start();
    });
  }

  void endGame() {
    if (isGameStarted) {
      setState(() {
        isGameFinished = true;
        gameDuration = stopwatch.elapsed;
      });

      stopwatch.stop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(StringConstants.gameEnd),
            content: Text(
                "${StringConstants.gameDuration} ${gameDuration.inSeconds} ${StringConstants.second}"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(StringConstants.ok),
              ),
            ],
          );
        },
      );
    }
  }

  Word generateRandomWord() {
    final random = Random();
    return widget.wordList![currentWordIndex];
  }
}

class PageSizes {
  static double imgSize = 120;
  static double wrapSpacing = 8.0;
  static double wrapRunSpacing = 8.0;
  static double containerWidth = 45;
  static double containerHeight = 45;
  static double elevetadButtonCheckWidth = 220;
  static double elevetadButtonAgainWidth = 170;
  static double elevetadButtonHeight = 60;
  static double elevetadButtonRemove = 70;
  static double iconWidth = 20;
  static double checkIconWidth = 30;

  static double fontSize = 18;
}
