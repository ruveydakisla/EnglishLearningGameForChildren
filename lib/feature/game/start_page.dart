import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/matching_game.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MatchingGame(vocabulary: Animals.animals),
              ),
            );
          },
          child: const Text('Oyunu Başlat'),
        ),
      ),
    );
  }
}
