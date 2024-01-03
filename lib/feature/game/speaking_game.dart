import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../product/Vocabulary/color_datas.dart';

class PronunciationGame extends StatefulWidget {
  final List<Word> wordList;

  const PronunciationGame({super.key, required this.wordList});

  @override
  _PronunciationGameState createState() => _PronunciationGameState();
}

class _PronunciationGameState extends State<PronunciationGame> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  int currentIndex = 0;
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (errorNotification) {
        print('Speech recognition error: $errorNotification');
      },
    );

    if (!available) {
      print('Speech recognition not available');
    }
  }

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
            Image.network(
              widget.wordList[currentIndex].url,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Söyle: ${widget.wordList[currentIndex].name}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _listen,
              onLongPress: () {
                startTime = DateTime.now();
              },

              // onLongPress: () {
              //   endTime = DateTime.now();
              //   _processResult();
              // },
              child: const Text('Mikrofon'),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_speech.isListening) {
      bool startListeningResult = await _speech.listen(
        onResult: (result) {
          print('Speech recognition result: $result');
        },
      );

      if (!startListeningResult) {
        print('Speech recognition failed to start');
      }
    }
  }

  void _processResult() {
    String? result = _speech.lastRecognizedWords;
    if (result.toLowerCase() ==
        widget.wordList[currentIndex].name.toLowerCase()) {
      // Doğru telaffuz, bir sonraki kelimeye geç
      if (currentIndex < widget.wordList.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        // Oyun bitti
        showGameOverDialog();
      }
    } else {
      // Yanlış telaffuz, kullanıcıyı uyar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yanlış telaffuz! Lütfen tekrar deneyin.'),
        ),
      );
    }
  }

  void showGameOverDialog() {
    setState(() {
      _speech.stop();
    });
    Duration duration = endTime!.difference(startTime!);
    int seconds = duration.inSeconds;
    int score = 100 - (seconds * 5); // Örnek bir puanlama
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oyun Bitti'),
          content: Text('Tebrikler! Oyunu tamamladınız. Puanınız: $score'),
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
      currentIndex = 0;
      startTime = null;
      endTime = null;
    });
  }
}
