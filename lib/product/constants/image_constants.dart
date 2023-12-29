import 'package:flutter/material.dart';

enum ImageConstants {
  children('children'),
  welcomeText('welcomeText'),
  iLovePlay(
      'https://img.freepik.com/free-vector/hand-drawn-pop-it-illustration_23-2149435812.jpg?size=626&ext=jpg'),
  education(
      'https://img.freepik.com/free-vector/schoolbag-supplies-back-school_24640-46272.jpg'),

  foods(
      'https://img.freepik.com/free-vector/delicious-sweet-products-kawaii-characters_24640-46411.jpg'),

  backgraund(
      'https://img.freepik.com/free-photo/xoxo-alphabet-letter-beads-typography_53876-94459.jpg?size=626&ext=jpg&uid=R132188031&semt=ais'),
  fish(
      'https://img.freepik.com/premium-vector/blue-fish-algae_24640-80261.jpg'),
  wordGame(
      'https://img.freepik.com/premium-photo/dictionary-3d-render-icon-illustration_726846-1551.jpg?size=626&ext=jpg&uid=R132188031&semt=ais'),
  soundGame2(
      'https://img.freepik.com/free-vector/character-playing-videogame-concept_23-2148539624.jpg?size=626&ext=jpg'),
  signInImg(
      'https://img.freepik.com/free-vector/hand-drawn-english-school-background_23-2149496629.jpg?t=st=1703785329~exp=1703785929~hmac=f822067868a5867e5b9790ab513d7eff5f9c0a52756d17db9a88f0b22fc547e4'),
  soundGame(
      'https://img.freepik.com/free-vector/illustrated-k-pop-music-concept_23-2148633628.jpg?size=626&ext=jpg');

  final String value;

  const ImageConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.network(value);
}
