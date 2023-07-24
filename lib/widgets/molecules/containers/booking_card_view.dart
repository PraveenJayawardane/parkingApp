import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/utils/app_timeZone.dart';

import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';

import '../../../model/Bookingdetail.dart';

class BookingCardView extends StatelessWidget {
  final BookingDetail bookingdetails;

  const BookingCardView({Key? key, required this.bookingdetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            AppLabel(
              text:
                  '${bookingdetails.carPark?.first.carParkName ?? '-'} (${bookingdetails.carPark?.first.carParkPIN ?? '-'}) ${bookingdetails.carPark?.first.city ?? '-'}',
              textColor: AppColors.appColorBlack,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 30,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: bookingdetails.status == "Active"
                      ? AppColors.appColorGreen.withOpacity(0.2)
                      : bookingdetails.status == "Upcoming"
                          ? Colors.amber.withOpacity(0.2)
                          : bookingdetails.status == "Completed"
                              ? AppColors.appColorFacebookBlue.withOpacity(0.4)
                              : AppColors.appColorGoogleRed.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: bookingdetails.status == "Active"
                    ? const Text(
                        "Active",
                        style: TextStyle(color: AppColors.appColorGreen),
                      )
                    : bookingdetails.status == "Upcoming"
                        ? const Text(
                            "Upcoming",
                            style: TextStyle(color: Colors.amber),
                          )
                        : bookingdetails.status == "Completed"
                            ? const Text(
                                "Completed",
                                style: TextStyle(
                                    color: AppColors.appColorFacebookBlue),
                              )
                            : const Text(
                                "Cancelled",
                                style: TextStyle(
                                    color: AppColors.appColorGoogleRed),
                              ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.appColorLightGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLabel(
                      text: "Park From",
                      fontSize: 14,
                      textColor: AppColors.appColorGray,
                    ),
                    Text(
                      bookingdetails.bookingStart != null
                          ? DateFormat('yyyy-MMM-dd HH:mm').format(
                              AppTimeZone.getTimeZone(
                                  timeZoneName: bookingdetails.timeZone!,
                                  milliseconds: bookingdetails.bookingStart!))
                          : '',
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
              visible: bookingdetails.bookingModule == 'ivr' &&
                      bookingdetails.parkingType == "parkNow" &&
                      bookingdetails.startStopOption == true
                  ? false
                  : true,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.appColorLightGray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLabel(
                        text: "Park Until",
                        fontSize: 14,
                        textColor: AppColors.appColorGray,
                      ),
                      Text(
                        bookingdetails.bookingEnd != null
                            ? DateFormat('yyyy-MMM-dd HH:mm').format(
                                AppTimeZone.getTimeZone(
                                    timeZoneName: bookingdetails.timeZone!,
                                    milliseconds: bookingdetails.bookingEnd!))
                            : '',
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderedButton(
              text: "View Details",
              clickEvent: () async {
                // print(booking.parkingType);
                if (bookingdetails.status == "Active" &&
                    bookingdetails.parkingType == "parkNow") {
                  if (bookingdetails.bookingModule == 'ivr') {
                    if (bookingdetails.startStopOption == true) {
                      Get.toNamed(
                          Routes.PARK_NOW_DONT_KNOW_PARKING_DETAILS_SCREEN,
                          arguments: bookingdetails);
                    } else {
                      Get.toNamed(
                          Routes.BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
                          arguments: bookingdetails);
                    }
                  } else {
                    Get.toNamed(
                        Routes.BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
                        arguments: bookingdetails);
                  }
                } else if (bookingdetails.status == "Active" &&
                    bookingdetails.parkingType == "parkLater") {
                  Get.toNamed(Routes.BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
                      arguments: bookingdetails);
                } else {
                  Get.toNamed(Routes.SINGLE_BOOK_SCREEN,
                      arguments: bookingdetails);
                }
              },
              borderColor: AppColors.appColorGray,
            ),
            const SizedBox(
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}
