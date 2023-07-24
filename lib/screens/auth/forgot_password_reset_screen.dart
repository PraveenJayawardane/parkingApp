import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/auth_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  ForgotPasswordResetScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _confirmPasswordKey = GlobalKey<FormState>();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String userId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 8,
          ),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Card(
              child: Center(
                  child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.appColorBlack,
                size: 16,
              )),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeading(text: 'Reset password', fontSize: 26),
                const SizedBox(
                  height: 10,
                ),
                AppLabel(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.appColorGray,
                    text: "Enter your new password")
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLabel(
                  text: "New password",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack01,
                ),
                AppPasswordField(
                  formKey: _passwordKey,
                  controller: _passwordController,
                  inputType: TextInputType.text,
                  isObscure: true,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Password is Required"),
                  ]),
                  hintText: "Must be at least 8 characters",
                ),
                SizedBox(
                  height: 30,
                ),
                AppLabel(
                  text: "Confirm new password",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack01,
                ),
                AppPasswordField(
                  formKey: _confirmPasswordKey,
                  controller: _confirmPasswordController,
                  inputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Confirm password is Required"),
                  ]),
                  hintText: "Both passwords must match",
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomFilledButton(
                    text: "Reset password",
                    clickEvent: () {
                      if (_isValidate()) {
                        AuthController().updatePassword(
                          password: _confirmPasswordController.text,
                          context: context,
                          userId:userId
                        );
                      }
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool _isValidate() {
    if (_passwordKey.currentState!.validate() &&
        _confirmPasswordKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
