import 'package:flutter/material.dart';

enum ImageConstants {
  children('children'),
  welcomeText('welcomeText'),
  ;

  final String value;

  const ImageConstants(this.value);

  String get toPng => 'assets/images/img_$value.png';
  Image get toImg => Image.asset(toPng);
}
