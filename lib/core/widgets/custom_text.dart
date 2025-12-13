import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  const CustomText(
      this.text, {
        super.key,
        this.color,
        this.fontSize = 14,
        this.fontWeight = FontWeight.normal,
        this.textOverflow,
        this.maxLines,
        this.textAlign,
        this.height,
        this.decoration,
        this.fontStyle,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
    );
  }
}
