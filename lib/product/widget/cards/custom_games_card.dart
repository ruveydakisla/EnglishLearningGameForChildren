import 'package:flutter/material.dart';

class CustomGamesCard extends StatefulWidget {
  const CustomGamesCard(
      {super.key, required this.img, required this.gamewidget});
  final Image img;
  final Widget gamewidget;

  @override
  State<CustomGamesCard> createState() => _CustomGamesCardState();
}

class _CustomGamesCardState extends State<CustomGamesCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => widget.gamewidget));
      },
      child: SizedBox(width: 200, height: 250, child: Card(child: widget.img)),
    );
  }
}
