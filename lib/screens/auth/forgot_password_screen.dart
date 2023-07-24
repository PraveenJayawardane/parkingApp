import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/utils/app_alert.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';
import '../../constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 8,
          ),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Card(
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
                AppHeading(text: 'Forgot password?', fontSize: 26),
                const SizedBox(
                  height: 10,
                ),
                AppLabel(
                    fontSize: 14,
                    textColor: AppColors.appColorGray,
                    text:
                        "Enter your email or phone number to reset the password")
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
                  text: "Enter Your Email",
                  fontSize: 14,
                ),
                AppInputField(
                  formKey: _emailKey,
                  controller: _emailController,
                  inputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Email is Required"),
                  ]),
                  hintText: "eg. praveen@gmail.com",
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomFilledButton(
                    text: "Ok",
                    clickEvent: () {
                   
                      if (_emailKey.currentState!.validate()) {
                        AuthController().forgetPassword(
                            email: _emailController.text, context: context);
                      }
                      // Get.toNamed(Routes.FORGET_PASSWORD_OTP_SCREEN);
                    }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
