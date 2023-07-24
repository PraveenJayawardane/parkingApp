import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/utils/app_timeZone.dart';

import '../../../constants/app_colors.dart';
import '../../atoms/app_label.dart';
import 'package:intl/intl.dart';

class UpcomingCardView extends StatelessWidget {
  UpcomingCardView({super.key});
  var bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.appColorWhiteGray02,
          ),
          child: bookingController.upcomingBooking.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: AppLabel(
                              fontSize: 12,
                              text: 'Upcoming',
                              textColor: Colors.amber,
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // AppLabel(text: '#7865')
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppLabel(
                          text:
                              '${bookingController.upcomingBooking.first.carPark?.first.carParkName ?? ''} (${bookingController.upcomingBooking.first.carPark?.first.carParkPIN ?? ''})',
                          fontSize: 14),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AppLabel(
                              text: bookingController
                                          .upcomingBooking.first.bookingStart !=
                                      null
                                  ? DateFormat('dd MMM yyyy HH:mm')
                                      .format(
                                          AppTimeZone.getTimeZone(
                                              timeZoneName: bookingController
                                                  .upcomingBooking
                                                  .first
                                                  .timeZone!,
                                              milliseconds: bookingController
                                                  .upcomingBooking
                                                  .first
                                                  .bookingStart!))
                                  : '',
                              fontSize: 10),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.arrow_forward, size: 15),
                          const SizedBox(
                            width: 10,
                          ),
                          AppLabel(
                              text: bookingController
                                          .upcomingBooking.first.bookingEnd !=
                                      null
                                  ? DateFormat('dd MMM yyyy HH:mm').format(
                                      AppTimeZone.getTimeZone(
                                          timeZoneName: bookingController
                                              .upcomingBooking.first.timeZone!,
                                          milliseconds: bookingController
                                              .upcomingBooking
                                              .first
                                              .bookingEnd!))
                                  : '',
                              fontSize: 10),
                        ],
                      )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 1,
                )),
        ),
      ),
    );
  }
}
