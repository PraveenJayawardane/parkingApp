import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';

import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_label.dart';
import '../../widgets/molecules/input_fields/app_password_field.dart';
class ChangePhoneNumberScreen extends StatelessWidget {
  final GlobalKey<FormState> _phoneNoKey = GlobalKey<FormState>();
  final TextEditingController _phoneNoController = TextEditingController();

  ChangePhoneNumberScreen({Key? key}) : super(key: key);

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
            onPressed: () {Get.back();},
          ),
          shape: const Border(
              bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
          title: const Text(
            "FAQs",
            style: TextStyle(
                color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(text: "Phone number",fontSize: 14,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppInputField(
              formKey: _phoneNoKey,
              controller: _phoneNoController,
              inputType: TextInputType.text,
              isObscure: false,
              validator: MultiValidator([
                RequiredValidator(errorText: "Password is Required"),
              ]),

              hintText: "(810) 395-1941",

            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(text: "Save", clickEvent: (){}),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
