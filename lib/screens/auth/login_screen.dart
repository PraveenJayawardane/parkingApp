import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/auth_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_email_&_password_field.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      color: AppColors.appColorLightGray,
                      child: Center(
                        child: Image.asset("assets/images/login_bg_img.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppHeading(text: 'Welcome Back!', fontSize: 26),
                          const SizedBox(
                            height: 10,
                          ),
                          AppLabel(
                            text: 'Sign in to your account',
                            fontSize: 16,
                            textColor: AppColors.appColorGray,
                          ),
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
                            text: "Email address or phone number",
                            fontSize: 13,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppEmailPasswordField(
                            formKey: _emailKey,
                            controller: _emailController,
                            inputType: TextInputType.text,
                            hintText: "eg. johnsmith@gmail.com ",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Password",
                            fontSize: 13,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppPasswordField(
                            formKey: _passwordKey,
                            controller: _passwordController,
                            inputType: TextInputType.text,
                            isObscure: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Password is Required"),
                            ]),
                            hintText: "Enter your password",
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GhostButton(
                                    text: "Forgot Password?",
                                    clickEvent: () {
                                      Get.toNamed(
                                          Routes.FORGET_PASSWORD_SCREEN);
                                    })
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: AppColors.appColorWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                  ),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                children: [
                  Obx(
                    () => Visibility(
                      visible: userController.isLoading.value,
                      child: CustomFilledButton(
                          text: "Login",
                          clickEvent: () async {
                            if (_isValidate()) {
                              AppOverlay.startOverlay(context);
                              userController.isLoading.value = false;
                              AuthController().emailSignIn(
                                  page: '',
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          }),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppLabel(
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              text: 'Don’t have an account?',
                              textColor: AppColors.appColorGray,
                            ),
                            GhostButton(
                                text: "Create an account",
                                clickEvent: () {
                                  Get.toNamed(Routes.SIGNUP);
                                }),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidate() {
    if (!_emailKey.currentState!.validate()) {
      return false;
    } else if (!_passwordKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
