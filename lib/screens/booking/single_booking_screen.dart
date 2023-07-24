import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/services/remote/account_service.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/single_book_view.dart';

import '../../constants/app_colors.dart';
import '../../constants/constant.dart';
import '../../controllers/tab_controllers/park_now_fixed_duration_tab_controller.dart';
import '../../controllers/user_controller.dart';
import '../../model/Bookingdetail.dart';
import 'booking_fixed_duration_access_tab.dart';

class SingleBookingScreen extends StatefulWidget {
  const SingleBookingScreen({super.key});

  @override
  State<SingleBookingScreen> createState() => _SingleBookingScreenState();
}

class _SingleBookingScreenState extends State<SingleBookingScreen> {
  UserController userController = Get.find<UserController>();
  ParkingNowController parkingNowController = Get.find<ParkingNowController>();
  ParkNowFixedDurationTabController parkingTabController =
      Get.put(ParkNowFixedDurationTabController());
  BookingDetail booking = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (booking.carPark?.first.currency == 'LKR') {
      bookingController.baseUrl.value = Constant.slUrl;
      parkingNowController.showHowLongParking.value = '';
      parkingNowController.showTotalDuration.value = '';
      parkingNowController.isIDontKnowParkingTime.value = false;
      parkingNowController.isAvalabilityOfTimeSlot.value = false;
      userController.getSingleRegionCardDetail(url: Constant.slUrl);
      userController.getVehicleData(url: Constant.slUrl);
    } else {
      bookingController.baseUrl.value = Constant.ukUrl;
      parkingNowController.showHowLongParking.value = '';
      parkingNowController.showTotalDuration.value = '';
      parkingNowController.isIDontKnowParkingTime.value = false;
      parkingNowController.isAvalabilityOfTimeSlot.value = false;
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
        backgroundColor: Colors.white,
        elevation: 1,
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
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TabBar(
                      indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      indicatorColor: AppColors.appColorBlack,
                      controller: booking.status == 'Upcoming'
                          ? parkingTabController.tabControllerForUpcoming
                          : parkingTabController.tabControllerForComplete,
                      tabs: booking.status == 'Upcoming'
                          ? parkingTabController.bookingTabsInUpcoming
                          : parkingTabController.bookingTabsInComplete),
                  Expanded(
                    child: TabBarView(
                        controller: booking.status == 'Upcoming'
                            ? parkingTabController.tabControllerForUpcoming
                            : parkingTabController.tabControllerForComplete,
                        children: booking.status == 'Upcoming'
                            ? [
                                SingleBookView(booking: booking),
                                BookingFixedDurationAccessTab(
                                  acsessInformation:
                                      booking.carPark?.first.accessInformation,
                                )
                              ]
                            : [
                                SingleBookView(booking: booking),
                              ]),
                  ),
                ],
              ),
      ),
    );
  }
}
