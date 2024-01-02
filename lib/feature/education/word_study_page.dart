import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/color_constants.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/image_constants.dart';
import 'package:flutter_application/product/services/sound_service.dart';

import '../../product/Vocabulary/color_datas.dart';

class WordStudy extends StatefulWidget {
  const WordStudy({Key? key, required this.words}) : super(key: key);
  final List<Word> words;

  @override
  State<WordStudy> createState() => _WordStudyDartState();
}

class _WordStudyDartState extends State<WordStudy> {
  final int cardsPerRow = 2; // İstediğiniz sıradaki kart sayısı

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.cremeDeMenth,
      ),
      backgroundColor: ColorConstants.cremeDeMenth,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(
                (widget.words.length / cardsPerRow).ceil(),
                (rowIndex) {
                  int startIndex = rowIndex * cardsPerRow;
                  int endIndex = (rowIndex + 1) * cardsPerRow;
                  endIndex = endIndex > widget.words.length
                      ? widget.words.length
                      : endIndex;

                  return Row(
                    children:
                        widget.words.sublist(startIndex, endIndex).map((word) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: ColorConstants.darkKnight,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(word.name),
                                            SizedBox(
                                              width: _PageSizes._sizedBoxWidth,
                                              child: IconButton(
                                                  onPressed: () {
                                                    SoundService()
                                                        .play(word.name);
                                                  },
                                                  icon: IconConstants
                                                      .soundIcon.toImg),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  word.url,
                                  height: _PageSizes._imgHeight,
                                  width: _PageSizes._imgWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSizes {
  static const double _imgHeight = 80;
  static const double _imgWidth = 80;
  static const double _sizedBoxWidth = 50;
}
