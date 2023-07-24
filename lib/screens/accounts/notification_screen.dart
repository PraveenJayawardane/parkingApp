import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/notification_card.dart';

import '../../constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  var bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
            "Notifications",
            style: TextStyle(
                color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Obx(() => RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: bookingController.getNotification,
              child: ListView.builder(
                  itemCount: bookingController.allNotification.isEmpty
                      ? 1
                      : bookingController.allNotification.length,
                  itemBuilder: (context, index) {
                    if (bookingController.allNotification.isEmpty) {
                      return Center(
                        child: SizedBox(
                          width: height * 0.2,
                          height: height * 0.8,
                          child: Image.asset(
                            'assets/images/booking_empty_img.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          AppOverlay.startOverlay(context);
                          bookingController.getSingleNotification(
                              id: bookingController.allNotification[index].id!);
                        },
                        child: NotificationCard(
                          notification:
                              bookingController.allNotification[index],
                        ),
                      );
                    }
                  }),
            )));
  }
}
