import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/booking_controller.dart';
import '../../../widgets/molecules/containers/booking_card_view.dart';

class UpcomingTab extends StatelessWidget {
  UpcomingTab({
    Key? key,
  }) : super(key: key);
  var bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => RefreshIndicator(
          onRefresh: bookingController.getAllBooking,
          child: ListView.builder(
            itemCount: bookingController.upcomingBooking.isEmpty
                ? 1
                : bookingController.upcomingBooking.length,
            itemBuilder: (context, index) {
              if (bookingController.upcomingBooking.isEmpty) {
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
                return BookingCardView(
                    bookingdetails: bookingController.upcomingBooking[index]);
              }
            },
          ),
        ),
      ),
    );
  }
}
