// ... Diğer importlar ...

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:kartal/kartal.dart';

import '../../product/Vocabulary/color_datas.dart';
import '../../product/constants/icons_constants.dart';

// ... Diğer importlar ...

// ... Diğer importlar ...

class WordRiddle extends StatefulWidget {
  final List<Word>? wordList;
  const WordRiddle({Key? key, required this.wordList}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<WordRiddle> {
  String targetWord = '';
  String currentImageUrl = '';
  List<String> filledLetters = [];
  Duration gameDuration = const Duration();
  bool isGameFinished = false;
  Stopwatch stopwatch = Stopwatch();
  int currentWordIndex = 0;
  bool isGameStarted = false;

  final List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  void initState() {
    super.initState();
    resetGame();
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
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        currentImageUrl = generateRandomWord().url;
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Tebrikler!"),
              content: Text("Doğru kelimeyi buldunuz: $targetWord"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text("Sonraki Kelimeye Geç"),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Üzgünüz!"),
            content: const Text("Maalesef, yanlış tahmin."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Tamam"),
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
            title: const Text("Oyun Bitti!"),
            content: Text(
                "Tüm kelimeleri doğru bildiniz!\nSüre: ${gameDuration.inSeconds} saniye ${gameDuration.inMilliseconds % 1000} milisaniye"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Tamam"),
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

  @override
  Widget build(BuildContext context) {
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
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 30,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: targetWord
                      .split('')
                      .asMap()
                      .entries
                      .map(
                        (entry) => Container(
                          width: 45,
                          height: 45,
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
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.white),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: alphabet.map((letter) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 60,
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
                              "Check",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: ColorConstants.white),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconConstants.checkIcon.toImg
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.darkKnight),
                        onPressed: () {
                          resetGame();
                        },
                        child: Row(
                          children: [
                            Text(
                              "Start Again",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorConstants.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 30,
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
