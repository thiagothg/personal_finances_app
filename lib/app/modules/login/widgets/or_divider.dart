import 'package:flutter/material.dart';


class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: _size.height * 0.02),
      width: _size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(context),
        ],
      ),
    );
  }

  Expanded buildDivider(BuildContext context) {
    return Expanded(
      child: Divider(
        color: Theme.of(context).primaryColor,
        height: 1.5,
      ),
    );
  }
}