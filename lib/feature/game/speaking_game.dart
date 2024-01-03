import 'package:flutter/material.dart';

class PronunciationGame extends StatefulWidget {
  const PronunciationGame({super.key});

  @override
  _PronunciationGameState createState() => _PronunciationGameState();
}

class _PronunciationGameState extends State<PronunciationGame> {
  List<Map<String, dynamic>> imageList = [
    {'image': 'assets/image1.png', 'word': 'Apple'},
    {'image': 'assets/image2.png', 'word': 'Banana'},
    {'image': 'assets/image3.png', 'word': 'Cherry'},
    // Diğer resimler ve kelimeler
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageList[currentIndex]['image'],
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              imageList[currentIndex]['word'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kullanıcı butona tıkladığında doğru telaffuz kontrolü
                if (isCorrectPronunciation()) {
                  // Doğru telaffuz, bir sonraki kelimeye geç
                  nextWord();
                } else {
                  // Yanlış telaffuz, kullanıcıyı uyarabilirsiniz
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yanlış telaffuz! Lütfen tekrar deneyin.'),
                    ),
                  );
                }
              },
              child: const Text('Telaffuz Et'),
            ),
          ],
        ),
      ),
    );
  }

  bool isCorrectPronunciation() {
    // Burada gerçek bir sesli kontrol yapılabilir,
    // ancak bu örnekte basit bir simülasyon yapacağız.
    // Örneğin, her zaman doğru telaffuz edildi varsayalım.
    return true;
  }

  void nextWord() {
    setState(() {
      // Bir sonraki resmi ve kelimeyi göster
      if (currentIndex < imageList.length - 1) {
        currentIndex++;
      } else {
        // Oyun bitti
        showGameOverDialog();
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oyun Bitti'),
          content: const Text('Tebrikler! Oyunu tamamladınız.'),
          actions: [
            TextButton(
              onPressed: () {
                // Oyunu yeniden başlat
                resetGame();
                Navigator.pop(context);
              },
              child: const Text('Yeniden Başlat'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      // Oyun durumunu sıfırla
      currentIndex = 0;
    });
  }
}
