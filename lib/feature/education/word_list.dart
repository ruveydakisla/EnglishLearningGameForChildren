import 'package:flutter/material.dart';
import 'package:flutter_application/product/Vocabulary/index.dart';
import '../../product/constants/index.dart';

class StudyTopics {
  final String name;
  final Image img;
  final List<Word> wordList;

  StudyTopics({required this.name, required this.img, required this.wordList});

  static List<StudyTopics> studyTopics = [
    StudyTopics(
        name: 'Animals',
        img: ImageConstants.animals.toImg,
        wordList: Animals.animals),
    StudyTopics(
        name: 'Colors',
        img: ImageConstants.colorsImg.toImg,
        wordList: Colorr.colors),
    StudyTopics(
        name: 'Numbers',
        img: ImageConstants.numberImg.toImg,
        wordList: Numbers.numbers),
    StudyTopics(
        name: 'Fruits',
        img: ImageConstants.fruitsImg.toImg,
        wordList: Fruits.fruits),
    StudyTopics(
        name: 'Vegetables',
        img: ImageConstants.vegetablesImg.toImg,
        wordList: Vegetables.vegetables),
    StudyTopics(
        name: 'Weather',
        img: ImageConstants.weathersImg.toImg,
        wordList: Weather.weathers),
    StudyTopics(
        name: 'Vehicles',
        img: ImageConstants.vehiclesImg.toImg,
        wordList: Vehicle.vehicles),
    StudyTopics(
        name: 'Body Section',
        img: ImageConstants.bodySectionsImg.toImg,
        wordList: BodySection.sections),
    StudyTopics(
        name: 'Clothes',
        img: ImageConstants.clothesImg.toImg,
        wordList: Clothes.clothes),
    StudyTopics(
        name: 'School Stuff',
        img: ImageConstants.schoolStuffImg.toImg,
        wordList: SchoolStuff.stuffs),
    StudyTopics(
        name: 'Shapes',
        img: ImageConstants.shapesImg.toImg,
        wordList: Shapes.shapes),
  ];
}
