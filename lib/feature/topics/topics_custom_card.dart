import 'package:flutter/material.dart';
import 'package:flutter_application/config.dart';
import 'package:flutter_application/feature/topics/topics_sound_view.dart';
import 'package:flutter_application/product/constants/icons_constants.dart';
import 'package:flutter_application/product/constants/index.dart';
import 'package:kartal/kartal.dart';

class TopicCustomCard extends StatefulWidget {
  const TopicCustomCard(
      {super.key,
      required this.name,
      required this.img,
      required this.gameWidget});
  final String name;
  final Image img;
  final Widget gameWidget;

  @override
  State<TopicCustomCard> createState() => _TopicCustomCardState();
}

class _TopicCustomCardState extends State<TopicCustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget.gameWidget));
          } ??
          () {},
      child: Card(
        color: ColorConstants.darkKnight,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            side: BorderSide()),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 80,
                child: widget.img,
              ),
              const SizedBox(
                width: 50,
              ),
              Text(
                widget.name,
                style: context.general.textTheme.headlineSmall
                    ?.copyWith(color: ColorConstants.cremeDeMenth),
              )
            ],
          ),
        ),
      ),
    );
  }
}
