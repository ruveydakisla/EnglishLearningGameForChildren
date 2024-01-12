import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:kartal/kartal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../product/Vocabulary/index.dart';

class PronunciationGame extends StatefulWidget {
  final List<Word> wordList;

  const PronunciationGame({super.key, required this.wordList});

  @override
  // ignore: library_private_types_in_public_api
  _PronunciationGameState createState() => _PronunciationGameState();
}

class _PronunciationGameState extends State<PronunciationGame> {
  Future<void> _checkPermission() async {
    // Mikrofon izni kontrol ediliyor
    var status = await Permission.microphone.status;

    if (status.isDenied) {
      // Eğer izin reddedilmişse, kullanıcıdan izin isteniyor
      await Permission.microphone.request();
    }
  }

  final stt.SpeechToText _speech = stt.SpeechToText();

  int currentIndex = 0;
  DateTime? startTime;
  DateTime? endTime;
  bool isListening = false;
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

  void _startListening() async {
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      if (!_speech.isListening) {
        setState(() {
          isListening = true;
          startTime = DateTime.now(); // Konuşma başladığında zamanı kaydet
        });

        await _speech.listen(
          onResult: (result) {
            String recognizedText = result.recognizedWords;
            print('Speech recognition result: $recognizedText');
            // Eğer tanınan metin boş değilse, işleme devam et
            if (recognizedText.trim().isNotEmpty) {
              _processResult();
            }
          },
        );
      }
    } else {
      print('Mikrofon izni reddedildi');
      // Kullanıcıya mikrofon erişimi gerektiğini bildirmek için bir dialog veya mesaj gösterebilirsiniz.
    }
  }

  void _stopListening() {
    if (_speech.isListening) {
      setState(() {
        isListening = false;
      });

      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cherryPearl,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ColorConstants.cremeDeMenth,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.darkKnight,
        title: Text(
          'Pronunciation Game',
          style: context.general.textTheme.headlineSmall!
              .copyWith(color: ColorConstants.cremeDeMenth),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                      width: 5, color: ColorConstants.actOfWrath)),
              child: Image.network(
                widget.wordList[currentIndex].url,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Say: ${widget.wordList[currentIndex].name}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!isListening) {
                      _startListening();
                    }
                  },
                  child: const Text('Start Listening'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (isListening) {
                      _stopListening();
                    }
                  },
                  child: const Text('Stop Listening'),
                ),
              ],
            ),
            SizedBox(
              height: 170,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.cherryPearl,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150),
                        side: const BorderSide(
                            color: ColorConstants.darkKnight))),
                onPressed: _listen,
                onLongPress: () {
                  startTime = DateTime.now();
                },
                // onLongPressUp yerine onResult kullanılacak
                // Bu olay, konuşma sona erdiğinde çağrılır
                // Tanıma sonuçlarını kontrol etmek için kullanılır
                // Result sıfır veya boş bir dize ise, kullanıcının konuşması tamamlandı demektir
                child: IconConstants.microphoneIcon.toImg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          String recognizedText = result.recognizedWords;
          print('Speech recognition result: $recognizedText');
          // Eğer tanınan metin boş değilse, işleme devam et
          if (recognizedText.trim().isNotEmpty) {
            _processResult();
          }
        },
      );

      // Kullanıcının konuşması tamamlanmasını beklemek için bir süre bekle
      // await Future.delayed(const Duration(seconds: 5));

      // Bekleme sona erdiğinde, dinlemeyi durdurabilirsiniz
      if (_speech.isListening) {
        _speech.stop();
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
