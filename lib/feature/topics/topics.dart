import 'package:flutter/material.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';

class Topic {
  final String name;
  final Image icon;
  final List<Word>? wordList;
  final Widget? game;

  Topic({required this.name, required this.icon, this.wordList, this.game});

  static List<Topic> topics = [
    Topic(
        name: 'Animals',
        icon: IconConstants.animalsIcon.toImg,
        wordList: Animals.animals),
    Topic(
        name: 'Colors',
        icon: IconConstants.colorsIcon.toImg,
        wordList: Colorr.colors),
    Topic(
      name: 'Numbers',
      icon: IconConstants.numbersIcon.toImg,
    ),
    Topic(name: 'Fruits', icon: IconConstants.fruitsIcon.toImg),
    Topic(name: 'Vegetables', icon: IconConstants.vegetablesIcon.toImg),
    Topic(name: 'Weather', icon: IconConstants.weatherIcon.toImg),
    Topic(name: 'Vehicles', icon: IconConstants.vehiclesIcon.toImg),
    Topic(name: 'Body Sections', icon: IconConstants.bodySectionItem.toImg),
    Topic(name: 'Clothes', icon: IconConstants.clothesIcon.toImg),
    Topic(name: 'School Stuff', icon: IconConstants.schoolStuffIcon.toImg),
    Topic(name: 'Shapes', icon: IconConstants.shapesIcon.toImg)
  ];
}
