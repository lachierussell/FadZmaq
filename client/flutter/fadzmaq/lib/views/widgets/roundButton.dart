import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final double minWidth;
  final double height;
  final double fontSize;
  final Color color;

  RoundButton({
    this.onPressed,
    this.label = "",
    this.minWidth = 150,
    this.height = 40,
    this.fontSize = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: RaisedButton(
          textTheme: ButtonTextTheme.primary,
          child: Text(label, style: TextStyle(fontSize: fontSize)),
          color: color != null ? color : Theme.of(context).accentColor,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(60.0))),
    );
  }
}
