import 'package:flutter/material.dart';
import '../../../core/consts/colors.conts.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.hintText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: ColorsConst.primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: ColorsConst.primaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: ColorsConst.primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}