import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String targetWord = "FLUTTER"; // Resme karşılık gelen kelime
  List<String?> displayedWord = []; // Kullanıcının girişi
  List<bool> filledLetters =
      []; // Harfin doğru olup olmadığını kontrol etmek için

  @override
  void initState() {
    super.initState();
    initializeWord();
  }

  void initializeWord() {
    for (int i = 0; i < targetWord.length; i++) {
      displayedWord.add(null);
      filledLetters.add(false);
    }
  }

  void checkWord() {
    bool isCorrect = true;
    for (int i = 0; i < targetWord.length; i++) {
      if (targetWord[i] == displayedWord[i]) {
        filledLetters[i] = true;
      } else {
        isCorrect = false;
        filledLetters[i] = false;
      }
    }

    if (isCorrect) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Tebrikler!"),
            content: Text("Doğru kelimeyi buldunuz: $targetWord"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  resetGame();
                  Navigator.of(context).pop();
                },
                child: const Text("Yeniden Oyna"),
              ),
            ],
          );
        },
      );
    }
  }

  void resetGame() {
    setState(() {
      targetWord = generateRandomWord();
      displayedWord = List.generate(targetWord.length, (index) => null);
      filledLetters = List.generate(targetWord.length, (index) => false);
    });
  }

  String generateRandomWord() {
    // Basit bir örnek: Sabit bir kelime listesi yerine daha gelişmiş bir kelime havuzu kullanılabilir.
    List<String> words = ["FLUTTER", "DART", "WIDGET", "DEVELOPMENT"];
    return words[Random().nextInt(words.length)];
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
            // Resmi ekledik
            IconConstants.clothesIcon.toImg,
            const SizedBox(height: 20),
            const Text("Resme Karşılık Gelen Kelime:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: displayedWord
                  .map((letter) => Text(
                        letter ?? "_",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 26,
              itemBuilder: (context, index) {
                String letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!filledLetters.contains(true)) {
                        for (int i = 0; i < targetWord.length; i++) {
                          if (!filledLetters[i]) {
                            if (targetWord[i] == letter) {
                              displayedWord[i] = letter;
                              filledLetters[i] = true;
                            }
                          }
                        }
                      }
                    });
                    checkWord();
                  },
                  child: Text(letter),
                );
              },
            ),
            const SizedBox(height: 20),
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
