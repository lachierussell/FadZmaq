import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final double minWidth;
  final double height;
  final double fontSize;
  final Color color;
   final Color textColor;
   final ButtonTextTheme buttonTextTheme;

  RoundButton({
    this.onPressed,
    this.label = "",
    this.minWidth = 150,
    this.height = 40,
    this.fontSize = 16,
    this.color,
    this.textColor,
    this.buttonTextTheme = ButtonTextTheme.primary,

  });

  @override
  Widget build(BuildContext context) {


    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: RaisedButton(
        disabledColor: Colors.grey,
          textTheme: buttonTextTheme,
          textColor: textColor,
          child: Text(label, style: TextStyle(fontSize: fontSize)),
          color: color,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20))),
    );
  }
}
