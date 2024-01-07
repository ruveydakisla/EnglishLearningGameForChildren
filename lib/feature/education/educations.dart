import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/widget/cards/education_custom_card.dart';
import 'word_list.dart';

class Education extends StatefulWidget {
  const Education({Key? key}) : super(key: key);

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkKnight,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          for (var item in StudyTopics.studyTopics)
            EducationCustomCard(
              name: item.name,
              img: item.img,
              words: item.wordList,
            )
        ]),
      ),
    );
  }
}
