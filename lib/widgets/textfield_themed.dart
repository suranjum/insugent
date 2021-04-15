import 'package:flutter/material.dart';

class RSTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType type;
  final bool obscureText;
  final int maxLength;
  final TextCapitalization textCapitalization;

  const RSTextField(
      {Key key,
      this.hint,
      this.controller,
      this.type,
      this.obscureText,
      this.maxLength,
      this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: new TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscureText ?? false,
        maxLength: maxLength ?? TextField.noMaxLength,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        decoration: new InputDecoration(
          labelText: hint,
          hintStyle: TextStyle(color: Colors.black54),
          filled: true,
        ),
      ),
    );
  }
}
