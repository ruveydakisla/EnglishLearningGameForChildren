import 'package:flutter/material.dart';
import 'package:flutter_application/product/Vocabulary/number_datas.dart';

class CustomCard extends StatelessWidget {
  final Word word;
  final Function() onTap;
  final bool isVisible;

  const CustomCard({
    Key? key,
    required this.word,
    required this.onTap,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shadowColor: Colors.yellow,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isVisible ? Colors.white : Colors.yellow,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: SizedBox(
          height: 80,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isVisible
                  ? Column(
                      children: [
                        word.url.isNotEmpty
                            ? Image.network(word.url, height: 40)
                            : Container(),
                        const SizedBox(height: 5),
                        Text(
                          word.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
