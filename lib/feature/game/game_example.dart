import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String word;
  final Widget image;
  final Function() onTap;
  final bool isVisible;

  const CustomCard({
    Key? key,
    required this.word,
    required this.image,
    required this.onTap,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: Card(
          elevation: 5,
          shadowColor: Colors.yellow,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isVisible ? Colors.white : Colors.yellow,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isVisible
                    ? word.isNotEmpty
                        ? Text(word)
                        : image
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const GamePage(),
              ),
            );
          },
          child: const Text('Oyunu Başlat'),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<String, String> wordImageMap = {};
  List<String> words = [];
  List<Widget> images = [];
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
      isVisibleList = List.generate(wordImageMap.length * 2, (index) => true);
    });

    isTappedList = List.generate(wordImageMap.length * 2, (index) => false);
    matchedCount = 0;
    elapsedTime = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });

      if (matchedCount == wordImageMap.length) {
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
    wordImageMap = _generateWordImageMap();
    List<MapEntry<String, String>> entries = wordImageMap.entries.toList();

    // Elemanları rastgele sırala
    entries.shuffle(Random(DateTime.now().millisecondsSinceEpoch));

    // Her kartın sıradaki elemanla eşleşeceği şekilde kartları düzenle
    words = [];
    images = [];

    for (int i = 0; i < entries.length; i++) {
      words.add(entries[i].key);
      images.add(Image.network(entries[i].value));
    }

    setState(() {
      isTappedList = List.generate(wordImageMap.length * 2, (index) => false);
      isVisibleList = List.generate(wordImageMap.length * 2, (index) => false);
      matchedCount = 0;
      elapsedTime = 0;
      gameEnded = false;
    });
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

      if (wordImageMap[words[firstIndex ~/ 2]] ==
          wordImageMap[words[secondIndex ~/ 2]]) {
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

      if (matchedCount == wordImageMap.length) {
        endGame();
      }

      setState(() {
        isTappedList = List.generate(wordImageMap.length * 2, (index) => false);
      });
    }
  }

  Map<String, String> _generateWordImageMap() {
    return {
      'Grape':
          'https://cdn-icons-png.flaticon.com/128/10507/10507344.png?semt=ais',
      'Apple':
          'https://cdn-icons-png.flaticon.com/128/3137/3137044.png?semt=ais',
      'Cherry': 'https://cdn-icons-png.flaticon.com/128/457/457818.png',
      'Banana': 'https://cdn-icons-png.flaticon.com/128/3259/3259530.png',
      'Orange': 'https://cdn-icons-png.flaticon.com/128/1574/1574301.png',
      'Kiwi': 'https://cdn-icons-png.flaticon.com/128/1054/1054141.png',
    };
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
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wordImageMap.length * 2,
              itemBuilder: (context, index) {
                return CustomCard(
                  word: index % 2 == 0 ? words[index ~/ 2] : '',
                  image: index % 2 == 1
                      ? images[index ~/ 2]
                      : Image.network('https://example.com/placeholder.png'),
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
