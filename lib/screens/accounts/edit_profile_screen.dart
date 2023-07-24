import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_image_picker.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';

import '../../constants/app_colors.dart';
import '../../controllers/account_controller.dart';
import '../../widgets/atoms/app_label.dart';
import '../../widgets/molecules/buttons/custom_filled_button.dart';
import '../../widgets/molecules/input_fields/app_input_field.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserController userController = Get.find<UserController>();

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
  String mobile = '';

  void getCounteryCode(String countryCode) {
    if (countryCode == '+44') {
      isoCode.value = 'GB';
      _selectedCountryCode.value = '+44';
    }
    if (countryCode == '+94') {
      isoCode.value = 'LK';
      _selectedCountryCode.value = '+94';
    } else {
      isoCode.value = 'GB';
      _selectedCountryCode.value = '+44';
    }
  }

  @override
  void initState() {
    super.initState();
    if (userController.user.value?.countryCode != null) {
      getCounteryCode(userController.user.value!.countryCode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    _fNameController.text = userController.user.value?.firstName ?? '-';
    _lNameController.text = userController.user.value?.lastName ?? '-';
    _emailController.text = userController.user.value?.email ?? '-';
    _pNoController.text = userController.user.value?.countryCode != null
        ? userController.user.value?.mobileNumber
                ?.split(userController.user.value!.countryCode!)[1] ??
            '-'
        : userController.user.value?.mobileNumber?.replaceRange(0, 2, '') ??
            '-';

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
          "Edit Account",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircularProfileAvatar("",
                        cacheImage: true,
                        borderColor: AppColors.appColorLightGray,
                        borderWidth: 6,
                        elevation: 2,
                        radius: 60,
                        child: Obx(
                          () => Stack(
                            children: [
                              CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                                imageUrl:
                                    userController.user.value?.profilePicture ??
                                        '',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.appColorGray,
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(
                                  Icons.error,
                                  color: AppColors.appColorGoogleRed,
                                )),
                              ),
                              Container(
                                color: AppColors.appColorLightGray
                                    .withOpacity(0.5),
                              ),
                              Center(
                                  child: userController.photoLoading.value
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : FaIcon(
                                          Icons.mode_edit,
                                          size: 36,
                                          color: AppColors.appColorWhite
                                              .withOpacity(0.5),
                                        ))
                            ],
                          ),
                        ), onTap: () async {
                      AppImagePicker().pickPhotoFromGallery();
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => AppLabel(
                      text:
                          '${userController.user.value?.firstName ?? '-'} ${userController.user.value?.lastName ?? '-'}',
                      fontSize: 20,
                      textColor: AppColors.appColorBlack01,
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
                          text: "Last name",
                          fontSize: 14,
                          textColor: AppColors.appColorBlack01,
                        ),
                        AppInputField(
                          formKey: _lNameKey,
                          controller: _lNameController,
                          inputType: TextInputType.text,
                          isEnable: true,
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
                          child: Obx(
                            () => InternationalPhoneNumberInput(
                              initialValue: PhoneNumber(isoCode: '$isoCode'),
                              onInputChanged: (value) {
                                phoneNumber = value.phoneNumber;
                                countryCode = value.dialCode;
                              },
                              textFieldController: _pNoController,
                              autoFocusSearch: true,
                              ignoreBlank: true,
                              autoValidateMode: AutovalidateMode.disabled,
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
                        ),
                        const Divider(color: AppColors.appColorGray),
                        const SizedBox(
                          height: 30,
                        ),
                        AppLabel(
                          text: "Change Password",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                          },
                          child: AppInputField(
                            formKey: _passwordKey,
                            controller: _passwordController,
                            inputType: TextInputType.text,
                            isEnable: false,
                            isObscure: true,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Email is Required"),
                              EmailValidator(errorText: "Enter a Valid Email")
                            ]),
                            hintText: "***********",
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: userController.isLoading.value,
              child: Container(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: CustomFilledButton(
                      text: "Save",
                      clickEvent: () {
                        if (_isValidate()) {
                          userController.isLoading.value = false;
                          AppOverlay.startOverlay(context);
                          mobile = '$phoneNumber';
                          AccountController().editAccount(
                              countryCode: countryCode!,
                              email: _emailController.text,
                              firstNAme: _fNameController.text,
                              lastName: _lNameController.text,
                              mobileNumber: mobile);
                        }
                      }),
                ),
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
