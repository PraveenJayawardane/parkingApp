import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class GhostButton extends StatelessWidget {
  final Function clickEvent;
  final String text;
  final Alignment? alignment;
  Color? color;
  double? textSize;
  TextDecoration? textDecoration;

  GhostButton(
      {Key? key,
      required this.text,
      required this.clickEvent,
      this.color = AppColors.appColorBlack,
      this.textSize = 14.0,
      this.alignment,
      this.textDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(alignment: alignment),
        onPressed: () {
          clickEvent();
        },
        child: Text(
          text,
          style: TextStyle(
              color: color,
              fontSize: textSize,
              decoration: textDecoration,
              fontWeight: FontWeight.w500),
        ));
  }
}
