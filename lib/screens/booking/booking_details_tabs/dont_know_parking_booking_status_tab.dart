import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../constants/routes.dart';
import '../../../model/Bookingdetail.dart';

class DontKnowParkingBookingStatusTab extends StatelessWidget {
  StopWatchTimer stopWatchTimer = StopWatchTimer();
  DontKnowParkingBookingStatusTab({
    Key? key,
  }) : super(key: key);
  BookingDetail booking = Get.arguments;
  CountDownController countDownController = CountDownController();

  ParkingNowController parkingController = Get.find<ParkingNowController>();

  @override
  Widget build(BuildContext context) {
    var parkDuration = Duration(milliseconds: booking.duration ?? 1).inSeconds;
    var bookingStart =
        DateTime.fromMillisecondsSinceEpoch(booking.bookingStart!);
    var differentOfParkingStart = DateTime.now().difference(bookingStart);
    var difTime = parkDuration - (differentOfParkingStart.inSeconds);
    var avalableTime = difTime.isLowerThan(0) ? 0 : difTime;
    var timeStamp = 34583; //int.parse(dontKnowParking.bookingStart!);
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appColorWhite,
        title: AppLabel(
          text: "Booking",
          fontSize: 18,
        ),
        centerTitle: true,
        leading: const BackButton(color: AppColors.appColorBlack),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                LocationCodeView(
                  postCode: booking.carPark?.first.postCode ?? '',
                  parkingId: '${booking.carPark?.first.carParkPIN ?? ''}',
                  parkName: booking.carPark?.first.carParkName ?? '',
                  addressOne: booking.carPark?.first.addressLineOne ?? '',
                  city: booking.carPark?.first.city ?? '',
                  addressTow: booking.carPark?.first.addressLineTwo ?? '',
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: AppColors.appColorLightGray)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          AppLabel(
                            text: "Park From",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: booking.bookingStart != null
                                ? ' ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(booking.bookingStart!))}'
                                : '',
                          ),
                          AppLabel(
                            text: booking.bookingStart != null
                                ? ' ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(booking.bookingStart!))}'
                                : '',
                            textColor: AppColors.appColorGray03,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: AppColors.appColorLightGray)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          AppLabel(
                            text: "Park Until",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                              text: booking.bookingEnd != null
                                  ? ' ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(booking.bookingEnd!))}'
                                  : ''),
                          AppLabel(
                              textColor: AppColors.appColorGray03,
                              fontSize: 14,
                              text: booking.bookingEnd != null
                                  ? ' ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(booking.bookingEnd!))}'
                                  : ''),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.car,
                          color: AppColors.appColorGray,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppLabel(
                                    text: booking.vehicle?[0].vRN ??
                                        '-' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 14),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppLabel(
                                    text: booking.vehicle?[0].model ??
                                        '-' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 12),
                              ],
                            ),
                            Row(
                              children: [
                                AppLabel(
                                    text:
                                        '${booking.vehicle?[0].color ?? '-'} ' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 12,
                                    textColor: AppColors.appColorLightGray),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppLabel(
                                    text:
                                        '(${booking.vehicle?[0].fuelType ?? ''} )' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 12,
                                    textColor: AppColors.appColorLightGray),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                            // AppLabel(
                            //   text: "MG Black",
                            //   textColor: AppColors.appColorLightGray,
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CircularCountDownTimer(
                  duration: avalableTime == 0 ? 0 : parkDuration,
                  initialDuration: parkDuration - avalableTime == parkDuration
                      ? 0
                      : parkDuration - avalableTime,
                  controller: countDownController,
                  width: 150,
                  height: 150,
                  ringColor: AppColors.appColorLightGray.withOpacity(0.5),
                  ringGradient: null,
                  fillColor: avalableTime == 0
                      ? AppColors.appColorGray
                      : AppColors.appColorGreen,
                  fillGradient: null,
                  backgroundColor: AppColors.appColorWhite,
                  backgroundGradient: null,
                  strokeWidth: 20.0,
                  strokeCap: StrokeCap.round,
                  textStyle: const TextStyle(
                      fontSize: 25.0,
                      color: AppColors.appColorBlack,
                      fontWeight: FontWeight.bold),
                  textFormat: CountdownTextFormat.HH_MM_SS,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: true,
                  onStart: () {
                    debugPrint('Countdown Started');
                  },
                  onComplete: () {
                    debugPrint('Countdown Ended');
                  },
                  onChange: (String timeStamp) {
                    //debugPrint('Countdown Changed $timeStamp');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFilledButton(
                  text: "Stop Parking",
                  clickEvent: () {
                    AppBottomSheet().stopBooKingConformation(
                        context: context,
                        onSuccess: () {
                          stopWatchTimer.onStopTimer();
                          Get.back();
                          Get.toNamed(Routes.PARKING_SUMMERY_SCREEN);
                        });
                  },
                  bgColor: AppColors.appColorGoogleRed,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
