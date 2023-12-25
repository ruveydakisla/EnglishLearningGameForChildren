import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/services/sound_service.dart';
import 'package:flutter_application/product/widget/cards/custom_sound_game_card.dart';
import 'package:kartal/kartal.dart';

class SoundGame extends StatefulWidget {
  const SoundGame({super.key});

  @override
  State<SoundGame> createState() => _SoundGameState();
}

class _SoundGameState extends State<SoundGame> {
  final player = AudioPlayer();

  int result = 0;
  int counter = 0;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          centerTitle: true,
          backgroundColor: ColorConstants.sunny,
          title: const Text('Numbers'),
          shape: const RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Color(0xff711DB0)),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
          )),
      backgroundColor: ColorConstants.cherryPearl,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please choose correct Image',
              style: context.general.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
                width: 200,
                height: 200,
                child: ElevatedButton(
                    onPressed: () {
                      SoundService().play('seven');
                    },
                    child: IconConstants.icon_speaker.toImg)),
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                CustomSoundGameCard(
                  img: IconConstants.number_one.toImg,
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_five.toImg,
                ),
                CustomSoundGameCard(
                  img: IconConstants.number_four.toImg,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void start() {
    SoundService().play('seven');
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        counter++;
      });
    });
  }
}
