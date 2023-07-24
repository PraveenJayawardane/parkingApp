

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class AppHeading extends StatelessWidget {
  final String text;
  Color color;
  FontWeight fontWeight;
  double fontSize;

  AppHeading(
      {Key? key,
      required this.text,
      this.color = AppColors.appColorBlack,
      this.fontWeight = FontWeight.w600,
      this.fontSize = 20.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize,overflow: TextOverflow.ellipsis),
    );
  }
}
