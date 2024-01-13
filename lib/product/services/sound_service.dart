import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final player = AudioPlayer();
  final assetsAudioPlayer = AssetsAudioPlayer();

  play(String word) async {
    await player.play(UrlSource(
        'https://translate.google.com/translate_tts?ie=UTF-8&q=$word&tl=en&client=tw-ob'));
  }

  void playCorrect() {
    assetsAudioPlayer.open(
      Audio("assets/sounds/correctt.mp3"),
    );
  }

  void playWrong() {
    assetsAudioPlayer.open(
      Audio("assets/sounds/soft.mp3"),
    );
  }

  void playSong() {
    assetsAudioPlayer.open(
      Audio("assets/sounds/music.mp3"),
    );
  }

  void stopSong() {
    assetsAudioPlayer.stop();
  }
}
