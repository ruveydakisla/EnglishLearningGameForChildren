import 'package:flutter/material.dart';

class CustomSoundGameCard extends StatefulWidget {
  const CustomSoundGameCard(
      {Key? key, required this.img, this.onTap, this.size})
      : super(key: key);
  final Image img;
  final VoidCallback? onTap;
  final double? size;

  @override
  State<CustomSoundGameCard> createState() => _CustomSoundGameCardState();
}

class _CustomSoundGameCardState extends State<CustomSoundGameCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () {},
      child: SizedBox(
        width: widget.size ?? 100,
        height: widget.size ?? 100,
        child: Card(
          child: Stack(
            children: [
              widget.img,
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor:
                        Colors.transparent, // Tıklama efekti arka plan rengi
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: widget.onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
