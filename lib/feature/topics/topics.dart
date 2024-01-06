import 'package:flutter/material.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';
import 'package:flutter_application/product/Vocabulary/body_section_datas.dart';
import 'package:flutter_application/product/Vocabulary/clothes_datas.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'package:flutter_application/product/Vocabulary/fruits_datas.dart';
import 'package:flutter_application/product/Vocabulary/numbers_datas.dart';
import 'package:flutter_application/product/Vocabulary/school_stuff_datas.dart';
import 'package:flutter_application/product/Vocabulary/shapes_datas.dart';
import 'package:flutter_application/product/Vocabulary/vegetables.dart';
import 'package:flutter_application/product/Vocabulary/vehicle_datas.dart';
import 'package:flutter_application/product/Vocabulary/weather_datas.dart';
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
        wordList: Numbers.numbers),
    Topic(
        name: 'Fruits',
        icon: IconConstants.fruitsIcon.toImg,
        wordList: Fruits.fruits),
    Topic(
        name: 'Vegetables',
        icon: IconConstants.vegetablesIcon.toImg,
        wordList: Vegetables.vegetables),
    Topic(
        name: 'Weather',
        icon: IconConstants.weatherIcon.toImg,
        wordList: Weather.weathers),
    Topic(
        name: 'Vehicles',
        icon: IconConstants.vehiclesIcon.toImg,
        wordList: Vehicle.vehicles),
    Topic(
        name: 'Body Sections',
        icon: IconConstants.bodySectionItem.toImg,
        wordList: BodySection.sections),
    Topic(
        name: 'Clothes',
        icon: IconConstants.clothesIcon.toImg,
        wordList: Clothes.clothes),
    Topic(
        name: 'School Stuff',
        icon: IconConstants.schoolStuffIcon.toImg,
        wordList: SchoolStuff.stuffs),
    Topic(
      name: 'Shapes',
      icon: IconConstants.shapesIcon.toImg,
      wordList: Shapes.shapes,
    )
  ];
}
