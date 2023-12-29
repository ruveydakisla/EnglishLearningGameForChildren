import 'package:flutter/material.dart';
import 'package:flutter_application/product/constants/color_constants.dart';

class CustomGamesCard extends StatefulWidget {
  const CustomGamesCard({
    Key? key,
    required this.img,
    required this.gamewidget,
    required this.text,
  }) : super(key: key);

  final Image img;
  final Widget gamewidget;
  final String text; // Eklenen metin

  @override
  State<CustomGamesCard> createState() => _CustomGamesCardState();
}

class _CustomGamesCardState extends State<CustomGamesCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.gamewidget),
        );
      },
      child: SizedBox(
        width: 200,
        height: 270,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: ColorConstants.white, width: 3)),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 185, child: widget.img), // Resim
              const SizedBox(height: 10), // İstenilen boşluk
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
