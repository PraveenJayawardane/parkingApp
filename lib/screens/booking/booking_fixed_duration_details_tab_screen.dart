import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/constants/constant.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/park_now_fixed_duration_tab_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';

import 'booking_details_tabs/fixed_duration_booking_details_tab.dart';
import 'booking_details_tabs/fixed_duration_booking_status_tab.dart';
import 'booking_fixed_duration_access_tab.dart';

class BookingFixedDurationDetailsTabScreen extends StatefulWidget {
  const BookingFixedDurationDetailsTabScreen({Key? key}) : super(key: key);

  @override
  State<BookingFixedDurationDetailsTabScreen> createState() =>
      _BookingFixedDurationDetailsTabScreenState();
}

class _BookingFixedDurationDetailsTabScreenState
    extends State<BookingFixedDurationDetailsTabScreen> {
  UserController userController = Get.find<UserController>();
  ParkNowFixedDurationTabController parkingTabController =
      Get.put(ParkNowFixedDurationTabController());

  BookingDetail booking = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (booking.carPark?.first.currency == 'LKR') {
      userController.getSingleRegionCardDetail(url: Constant.slUrl);
      userController.getVehicleData(url: Constant.slUrl);
    } else {
      userController.getSingleRegionCardDetail(url: Constant.ukUrl);
      userController.getVehicleData(url: Constant.ukUrl);
    }
  }

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
      body: Obx(
        () => userController.isVehicleLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  const Divider(
                    thickness: 1,
                    color: AppColors.appColorLightGray,
                  ),
                  TabBar(
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      indicatorColor: AppColors.appColorBlack,
                      controller: parkingTabController.tabController,
                      tabs: parkingTabController.bookingTabs),
                  Expanded(
                    child: TabBarView(
                        controller: parkingTabController.tabController,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child:
                                FixedDurationBookingStatusTab(booking: booking),
                          ),
                          BookingFixedDurationAccessTab(
                              acsessInformation:
                                  booking.carPark?.first.accessInformation),
                          FixedDurationBookingDetailsTab(
                              bookingdetail: booking),
                        ]),
                  ),
                ],
              ),
      ),
    );
  }
}
