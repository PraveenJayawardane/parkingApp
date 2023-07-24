import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';


bool isEmail(String input) =>
    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input);

bool isPhone(String input) =>
    RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(input);

class AppEmailPasswordField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final TextInputType inputType;
  final String hintText;
  Color? hintColor;
  bool? isObscure;
  bool? isEnable;
  int? minLine;
  int? maxLine;

  AppEmailPasswordField(
      {Key? key,
      required this.formKey,
      required this.controller,
      required this.inputType,
      this.hintColor = AppColors.appColorLightGray,
      required this.hintText,
      this.isObscure = false,
      this.isEnable = true,
      this.minLine,
      this.maxLine = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.left,
        style: const TextStyle(color: AppColors.appColorGray, fontSize: 14),
        keyboardType: inputType,
        obscureText: isObscure!,
        enabled: isEnable,
        minLines: minLine,
        maxLines: maxLine,
        decoration: InputDecoration(
          focusColor: AppColors.appColorWhiteGray,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          hintText: hintText,
        ),
        validator: (value) {
          if (!isEmail(value!) && !isPhone(value)) {
            return 'Please enter a valid email or phone number.';
          }
          return null;
        },
      ),
    );
  }
}
