import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/sound_game.dart';
import 'package:flutter_application/feature/topics/topics.dart';
import 'package:flutter_application/product/widget/cards/index.dart';
import 'package:flutter_application/product/constants/index.dart';

class TopicsSound extends StatefulWidget {
  const TopicsSound({super.key});

  @override
  State<TopicsSound> createState() => _TopicsState();
}

class _TopicsState extends State<TopicsSound> {
  final List<Topic> topics = Topic.topics;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.cremeDeMenth,
      appBar: AppBar(
        backgroundColor: ColorConstants.actOfWrath,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Column(
            children: [
              TopicCustomCard(
                  name: topics[0].name,
                  img: topics[0].icon,
                  gameWidget: SoundGame(
                    words: topics[0].wordList,
                  )),
              TopicCustomCard(
                  name: topics[1].name,
                  img: topics[1].icon,
                  gameWidget: SoundGame(
                    words: topics[1].wordList,
                  )),
              TopicCustomCard(
                  name: topics[2].name,
                  img: topics[2].icon,
                  gameWidget: SoundGame(
                    words: topics[2].wordList,
                  )),
              TopicCustomCard(
                name: topics[3].name,
                img: topics[3].icon,
                gameWidget: SoundGame(words: topics[3].wordList),
              ),
              TopicCustomCard(
                  name: topics[4].name,
                  img: topics[4].icon,
                  gameWidget: SoundGame(words: topics[4].wordList)),
              TopicCustomCard(
                  name: topics[5].name,
                  img: topics[5].icon,
                  gameWidget: SoundGame(words: topics[5].wordList)),
              TopicCustomCard(
                  name: topics[6].name,
                  img: topics[6].icon,
                  gameWidget: SoundGame(words: topics[6].wordList)),
              TopicCustomCard(
                  name: topics[7].name,
                  img: topics[7].icon,
                  gameWidget: SoundGame(words: topics[7].wordList)),
              TopicCustomCard(
                  name: topics[8].name,
                  img: topics[8].icon,
                  gameWidget: SoundGame(words: topics[8].wordList)),
              TopicCustomCard(
                  name: topics[9].name,
                  img: topics[9].icon,
                  gameWidget: SoundGame(words: topics[9].wordList)),
              TopicCustomCard(
                  name: topics[10].name,
                  img: topics[10].icon,
                  gameWidget: SoundGame(words: topics[10].wordList)),
            ],
          ),
        ]),
      ),
    );
  }
}
