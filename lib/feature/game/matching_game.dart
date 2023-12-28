import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/start_page.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'components/custom_card.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({Key? key, required this.vocabulary}) : super(key: key);
  final List<Word>? vocabulary;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<MatchingGame> {
  List<Word> words = [];
  List<bool> isTappedList = [];
  List<bool> isVisibleList = [];
  int matchedCount = 0;
  int elapsedTime = 0;
  bool gameEnded = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    resetGame();
    startGame();
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
    gameEnded = true;
    timer.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyun Bitti'),
        content: Text(
            'Toplam süre: $elapsedTime saniye\nEşleştirilen: $matchedCount'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartPage(),
                ),
              );
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    List<Word> vocabularyCopy = [...widget.vocabulary!, ...widget.vocabulary!];
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

      if (words[firstIndex].url == words[secondIndex].url) {
        setState(() {
          matchedCount++;
          isVisibleList[firstIndex] = false;
          isVisibleList[secondIndex] = false;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            isTappedList[firstIndex] = false;
            isTappedList[secondIndex] = false;
          });
        });
      }

      if (matchedCount == words.length) {
        endGame();
      }

      setState(() {
        isTappedList = List.generate(words.length, (index) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eşleştirme Oyunu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            Text('Eşleştirilen Sayısı: $matchedCount'),
            Text('Geçen Süre: $elapsedTime saniye'),
            ElevatedButton(
              onPressed: () {
                endGame();
              },
              child: const Text('Oyunu Bitir'),
            ),
          ],
        ),
      ),
    );
  }
}
