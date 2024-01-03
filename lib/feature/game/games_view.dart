import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/speaking_game.dart';
import 'package:flutter_application/feature/topics/topics_riddle.dart';
import 'package:flutter_application/feature/topics/topics_sound_view.dart';
import 'package:flutter_application/product/Vocabulary/color_datas.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/widget/cards/custom_games_card.dart';

import '../topics/topics_matching.dart';

class GamesView extends StatefulWidget {
  const GamesView({super.key});

  @override
  State<GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends State<GamesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkKnight,
      body: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         fit: BoxFit.fitHeight,
        //         image: NetworkImage(ImageConstants.backgraund.value))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomGamesCard(
                      text: 'Listening Game',
                      img: ImageConstants.soundGame2.toImg,
                      gamewidget: const TopicsSound()),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomGamesCard(
                      text: 'Word Riddle Game',
                      img: ImageConstants.wordwiddleGame.toImg,
                      gamewidget: const TopicsRiddle())
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomGamesCard(
                      text: 'Speaking Game',
                      img: ImageConstants.speakingGameImg.toImg,
                      gamewidget: PronunciationGame(
                        wordList: Colorr.colors,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomGamesCard(
                      text: 'Word Matching',
                      img: ImageConstants.wordGame.toImg,
                      gamewidget: const TopicsMatching())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
