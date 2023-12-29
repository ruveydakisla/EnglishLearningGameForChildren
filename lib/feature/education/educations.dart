import 'package:flutter/material.dart';
import 'package:flutter_application/product/widget/cards/education_custom_card.dart';

class Education extends StatefulWidget {
  const Education({super.key});

  @override
  State<Education> createState() => _EducationState();
}

class _EducationState extends State<Education> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [EducationCustomCard()],
      ),
    );
  }
}
