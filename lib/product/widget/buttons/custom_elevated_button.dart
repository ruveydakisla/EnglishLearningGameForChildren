import "package:flutter/material.dart";

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton(
      {Key? key, required this.buttonText, required this.onPressed})
      : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffB31312),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.buttonText, // Parametre olarak alınan buttonText'i kullanın
          style: const TextStyle(color: Colors.white, fontSize: 23),
        ),
      ),
    );
  }
}
