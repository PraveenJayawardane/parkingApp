import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class DontKnowParkingRegisterStatusTab extends StatelessWidget {
  final StopWatchTimer stopWatchTimer;
  final FixedDurationbooking dontknowparkingbooking;

  DontKnowParkingRegisterStatusTab({
    Key? key,
    required this.stopWatchTimer,
    required this.dontknowparkingbooking,
  }) : super(key: key);
  ParkingNowController parkingController = Get.find<ParkingNowController>();
  UserController userController = Get.find<UserController>();
  CountDownController countDownController = CountDownController();
  @override
  Widget build(BuildContext context) {
    // var timeStamp = int.parse(dontKnowParking.bookingStart!);
    // final DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    // print(time);

    stopWatchTimer.onStartTimer();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          LocationCodeView(
            postCode: dontknowparkingbooking.carPark?.postCode ?? '-',
            addressOne: dontknowparkingbooking.carPark?.addressLineOne ?? '-',
            parkingId: '${dontknowparkingbooking.carPark?.carParkPIN ?? '-'}',
            parkName: dontknowparkingbooking.carPark?.carParkName ?? '-',
            city: dontknowparkingbooking.carPark?.city ?? '-',
            addressTow: dontknowparkingbooking.carPark?.addressLineTwo ?? '-',
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
                      text: dontknowparkingbooking.booking?.bookingStart != null
                          ? DateFormat('yyyy-MM-dd hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  dontknowparkingbooking
                                      .booking!.bookingStart!))
                          : '',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const SizedBox(
                      height: 10,
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
                                    dontknowparkingbooking.vehicle?.vRN ?? ''),
                            Row(children: [
                              AppLabel(
                                  fontSize: 12,
                                  textColor: AppColors.appColorLightGray,
                                  text: dontknowparkingbooking.vehicle?.model ??
                                      ''),
                              const SizedBox(
                                width: 10,
                              ),
                              AppLabel(
                                  fontSize: 12,
                                  textColor: AppColors.appColorLightGray,
                                  text: dontknowparkingbooking.vehicle?.color ??
                                      ''),
                            ]),
                          ]),

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
              Expanded(
                  child: Container(
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6)),
                    border: Border.all(color: AppColors.appColorLightGray)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    AppLabel(
                      text: "Parking Fee",
                      fontSize: 14,
                      textColor: AppColors.appColorLightGray,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    AppLabel(
                      text:
                          //  '\$ ${dontknowparkingbooking.booking?.totalFee ?? ''}'
                          '\$${dontknowparkingbooking.booking?.totalFee ?? ''}',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // AppLabel(
          //   text: "Timer",
          //   fontSize: 18,
          //   textColor: AppColors.appColorBlack,
          // ),
          StreamBuilder<int>(
            stream: stopWatchTimer.rawTime,
            initialData: stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              final displayTime = StopWatchTimer.getDisplayTime(value,
                  minute: true, second: true, hours: true, milliSecond: false);
              print(displayTime);
              var t = Duration(
                      minutes: int.parse(
                        displayTime.split(':')[1],
                      ),
                      seconds: int.parse(displayTime.split(':')[2]))
                  .inSeconds
                  .obs;
              print(t);

              if (t.value >= 3600) {
                t.value = 0;
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Obx(
                      () => CircularCountDownTimer(
                        duration: 3600,
                        initialDuration: t.value,
                        controller: countDownController,
                        width: 150,
                        height: 150,
                        ringColor: AppColors.appColorLightGray.withOpacity(0.5),
                        ringGradient: null,
                        fillColor: AppColors.appColorGreen,
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
                        isTimerTextShown: false,
                        autoStart: true,
                        onStart: () {
                          debugPrint('Countdown Started');
                        },
                        onComplete: () {
                          debugPrint('Countdown Ended');
                        },
                        onChange: (String timeStamp) {
                          debugPrint('Countdown Changed $timeStamp');
                        },
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 125,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 50,
          ),
          CustomFilledButton(
            text: "Stop Parking",
            clickEvent: () {
              AppBottomSheet().stopBooKingConformation(
                  context: context,
                  onSuccess: () {
                    stopWatchTimer.onStopTimer();
                    Get.back();
                    ParkingNowController().dontKnowParkingstop(
                      context: context,
                      bookingEnd: DateTime.now().millisecondsSinceEpoch,
                      bookingId: dontknowparkingbooking.booking!.id!,
                    );
                  });
            },
            bgColor: AppColors.appColorGoogleRed,
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
