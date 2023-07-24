import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';

import '../controllers/park_later_controller.dart';

class AppBackButton {
  ParkingLaterController parkingLaterController =
      Get.put(ParkingLaterController());
  UserController userController = Get.find<UserController>();
  void getBack({required String? routes}) {
    if ('/Dashboard' == routes) {
      Get.back();
    } else if ('/ParkNowSetDurationScreen' == routes) {
      Get.back();
      // Get.back();
    } else if (routes == '/ParkLaterSetDurationScreen') {
      Get.back();
    } else if (routes == '/BottomSheet') {
      Get.back();
    } else {
      // parkingLaterController.calculateBill(
      //     parkingId: parkingLaterController.parkLaterLocationData.id!,
      //     parkingFromTime:
      //         parkingLaterController.parkingFromTime!.millisecondsSinceEpoch,
      //     parkingUntilTime:
      //         parkingLaterController.parkingUntilTime!.millisecondsSinceEpoch);
      Get.back();
      Get.back();
    }
  }
}
