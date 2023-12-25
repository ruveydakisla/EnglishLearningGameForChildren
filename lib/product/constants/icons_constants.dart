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
  icon_speaker('https://cdn-icons-png.flaticon.com/128/4859/4859079.png');

  final String value;

  const IconConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.network(value);
}
