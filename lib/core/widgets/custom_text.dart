import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const CustomText(
      this.text,{
        super.key,
        this.color,
        this.fontSize,
        this.fontWeight = FontWeight.normal,
        this.textOverflow,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: textOverflow,
      ),
    );
  }
}
