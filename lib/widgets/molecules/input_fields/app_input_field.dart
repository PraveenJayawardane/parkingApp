import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../constants/app_colors.dart';

class AppInputField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final TextInputType inputType;
  final MultiValidator validator;
  final String hintText;
  Color? hintColor;
  bool? isObscure;
  bool? isEnable;
  int? minLine;
  int? maxLine;
  bool? showBorder;
  TextCapitalization? textCapitalization;

  AppInputField(
      {Key? key,
      required this.formKey,
      required this.controller,
      required this.inputType,
      required this.validator,
      this.hintColor = AppColors.appColorLightGray,
      required this.hintText,
      this.isObscure = false,
      this.isEnable = true,
      this.showBorder,
      this.minLine,
      this.textCapitalization,
      this.maxLine = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
          controller: controller,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          textAlign: TextAlign.left,
          style: const TextStyle(color: AppColors.appColorGray, fontSize: 14),
          keyboardType: inputType,
          obscureText: isObscure!,
          enabled: isEnable,
          minLines: minLine,
          maxLines: maxLine,
          decoration: InputDecoration(
            border: showBorder ?? true ? null : InputBorder.none,
            focusColor: AppColors.appColorWhiteGray,
            hintStyle: TextStyle(color: hintColor, fontSize: 14),
            hintText: hintText,
          ),
          validator: validator),
    );
  }
}
