import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class BorderedButton extends StatelessWidget {
  final String text;
  final Function clickEvent;
  Color? borderColor;
  Color? textColor;
  double? height;
  double? width;
  double? radius;
  double? fontSize;

  BorderedButton(
      {Key? key,
      required this.text,
      required this.clickEvent,
      this.borderColor = AppColors.appColorBlack,
      this.textColor = AppColors.appColorBlack,
      this.height = 50.0,
      this.width,
      this.radius = 6.0,
      this.fontSize = 14.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    width ??= MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
          child: Text(text, style: TextStyle(fontSize: fontSize)),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(textColor!),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius!),
                      side: BorderSide(color: borderColor!)))),
          onPressed: () {
            clickEvent();
          }),
    );
  }
}
