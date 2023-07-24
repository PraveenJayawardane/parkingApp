import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

import '../../constants/app_colors.dart';
import '../../widgets/molecules/input_fields/app_comment_box.dart';
import '../../widgets/molecules/input_fields/app_input_field.dart';

class TouchWithUsScreen extends StatelessWidget {
  final GlobalKey<FormState> _commentKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  var accountController = Get.put(AccountController());

  TouchWithUsScreen({Key? key}) : super(key: key);

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

  final _selectedCountryCode = '+44'.obs;
  String? phoneNumber;
  String? countryCode;
  final isoCode = 'GB'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
        title: const Text(
          "Get in touch with us",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
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
                            fontSize: 14,
                            textColor: AppColors.appColorBlack01,
                          ),
                          AppInputField(
                            formKey: _fNameKey,
                            controller: _fNameController,
                            inputType: TextInputType.text,
                            isEnable: true,
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
                            text: "Email address",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          AppInputField(
                            formKey: _emailKey,
                            controller: _emailController,
                            inputType: TextInputType.text,
                            isEnable: true,
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
                            text: "Phone number",
                            fontSize: 14,
                            textColor: AppColors.appColorBlack01,
                          ),
                          Form(
                            key: _phoneNumberKey,
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (value) {
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
                                  showFlags: true,
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET),
                            ),
                          ),
                          const Divider(color: AppColors.appColorGray),
                          const SizedBox(
                            height: 30,
                          ),
                          AppLabel(
                            text: "Type your Message",
                            textColor: AppColors.appColorBlack01,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AppCommentBox(
                              formKey: _commentKey,
                              controller: _commentController,
                              inputType: TextInputType.text,
                              bgColor:
                                  AppColors.appColorLightGray.withOpacity(0.2),
                              maxLine: 5,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Please enter something")
                              ]),
                              hintText: ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
              child: CustomFilledButton(
                  text: "Submit",
                  clickEvent: () {
                    if (_isValidate()) {
                      accountController.sendMessagetoMail(
                          lastName: '',
                          email: _emailController.text,
                          firstName: _fNameController.text,
                          phoneNumber: phoneNumber!,
                          message: _commentController.text,
                          context: context);
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidate() {
    if (!_emailKey.currentState!.validate()) {
      return false;
    } else if (!_fNameKey.currentState!.validate()) {
      return false;
    } else if (!_commentKey.currentState!.validate()) {
      return false;
    } else if (!_phoneNumberKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
