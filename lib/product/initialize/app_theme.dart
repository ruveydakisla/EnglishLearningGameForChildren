import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme(this.context);
  final BuildContext context;

  ThemeData get theme => ThemeData.light().copyWith(

      //theme kodlarımızı buraya yazıyoruz.
      );
}
