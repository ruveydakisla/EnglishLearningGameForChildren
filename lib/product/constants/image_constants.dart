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
  animals(
      'https://img.freepik.com/premium-vector/collection-cute-wild-animal-illustrations_338371-473.jpg?size=626&ext=jpg'),
  wordwiddleGame(
      'https://img.freepik.com/free-vector/english-book-illustration-design_23-2149522690.jpg?size=626&ext=jpg&uid=R132188031&semt=ais'),
  wordGame(
      'https://img.freepik.com/premium-photo/dictionary-3d-render-icon-illustration_726846-1551.jpg?size=626&ext=jpg&uid=R132188031&semt=ais'),
  soundGame2(
      'https://img.freepik.com/free-vector/character-playing-videogame-concept_23-2148539624.jpg?size=626&ext=jpg'),
  colorsImg(
      'https://img.freepik.com/free-vector/coloured-paint-stains-collection_1102-67.jpg?semt=sph'),
  numberImg(
      'https://img.freepik.com/free-vector/hand-drawn-mathematical-symbols_23-2148779488.jpg?semt=sph'),
  weathersImg(
      'https://img.freepik.com/free-vector/kawaii-weather-stickers-illustration_52683-66283.jpg?semt=sph'),
  vehiclesImg(
      'https://img.freepik.com/free-vector/isolated-hand-drawn-transport-set-vector-illustration_1284-42907.jpg?semt=sph'),
  schoolStuffImg(
      'https://img.freepik.com/free-vector/watercolor-back-school-elements-collection_52683-86730.jpg?semt=ais'),
  shapesImg(
      'https://img.freepik.com/free-vector/line-style-colorful-basic-geometric-shapes-set-vector_1017-45864.jpg?semt=ais'),
  bodySectionsImg(
      'https://img.freepik.com/premium-vector/my-body_1308-15047.jpg?semt=ais'),

  clothesImg(
      'https://img.freepik.com/free-vector/pack-winter-clothes-essentials_23-2147718643.jpg?semt=sph'),

  fruitsImg(
      'https://img.freepik.com/free-vector/fruits-collection-cartoon-vector-icon-illustration-food-nature-icon-concept-isolated-premium-vector_138676-8350.jpg?semt=sph'),
  vegetablesImg(
      'https://img.freepik.com/free-vector/vegetables-icons-set_1284-21276.jpg?semt=sph'),

  avatar1('https://cdn-icons-png.flaticon.com/128/9043/9043008.png?semt=ais'),
  cupImg('https://cdn-icons-png.flaticon.com/128/3112/3112946.png?semt=ais'),
  signInImg(
      'https://img.freepik.com/free-vector/hand-drawn-english-school-background_23-2149496629.jpg?t=st=1703785329~exp=1703785929~hmac=f822067868a5867e5b9790ab513d7eff5f9c0a52756d17db9a88f0b22fc547e4'),
  soundGame(
      'https://img.freepik.com/free-vector/illustrated-k-pop-music-concept_23-2148633628.jpg?size=626&ext=jpg');

  final String value;

  const ImageConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.network(value);
}
