import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/game_example.dart';
import 'package:flutter_application/feature/game/sound_game.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:flutter_application/product/Vocabulary/number_datas.dart';

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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SoundGame(
                                    words: Numbers.numbers,
                                  )));
                    },
                    child: SizedBox(
                        width: 200,
                        height: 250,
                        child: Card(child: ImageConstants.soundGame2.toImg)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                        width: 200,
                        height: 250,
                        child: Card(child: ImageConstants.soundGame.toImg)),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                        width: 200,
                        height: 250,
                        child: Card(child: ImageConstants.iLovePlay.toImg)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GamePage()));
                    },
                    child: SizedBox(
                        width: 200,
                        height: 250,
                        child: Card(child: ImageConstants.wordGame.toImg)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
