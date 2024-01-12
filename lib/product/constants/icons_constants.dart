import 'package:flutter/material.dart';

enum IconConstants {
  soundIcon('https://cdn-icons-png.flaticon.com/128/189/189783.png?semt=ais'),
  gamesIcon(
      'https://www.freepik.com/icon/joystick_1978369#fromView=search&term=game+icon&track=ais&page=1&position=80'),
  googleIcon(
      'https://cdn-icons-png.flaticon.com/128/300/300221.png?uid=R132188031&semt=ais'),
  facebookIcon(
      'https://cdn-icons-png.flaticon.com/128/12942/12942327.png?uid=R132188031&semt=ais'),
  emailIcon(
      'https://cdn-icons-png.flaticon.com/128/732/732200.png?uid=R132188031&semt=ais'),
  colorsIcon(
      'https://cdn-icons-png.flaticon.com/128/7101/7101105.png?semt=ais'),

  animalsIcon('https://cdn-icons-png.flaticon.com/128/414/414680.png?semt=ais'),
  fruitsIcon(
      'https://cdn-icons-png.flaticon.com/128/3194/3194591.png?semt=ais'),
  vegetablesIcon(
      'https://cdn-icons-png.flaticon.com/128/6266/6266076.png?semt=ais'),

  weatherIcon('https://cdn-icons-png.flaticon.com/128/648/648198.png?semt=ais'),
  schoolStuffIcon(
      'https://cdn-icons-png.flaticon.com/128/2342/2342063.png?semt=ais'),
  bodySectionItem(
      'https://cdn-icons-png.flaticon.com/128/8567/8567363.png?semt=ais'),
  vehiclesIcon(
      'https://cdn-icons-png.flaticon.com/128/4662/4662012.png?semt=ais'),

  clothesIcon(
      'https://cdn-icons-png.flaticon.com/128/2954/2954918.png?semt=ais'),
  goldMedal('https://cdn-icons-png.flaticon.com/128/3333/3333397.png?semt=ais'),
  silverMedal('https://cdn-icons-png.flaticon.com/128/4844/4844331.png'),
  bronzeMedal('https://cdn-icons-png.flaticon.com/128/6666/6666092.png'),
  shapesIcon(
      'https://cdn-icons-png.flaticon.com/128/8091/8091534.png?semt=ais'),
  numbersIcon('https://cdn-icons-png.flaticon.com/128/709/709388.png'),
  removeIcon(
      'https://cdn-icons-png.flaticon.com/128/7538/7538600.png?uid=R132188031'),

  checkIcon(
      'https://cdn-icons-png.flaticon.com/128/391/391175.png?uid=R132188031'),
  startAgainIcon(
      'https://cdn-icons-png.flaticon.com/128/5469/5469310.png?uid=R132188031&semt=ais'),
  logOutIcon('https://cdn-icons-png.flaticon.com/128/4008/4008990.png'),
  microphoneIcon(
      'https://cdn-icons-png.flaticon.com/128/4596/4596814.png?semt=aiss'),
  ok('https://cdn-icons-png.flaticon.com/128/1721/1721539.png?semt=ais'),
  icon_speaker('https://cdn-icons-png.flaticon.com/128/4859/4859079.png');

  final String value;

  const IconConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.network(value);
}
