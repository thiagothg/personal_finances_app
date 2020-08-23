import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  CustomTextField({this.hint, this.prefix, this.suffix, this.obscure = false,
    this.textInputType, this.onChanged, this.enabled, this.controller
  });

  final TextEditingController controller;
  final String hint;
  final Widget prefix;
  final Widget suffix;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: _size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(29),
      ),
      padding: prefix != null 
        ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        : const EdgeInsets.only(left: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: textInputType,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: prefix,
          suffixIcon: suffix,
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
