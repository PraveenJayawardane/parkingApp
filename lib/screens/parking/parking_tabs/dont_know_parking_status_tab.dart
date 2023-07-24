import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/utils/app_timeZone.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class DontKnowParkingStatusTab extends StatelessWidget {
  final StopWatchTimer stopWatchTimer;
  // final Dontknowparkingbooking dontknowparkingbooking;
  final BookingDetail dontknowparkingbooking;
  final Duration different;
  CountDownController countDownController = CountDownController();
  DontKnowParkingStatusTab({
    Key? key,
    required this.stopWatchTimer,
    required this.dontknowparkingbooking,
    required this.different,
  }) : super(key: key);
  ParkingNowController parkingController = Get.find<ParkingNowController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    // var timeStamp = int.parse(dontKnowParking.bookingStart!);
    // final DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    // print(time);

    var parkDuration =
        Duration(milliseconds: dontknowparkingbooking.duration ?? 1).inSeconds;
    var bookingStart = DateTime.fromMillisecondsSinceEpoch(
        dontknowparkingbooking.bookingStart!);
    var differentOfParkingStart = DateTime.now().difference(bookingStart);
    var difTime = parkDuration - (differentOfParkingStart.inSeconds);
    var avalableTime = difTime.isLowerThan(0) ? 0 : difTime;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          LocationCodeView(
            postCode: dontknowparkingbooking.carPark?[0].postCode ?? '-',
            parkingId:
                '${dontknowparkingbooking.carPark?[0].carParkPIN ?? '-'}',
            parkName: dontknowparkingbooking.carPark?[0].addressLineOne ?? '-',
            addressTow:
                dontknowparkingbooking.carPark?[0].addressLineTwo ?? '-',
            addressOne:
                dontknowparkingbooking.carPark?[0].addressLineOne ?? '-',
            city: dontknowparkingbooking.carPark?[0].city ?? '-',
          ),
          const SizedBox(
            height: 16,
          ),
          AppLabel(
            text: "Parking Started",
            fontSize: 16,
            textColor: AppColors.appColorBlack,
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
                    border: Border.all(color: AppColors.appColorLightGray)),
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
                    const SizedBox(
                      height: 6,
                    ),
                    AppLabel(
                      text: dontknowparkingbooking.bookingStart != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(
                              AppTimeZone.getTimeZone(
                                  timeZoneName:
                                      dontknowparkingbooking.timeZone!,
                                  milliseconds:
                                      dontknowparkingbooking.bookingStart!))
                          : '',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    AppLabel(
                      text: dontknowparkingbooking.bookingStart != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                                          dontknowparkingbooking.bookingStart!)
                                      .day ==
                                  DateTime.now().day
                              ? 'Today'
                              : ''
                          : '',
                      textColor: AppColors.appColorGray03,
                    ),
                  ],
                ),
              )),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6)),
                    border: Border.all(color: AppColors.appColorLightGray)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.car,
                        color: AppColors.appColorGray,
                      ),
                      const SizedBox(width: 10),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabel(
                              fontSize: 14,
                              text:
                                  dontknowparkingbooking.vehicle?[0].vRN ?? ''),
                          Row(
                            children: [
                              AppLabel(
                                  fontSize: 12,
                                  textColor: AppColors.appColorLightGray,
                                  text: dontknowparkingbooking
                                          .vehicle?[0].model ??
                                      ''),
                              const SizedBox(
                                width: 10,
                              ),
                              AppLabel(
                                  fontSize: 12,
                                  textColor: AppColors.appColorLightGray,
                                  text: dontknowparkingbooking
                                          .vehicle?[0].color ??
                                      ''),
                            ],
                          ),
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
                  ),
                ),
              )),
              // Expanded(
              //     child: Container(
              //   height: 80,
              //   decoration: BoxDecoration(
              //       borderRadius: const BorderRadius.only(
              //           topRight: Radius.circular(6),
              //           bottomRight: Radius.circular(6)),
              //       border: Border.all(color: AppColors.appColorLightGray)),
              //   child: Column(
              //     children: [
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       AppLabel(
              //         text: "Parking Fee",
              //         fontSize: 14,
              //         textColor: AppColors.appColorLightGray,
              //       ),
              //       const SizedBox(
              //         height: 6,
              //       ),
              //       AppLabel(
              //         text:
              //             //  '\$ ${dontknowparkingbooking.booking?.totalFee ?? ''}'
              //             '£${dontknowparkingbooking.totalFee?.toStringAsFixed(2) ?? ''}',
              //         fontWeight: FontWeight.bold,
              //       ),
              //       const SizedBox(
              //         height: 6,
              //       ),
              //     ],
              //   ),
              // ))
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          // AppLabel(
          //   text: "Timer",
          //   fontSize: 18,
          //   textColor: AppColors.appColorBlack,
          // ),
          CircularCountDownTimer(
            duration: 86400,
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
            isReverse: false,
            isReverseAnimation: false,
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
          // CircularCountDownTimer(
          //   duration: 100000,
          //   initialDuration: different.inSeconds,
          //   controller: countDownController,
          //   width: 150,
          //   height: 150,
          //   ringColor: AppColors.appColorLightGray.withOpacity(0.5),
          //   ringGradient: null,
          //   fillColor: AppColors.appColorGreen,
          //   fillGradient: null,
          //   backgroundColor: AppColors.appColorWhite,
          //   backgroundGradient: null,
          //   strokeWidth: 20.0,
          //   strokeCap: StrokeCap.round,
          //   textStyle: const TextStyle(
          //       fontSize: 25.0,
          //       color: AppColors.appColorBlack,
          //       fontWeight: FontWeight.bold),
          //   textFormat: CountdownTextFormat.HH_MM_SS,
          //   isReverse: false,
          //   isReverseAnimation: false,
          //   isTimerTextShown: true,
          //   autoStart: true,
          //   onStart: () {
          //     debugPrint('Countdown Started');
          //   },
          //   onComplete: () {
          //     debugPrint('Countdown Ended');
          //   },
          //   onChange: (String timeStamp) {
          //     debugPrint('Countdown Changed $timeStamp');
          //   },
          // ),
          const SizedBox(
            height: 50,
          ),
          CustomFilledButton(
            text: "Stop Parking",
            clickEvent: () {
              AppBottomSheet().stopBooKingConformation(
                  context: context,
                  onSuccess: () {
                    //  stopWatchTimer.onStopTimer();
                    Get.back();
                    ParkingNowController().dontKnowParkingstop(
                      context: context,
                      bookingEnd: DateTime.now().millisecondsSinceEpoch,
                      bookingId: dontknowparkingbooking.sId!,
                    );
                  });
            },
            bgColor: AppColors.appColorGoogleRed,
          ),
        ],
      ),
    );
  }
}
