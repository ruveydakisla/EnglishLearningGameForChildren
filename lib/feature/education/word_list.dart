import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/image_constants.dart';

import '../../product/Vocabulary/animals_datas.dart';
import '../../product/Vocabulary/color_datas.dart';

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
        wordList: Colorr.colors)
  ];
}
