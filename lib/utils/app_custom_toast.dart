import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';

class AppCustomToast {
  static void successToast(String message) {
    CherryToast.success(
      toastPosition: Position.top,
      autoDismiss: false,
      displayIcon: false,
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 5,
      title: Text(message),
    ).show(Get.context as BuildContext);
  }

  static void errorToast(String message) {
    CherryToast.error(
      toastPosition: Position.top,
      autoDismiss: false,
      displayIcon: false,
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 5,
      title: Text(message),
    ).show(Get.context as BuildContext);
  }

  static void warningToast(String message) {
    CherryToast.warning(
      toastPosition: Position.bottom,
      autoDismiss: false,
      displayIcon: false,
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 5,
      title: Text(message),
    ).show(Get.context as BuildContext);
  }
}
