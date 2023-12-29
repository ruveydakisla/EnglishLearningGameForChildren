import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextInputType? type;
  final bool? obsecure;
  final TextInputAction? action;
  final TextEditingController controller;
  const CustomTextField(
      {Key? key,
      required this.labelText,
      required this.controller,
      this.type,
      this.obsecure,
      this.action})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obsecure ?? false,
      keyboardType: widget.type,
      controller: widget.controller,
      textInputAction: widget.action,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
