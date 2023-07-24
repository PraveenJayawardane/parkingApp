import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/auth_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import '../../constants/app_colors.dart';
import '../../controllers/account_controller.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _currentPasswordKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _newPasswordKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _confirmPasswordKey = GlobalKey<FormState>();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Change Password",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLabel(
                  text: "Current password",
                  fontSize: 14,
                ),
                AppPasswordField(
                  formKey: _currentPasswordKey,
                  controller: _currentPasswordController,
                  inputType: TextInputType.text,
                  isObscure: true,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Password is Required"),
                  ]),
                  hintText: "Enter your password",
                ),
                const SizedBox(
                  height: 30,
                ),
                AppLabel(
                  text: "New password",
                  fontSize: 14,
                ),
                AppPasswordField(
                  formKey: _newPasswordKey,
                  controller: _newPasswordController,
                  inputType: TextInputType.text,
                  isObscure: true,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Confirm password is Required"),
                  ]),
                  hintText: "password must have minimum 8 characters",
                ),
                SizedBox(
                  height: 30,
                ),
                AppLabel(
                  text: "Confirm password",
                  fontSize: 14,
                ),
                AppPasswordField(
                  formKey: _confirmPasswordKey,
                  controller: _confirmPasswordController,
                  inputType: TextInputType.text,
                  isObscure: true,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: "Confirm password is Required"),
                  ]),
                  hintText: "Both passwords must match",
                ),
                const SizedBox(
                  height: 50,
                ),
                Obx(
                  () => Visibility(
                    visible: userController.isLoading.value,
                    child: CustomFilledButton(
                        text: "Save",
                        clickEvent: () {
                          if (_isValidate()) {
                            if (_isFieldValidate()) {
                              AppOverlay.startOverlay(context);
                              userController.isLoading.value = false;
                              AccountController().changePassword(
                                  _currentPasswordController.text,
                                  _confirmPasswordController.text);
                            } else {
                              AppCustomToast.warningToast(
                                  'Password does not match');
                            }
                          }
                        }),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool _isValidate() {
    if (!_currentPasswordKey.currentState!.validate()) {
      return false;
    } else if (!_confirmPasswordKey.currentState!.validate()) {
      return false;
    } else if (!_newPasswordKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }

  bool _isFieldValidate() {
    if (_confirmPasswordController.text != _newPasswordController.text ||
        _confirmPasswordController.text == _currentPasswordController.text ||
        _currentPasswordController.text == _newPasswordController.text) {
      return false;
    } else {
      return true;
    }
  }
}
