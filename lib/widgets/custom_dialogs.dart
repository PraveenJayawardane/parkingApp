import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class CustomDialogBox {

  static buildEasyLoading(){
    EasyLoading.show(status: "Please Wait");
  }

  static dismissEasyLoading(){
    EasyLoading.dismiss();
  }

  static buildConfirmOrCancelDialog(
      {
        String title = "Alert",
        required String description,
        String confirmText = "Ok",
        String cancelText = "Cancel",
        Widget? content,
        required Function confirmEvent
      }) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      title: title,
      middleText: description,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: AppColors.appColorBlack),
      middleTextStyle: const TextStyle(color: AppColors.appColorBlack),
      buttonColor: AppColors.appColorBlack,
      barrierDismissible: false,
      radius: 6,
      actions: [
        TextButton(
            onPressed: () {
              confirmEvent();
            },
            child: Text(
              confirmText,
              style: const TextStyle(
                  color: AppColors.appColorBlack, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          width: 30,
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(cancelText,
              style: const TextStyle(
                  color: AppColors.appColorBlack, fontWeight: FontWeight.bold)),
        )
      ],
      content: content,
    );
  }
}