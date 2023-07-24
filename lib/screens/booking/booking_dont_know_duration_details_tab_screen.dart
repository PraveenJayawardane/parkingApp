import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/park_now_fixed_duration_tab_controller.dart';
import 'package:parkfinda_mobile/model/booking.dart';
import 'package:parkfinda_mobile/model/parkingfee.dart';
import 'package:parkfinda_mobile/screens/parking/parking_tabs/fixed_duration_parking_details_tab.dart';
import 'package:parkfinda_mobile/screens/parking/parking_tabs/fixed_duration_parking_status_tab.dart';

import 'booking_details_tabs/dont_know_parking_booking_details_tab.dart';
import 'booking_details_tabs/dont_know_parking_booking_status_tab.dart';
import 'booking_details_tabs/fixed_duration_booking_details_tab.dart';
import 'booking_details_tabs/fixed_duration_booking_status_tab.dart';

class BookingDontKnowDurationDetailsTabScreen extends StatelessWidget {
  BookingDontKnowDurationDetailsTabScreen({Key? key}) : super(key: key);
  ParkNowFixedDurationTabController parkingTabController =
      Get.put(ParkNowFixedDurationTabController());
  Booking booking = Get.arguments;
  //ParkingFee parkingFee = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          TabBar(
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: AppColors.appColorBlack,
              controller: parkingTabController.tabController,
              tabs: parkingTabController.bookingTabs),
          Expanded(
            child: TabBarView(
                controller: parkingTabController.tabController,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DontKnowParkingBookingStatusTab(),
                  ),
                  DontKnowParkingBookingDetailsTab(),
                ]),
          ),
        ],
      ),
    );
  }
}
