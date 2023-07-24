import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/utils/app_timeZone.dart';

import '../../../constants/app_colors.dart';
import '../../../services/local/shared_pref.dart';
import '../../atoms/app_label.dart';
import 'package:intl/intl.dart';

class ActiveCardView extends StatelessWidget {
  ActiveCardView({super.key});
  var bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.appColorWhiteGray02,
          ),
          child: bookingController.activeBooking.isNotEmpty
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
                                color: AppColors.appColorLightGreen
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child: AppLabel(
                              fontSize: 12,
                              text: 'Active',
                              textColor: AppColors.appColorGreen,
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
                              '${SharedPref.getCarParkName() ?? ''} (${SharedPref.carParkPin() ?? ''})',
                          fontSize: 14),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          AppLabel(
                              text: SharedPref.getEndTime() != null
                                  ? DateFormat('dd MMM yyyy HH:mm').format(
                                      AppTimeZone.getTimeZone(
                                          timeZoneName:
                                              SharedPref.getDisplayTimeZone() ??
                                                  'Asia/Colombo',
                                          milliseconds:
                                              SharedPref.getEndTime()!))
                                  : '',
                              fontSize: 10),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                              visible: SharedPref.hasIvrFirstBooking()
                                  ? false
                                  : true,
                              child: const Icon(Icons.arrow_forward, size: 15)),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible:
                                SharedPref.hasIvrFirstBooking() ? false : true,
                            child: AppLabel(
                                text: SharedPref.getStartTime() != null
                                    ? DateFormat('dd MMM yyyy HH:mm').format(
                                        AppTimeZone.getTimeZone(
                                            timeZoneName: SharedPref
                                                    .getDisplayTimeZone() ??
                                                'Asia/Colombo',
                                            milliseconds:
                                                SharedPref.getStartTime()!))
                                    : '',
                                fontSize: 10),
                          ),
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
