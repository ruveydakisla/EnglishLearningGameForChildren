import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class SoundService {
  // final player = AudioPlayer();

  // play(String word) async {
  //   await player.play(UrlSource(
  //       'https://translate.google.com/translate_tts?ie=UTF-8&q=$word&tl=en&client=tw-ob'));
  // }

  TextToSpeech tts = TextToSpeech();
  play(String word) {
    tts.speak(word);
  }
}
