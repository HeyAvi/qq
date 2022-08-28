import 'package:flutter/material.dart';

class TextWithUnderline extends StatelessWidget {
  final String text;
  final double? lineHeight;
  final double? underlineHeight;

  final Color? borderColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const TextWithUnderline(
      {Key? key,
      required this.text,
      this.textColor,
      this.borderColor,
      this.lineHeight,
      this.underlineHeight,
      this.fontWeight,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: lineHeight ?? 3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? Colors.white,
            width: underlineHeight ?? 1.0,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          color: textColor ?? Colors.white,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      ),
    );
  }
}
