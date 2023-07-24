import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';
import '../../widgets/molecules/buttons/bordered_button.dart';
import '../../widgets/molecules/buttons/bordered_icon_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  OTPVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {

  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0,top: 8,),
            child: Card(

              child: Center(child: Icon(Icons.arrow_back_ios,color: AppColors.appColorBlack,size: 16,)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0,top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeading(
                    text: 'OTP Verification', fontSize: 26),
                const SizedBox(
                  height: 10,
                ),
                AppLabel(
                    fontSize: 14,
                    textColor: AppColors.appColorLightGray,
                    text: "We will send you an One Time Password to this mobile number")
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
                AppLabel(text: "Enter Mobile Number",fontSize: 14,),
                AppInputField(
                  formKey: _emailKey,
                  controller: _emailController,
                  inputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Phone number is Required"),
                  ]),
                  hintText: "eg. +447900000000",

                ),


                const SizedBox(
                  height: 50,
                ),

                CustomFilledButton(text: "Get OTP", clickEvent: (){}),

              ],
            ),
          ),
        ]),
      ),
    );
  }
}
