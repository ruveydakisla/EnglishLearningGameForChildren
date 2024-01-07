import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final player = AudioPlayer();

  play(String word) async {
    await player.play(UrlSource(
        'https://translate.google.com/translate_tts?ie=UTF-8&q=$word&tl=en&client=tw-ob'));
  }
}
