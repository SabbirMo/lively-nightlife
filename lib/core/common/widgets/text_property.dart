import 'package:flutter/material.dart';

class TextProperty extends StatelessWidget {
  final bool? softWrap;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle? fontStyle;
  final double? lineHeight;
  final String? fontFamily;

  const TextProperty({
    this.softWrap,
    super.key,
    this.maxLines,
    this.overflow,
    this.textAlign,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    this.lineHeight,
    this.fontFamily,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: softWrap,
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        height: lineHeight,
        fontFamily: fontFamily ?? 'Poppins',
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
    );
  }
}
