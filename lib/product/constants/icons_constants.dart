import 'package:flutter/material.dart';

enum IconConstants {
  number_one(
      'https://cdn-icons-png.flaticon.com/128/3499/3499632.png?semt=ais'),
  number_two(
      'https://cdn-icons-png.flaticon.com/128/3499/3499634.png?semt=ais'),
  number_three(
      'https://cdn-icons-png.flaticon.com/128/3499/3499637.png?semt=ais'),
  number_four(
      'https://cdn-icons-png.flaticon.com/128/6287/6287086.png?semt=ais'),
  number_five(
      'https://cdn-icons-png.flaticon.com/128/3479/3479604.png?semt=ais'),
  number_six(
      'https://cdn-icons-png.flaticon.com/128/6287/6287083.png?semt=ais'),
  number_seven(
      'https://cdn-icons-png.flaticon.com/128/6287/6287051.png?semt=ais'),
  number_eight(
      'https://cdn-icons-png.flaticon.com/128/1474/1474576.png?semt=ais'),
  number_nine(
      'https://cdn-icons-png.flaticon.com/128/3554/3554338.png?semt=ais'),
  gamesIcon(
      'https://www.freepik.com/icon/joystick_1978369#fromView=search&term=game+icon&track=ais&page=1&position=80'),
  googleIcon(
      'https://cdn-icons-png.flaticon.com/128/300/300221.png?uid=R132188031&semt=ais'),
  facebookIcon(
      'https://cdn-icons-png.flaticon.com/128/12942/12942327.png?uid=R132188031&semt=ais'),
  emailIcon(
      'https://cdn-icons-png.flaticon.com/128/732/732200.png?uid=R132188031&semt=ais'),
  icon_speaker('https://cdn-icons-png.flaticon.com/128/4859/4859079.png');

  final String value;

  const IconConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.network(value);
}
