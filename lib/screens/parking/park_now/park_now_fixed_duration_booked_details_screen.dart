import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/park_now_fixed_duration_tab_controller.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:parkfinda_mobile/screens/parking/parking_tabs/fixed_duration_parking_details_tab.dart';
import 'package:parkfinda_mobile/screens/parking/parking_tabs/fixed_duration_parking_status_tab.dart';

import '../../booking/booking_fixed_duration_access_tab.dart';

class ParkNowFixedDurationBookedDetailsScreen extends StatelessWidget {
  final FixedDurationbooking booking;
  ParkNowFixedDurationBookedDetailsScreen({Key? key, required this.booking})
      : super(key: key);
  ParkNowFixedDurationTabController parkingTabController =
      Get.put(ParkNowFixedDurationTabController());

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
            Get.toNamed(Routes.DIRECT_DASHBOARD);
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FixedDurationParkingStatusTab(
                      booking: booking,
                    ),
                  ),
                  BookingFixedDurationAccessTab(
                      acsessInformation: booking.carPark?.accessInformation),
                  FixedDurationParkingDetailsTab(parkNowBooking: booking),
                ]),
          ),
        ],
      ),
    );
  }
}
