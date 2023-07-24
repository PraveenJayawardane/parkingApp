import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';

import '../../../controllers/booking_controller.dart';
import '../../../services/local/shared_pref.dart';
import '../../atoms/app_label.dart';

class ParkAgainCardView extends StatelessWidget {
  const ParkAgainCardView({super.key});

  @override
  Widget build(BuildContext context) {
    var bookingController = Get.find<BookingController>();
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOK_AGAIN_SET_DURATION_SCREEN,
            arguments: bookingController.completedBooking[0]);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12.withOpacity(0.06),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(children: [
                const Icon(Icons.refresh),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLabel(text: 'Park Again'),
                    SizedBox(
                      width: 300,
                      child: AppLabel(
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          text: SharedPref.getCarParkName() ?? '-'),
                    )
                  ],
                )
              ]),
            ),
          )),
    );
  }
}
