import 'package:flutter/material.dart';
import 'package:flutter_application/feature/avatar_choose_page.dart/avatar_chose.dart';
import 'package:flutter_application/feature/education/word_study_page.dart';
import 'package:flutter_application/feature/signup_form/signup_form_view.dart';
import 'package:flutter_application/product/Vocabulary/animals_datas.dart';
import 'package:flutter_application/product/initialize/application_start.dart';
import 'package:flutter_application/product/widget/cards/education_custom_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feature/navbar/top_navbar.dart';

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
        home: const SignupFormView());
  }
}
