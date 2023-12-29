import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';

class WordRiddle extends StatefulWidget {
  final List<Word> wordList;
  const WordRiddle({Key? key, required this.wordList}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

// ...

class _GameScreenState extends State<WordRiddle> {
  String targetWord = '';
  String currentImageUrl = '';
  TextEditingController userGuessController = TextEditingController();
  List<String> filledLetters = [];
  Duration gameDuration = const Duration();
  bool isGameFinished = false;
  Stopwatch stopwatch = Stopwatch();
  int currentWordIndex = 0; // Yeni ekledik

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void initializeWord() {
    final randomWord = generateRandomWord();
    setState(() {
      targetWord = randomWord.name;
      currentImageUrl = randomWord.url;
      filledLetters = List.generate(targetWord.length, (index) => '');
    });
  }

  void checkWord() {
    if (isGameFinished) {
      return;
    }

    bool isCorrect = true;

    for (int i = 0; i < targetWord.length; i++) {
      if (targetWord[i] != userGuessController.text[i]) {
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

        if (currentWordIndex < widget.wordList.length) {
          resetGame();
        } else {
          setState(() {
            isGameFinished = true;
            gameDuration = stopwatch.elapsed; // Oyun bittiğinde süreyi kaydet
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

  void resetGame() {
    if (isGameFinished) {
      setState(() {
        isGameFinished = false;
      });
    }

    final randomWord = generateRandomWord();
    setState(() {
      targetWord = randomWord.name;
      currentImageUrl = randomWord.url;
      userGuessController.clear();
      filledLetters = List.generate(targetWord.length, (index) => '');
      stopwatch.reset();
      stopwatch.start();
    });
  }

  Word generateRandomWord() {
    final random = Random();
    return widget.wordList[currentWordIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resimli Kelime Bulmaca Oyunu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Resme Karşılık Gelen Kelime:"),
            Image.network(
              currentImageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: targetWord
                  .split('')
                  .asMap()
                  .entries
                  .map(
                    (entry) => Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          entry.key < filledLetters.length
                              ? filledLetters[entry.key]
                              : '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: userGuessController,
              onChanged: (value) {
                setState(() {
                  filledLetters = value.split('');
                });
              },
              decoration: const InputDecoration(
                labelText: 'Kelimeyi Giriniz',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: targetWord.length,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkWord();
              },
              child: const Text("Tahmin Et"),
            ),
            ElevatedButton(
              onPressed: () {
                resetGame();
              },
              child: const Text("Yeniden Başla"),
            ),
          ],
        ),
      ),
    );
  }
}
