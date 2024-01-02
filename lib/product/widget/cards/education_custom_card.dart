import 'package:flutter/material.dart';
import 'package:flutter_application/feature/education/word_study_page.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:kartal/kartal.dart';

import '../../Vocabulary/color_datas.dart';

class EducationCustomCard extends StatefulWidget {
  const EducationCustomCard(
      {super.key, required this.name, required this.img, required this.words});

  final String name;

  final Image img;
  final List<Word> words;

  @override
  State<EducationCustomCard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EducationCustomCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: InkWell(
        onTap: () {},
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WordStudy(words: widget.words)));
          },
          child: Card(
            elevation: 3,
            color: ColorConstants.actOfWrath,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(height: 150, width: 170, child: widget.img),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(children: [
                    Text(
                      widget.name,
                      style: context.general.textTheme.headlineSmall!
                          .copyWith(color: ColorConstants.white),
                    ),
                    Text(
                      '${widget.words.length}  Word',
                      style: context.general.textTheme.bodySmall
                          ?.copyWith(color: Colors.white),
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
