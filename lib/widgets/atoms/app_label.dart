import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
class AppLabel extends StatelessWidget {
  final String text;
  Color? textColor;
  FontWeight? fontWeight;
  double fontSize;
  TextOverflow? textOverflow;
  FontStyle? fontStyle;
  TextAlign? textAlign;


  AppLabel(
      {Key? key,
      required this.text,
      this.textColor = AppColors.appColorBlack,
      this.fontSize = 16.0,
        this.fontStyle,
        this.textAlign,
        this.textOverflow,
      this.fontWeight = FontWeight.w500})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        color: textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontStyle: fontStyle,

      ),
    );
  }
}
