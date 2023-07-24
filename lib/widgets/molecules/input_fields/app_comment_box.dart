import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../constants/app_colors.dart';

class AppCommentBox extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final TextInputType inputType;
  final MultiValidator validator;
  final String hintText;
  Color? hintColor;
  Color? bgColor;
  bool? isObscure;
  bool? isEnable;
  int? minLine;
  int? maxLine;

  AppCommentBox({
    Key? key,
    required this.formKey,
    required this.controller,
    required this.inputType,
    required this.validator,
    this.hintColor = AppColors.appColorLightGray,
    this.bgColor = AppColors.appColorLightGray,
    required this.hintText,
    this.isObscure = false,
    this.isEnable = true,
    this.minLine,
    this.maxLine = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
          controller: controller,
          textAlign: TextAlign.left,
          style: const TextStyle(color: AppColors.appColorBlack, fontSize: 14),
          keyboardType: inputType,
          obscureText: isObscure!,
          enabled: isEnable,
          minLines: minLine,
          maxLines: maxLine,
          decoration: InputDecoration(
              filled: true,
              fillColor: bgColor,
              hintStyle: TextStyle(color: hintColor, fontSize: 14),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              )),
          validator: validator),
    );
  }
}
