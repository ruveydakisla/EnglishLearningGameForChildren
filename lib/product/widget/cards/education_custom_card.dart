import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/index.dart';

class EducationCustomCard extends StatefulWidget {
  const EducationCustomCard({super.key});

  @override
  State<EducationCustomCard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EducationCustomCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        child: Row(
          children: [
            SizedBox(width: 150, child: ImageConstants.animals.toImg),
            const SizedBox(
              width: 50,
            ),
            const Column(children: [Text('data')])
          ],
        ),
      ),
    );
  }
}
