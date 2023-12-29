import 'package:flutter/material.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/constants/image_constants.dart';
import 'package:flutter_application/product/widget/cards/education_custom_card.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkKnight,
      body: ListView(children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              img: ImageConstants.animals.toImg,
              name: 'Animals',
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Colors',
              img: ImageConstants.colorsImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Numbers',
              img: ImageConstants.numberImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Fruits',
              img: ImageConstants.fruitsImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Vegetables',
              img: ImageConstants.vegetablesImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Weather',
              img: ImageConstants.weathersImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Vehicles',
              img: ImageConstants.vehiclesImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Body Section',
              img: ImageConstants.bodySectionsImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Clothes',
              img: ImageConstants.clothesImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'School',
              img: ImageConstants.schoolStuffImg.toImg,
            ),
            EducationCustomCard(
              count: Animals.animals.length,
              name: 'Shapes',
              img: ImageConstants.shapesImg.toImg,
            ),
          ],
        ),
      ]),
    );
  }
}
