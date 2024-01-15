import 'package:flutter/material.dart';
import 'package:flutter_application/core/services/auth_services.dart';
import 'package:flutter_application/core/services/cloud_services.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:kartal/kartal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';
import '../../product/Vocabulary/index.dart';

class PronunciationGame extends StatefulWidget {
  final List<Word> vocabulary;

  const PronunciationGame({super.key, required this.vocabulary});

  @override
  _PronunciationGameState createState() => _PronunciationGameState();
}

class _PronunciationGameState extends State<PronunciationGame> {
  Future<void> _checkPermission() async {
    var status = await Permission.microphone.status;

    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  final stt.SpeechToText _speech = stt.SpeechToText();
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = "";

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

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    _processResult();
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
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/backgraund.png'))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                        width: 5, color: ColorConstants.actOfWrath)),
                child: Image.network(
                  widget.vocabulary[currentIndex].url,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Say: ${widget.vocabulary[currentIndex].name}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 170,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.cherryPearl,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150),
                          side: const BorderSide(
                              color: ColorConstants.darkKnight))),
                  onPressed: _startListening,
                  child: IconConstants.microphoneIcon.toImg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processResult() {
    if (_lastWords.trim().isNotEmpty) {
      if (_lastWords.toLowerCase() ==
          widget.vocabulary[currentIndex].name.toLowerCase()) {
        if (currentIndex < widget.vocabulary.length - 1) {
          setState(() {
            currentIndex++;
          });
          SoundService().playCorrect();
          _stopListening();

          _startListening();
        } else {
          showGameOverDialog();
        }
      } else {
        SoundService().playWrong();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Try Again!'),
          ),
        );
      }
    }
  }

  void showGameOverDialog() {
    setState(() {
      _speech.stop();
    });
    Duration duration = endTime!.difference(startTime!);
    int seconds = duration.inSeconds;
    int score = 100 - (seconds * 5);
    CloudServices()
        .addScoreToUser(AuthServices().auth.currentUser!.email!, score);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game End'),
          content: Text('Congrats! . Your Score: $score'),
          actions: [
            TextButton(
              onPressed: () {
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
