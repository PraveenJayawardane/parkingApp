import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_password_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';
import '../../widgets/molecules/buttons/bordered_button.dart';
import '../../widgets/molecules/buttons/bordered_icon_button.dart';

class OTPPinVerificationScreen extends StatefulWidget {
  OTPPinVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OTPPinVerificationScreen> createState() => _OTPPinVerificationScreenState();
}

class _OTPPinVerificationScreenState extends State<OTPPinVerificationScreen> {

  final GlobalKey<FormState> _pinKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }


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
                    text: "Enter the 4 digit code has been sent to +9471****441")
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

                Form(
                  key: _pinKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: AppColors.appColorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: true,
                        cursorHeight: 20,
                        cursorWidth: 1,
                        blinkWhenObscuring: false,
                        animationType: AnimationType.fade,
                        obscuringWidget: Icon(Icons.circle,size: 12,),
                        mainAxisAlignment: MainAxisAlignment.center,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 40,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          inactiveColor: AppColors.appColorLightGray,
                          activeColor: AppColors.appColorBlack,
                          selectedColor: AppColors.appColorBlack,
                            fieldOuterPadding: const EdgeInsets.only(right: 20)

                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        errorAnimationController: errorController,
                        controller: _pinController,
                        keyboardType: TextInputType.number,

                        onCompleted: (v) {
                          debugPrint("Completed");
                        },

                        onChanged: (value) {
                          debugPrint(value);
                          setState(() {
                            //currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          debugPrint("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),


                const SizedBox(
                  height: 50,
                ),

                CustomFilledButton(text: "Verify and Proceed", clickEvent: (){}),

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
                                fontSize: 14,
                                text: 'Don’t you receive any code?',),

                              AppLabel( 
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                text: ' Re-send code',)
                            ],
                          )),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ]),
      ),
    );
  }
}
