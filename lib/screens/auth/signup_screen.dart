import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_overlay.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _fNameKey = GlobalKey<FormState>();
  final TextEditingController _fNameController = TextEditingController();

  final GlobalKey<FormState> _lNameKey = GlobalKey<FormState>();
  final TextEditingController _lNameController = TextEditingController();

  final GlobalKey<FormState> _pNoKey = GlobalKey<FormState>();
  final TextEditingController _pNoController = TextEditingController();

  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  var userController = Get.find<UserController>();
  final _selectedCountryCode = '+44'.obs;
  String? phoneNumber;
  String? countryCode;

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppHeading(text: 'Create an account', fontSize: 26),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabel(
                            text: "First name",
                            fontSize: 13,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppInputField(
                            formKey: _fNameKey,
                            controller: _fNameController,
                            inputType: TextInputType.text,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "First name is Required"),
                            ]),
                            hintText: "eg. John",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Last name",
                            fontSize: 14,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppInputField(
                            formKey: _lNameKey,
                            controller: _lNameController,
                            inputType: TextInputType.text,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Last name is Required"),
                            ]),
                            hintText: "eg. Smith",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Email address",
                            fontSize: 14,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppInputField(
                            formKey: _emailKey,
                            controller: _emailController,
                            inputType: TextInputType.text,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Email is Required"),
                              EmailValidator(errorText: "Enter a Valid Email")
                            ]),
                            hintText: "eg. johnsmith@gmail.com",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Create password",
                            fontSize: 14,
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
                              MinLengthValidator(8,
                                  errorText: "Must be at least 8 characters")
                            ]),
                            hintText: "Must be at least 8 characters",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Phone number",
                            fontSize: 14,
                            textColor: AppColors.appColorBlack01,
                          ),
                          Form(
                            key: _phoneNumberKey,
                            child: InternationalPhoneNumberInput(
                              initialValue: PhoneNumber(isoCode: 'GB'),
                              onInputChanged: (value) {
                                print(value.dialCode);
                                phoneNumber = value.phoneNumber;
                                countryCode = value.dialCode;
                              },
                              textFieldController: _pNoController,
                              autoFocusSearch: true,
                              ignoreBlank: true,
                              autoValidateMode: AutovalidateMode.always,
                              inputDecoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(
                                      color: AppColors.appColorLightGray)),
                              inputBorder: InputBorder.none,
                              selectorConfig: const SelectorConfig(
                                  showFlags: false,
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET),
                            ),
                          ),
                          const Divider(
                            height: 1,
                            color: AppColors.appColorBlack,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    spacing: 5, // <-- Spacing between children
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppLabel(
                                            text:
                                                "By signing up, I agree to the ",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppColors.appColorGray,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                  Routes.TERMS_OF_USE_SCREEN);
                                            },
                                            child: const Text(
                                              'Terms and Conditions',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          AppLabel(
                                            text: " and ",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            textColor: AppColors.appColorGray,
                                          ),
                                        ],
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(Routes
                                                    .PRIVACY_POLICY_SCREEN);
                                              },
                                              child: const Text(
                                                ' Privacy Policy.',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w500, // light
                                                  // italic
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const SizedBox(
                            height: 40,
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
                          text: "Create Account",
                          clickEvent: () {
                            if (_isValidate()) {
                              AppOverlay.startOverlay(context);
                              userController.isLoading.value = false;
                              AuthController().emailSignUp(
                                  countryCode: countryCode!,
                                  page: '',
                                  context: context,
                                  firstName: _fNameController.text,
                                  lastName: _lNameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phone: phoneNumber!);
                            }
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                              fontSize: 12,
                              text: 'Already have an account?',
                              textColor: AppColors.appColorGray,
                              fontWeight: FontWeight.w400,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: AppLabel(
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                fontSize: 12,
                                text: ' Sign In',
                              ),
                            )
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
    } else if (!_fNameKey.currentState!.validate()) {
      return false;
    } else if (!_lNameKey.currentState!.validate()) {
      return false;
    } else if (!_phoneNumberKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
