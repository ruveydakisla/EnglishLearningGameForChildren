import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/feature/game/games_view.dart';
import 'package:flutter_application/feature/game/sound_game.dart';
import 'package:flutter_application/feature/game/sound_game2.dart';
import 'package:flutter_application/feature/navbar/top_navbar.dart';
import 'package:flutter_application/feature/signIn/signIn.dart';
import 'package:flutter_application/feature/signup/signup_view.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';
import 'package:flutter_application/product/initialize/application_start.dart';
import 'package:flutter_application/product/Vocabulary/number_datas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApplicationStart.init();

  runApp(const ProviderScope(child: MyApp()));
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.martelSansTextTheme(),
        ),
        home: SoundGame(
          words: Animals.animals,
        ));
  }
}
