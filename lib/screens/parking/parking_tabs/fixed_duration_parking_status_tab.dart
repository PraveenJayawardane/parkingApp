import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../../model/fixed_duration_booking.dart';
import '../../booking/extend_booking/extend_booking_duration_screen.dart';

class FixedDurationParkingStatusTab extends StatelessWidget {
  final FixedDurationbooking booking;

  FixedDurationParkingStatusTab({
    Key? key,
    required this.booking,
  }) : super(key: key);
  CountDownController countDownController = CountDownController();
  ParkingNowController parkingController = Get.find<ParkingNowController>();

  @override
  Widget build(BuildContext context) {
    var parkDuration =
        Duration(milliseconds: booking.booking?.duration ?? 1).inSeconds;

    var bookingStart =
        DateTime.fromMillisecondsSinceEpoch(booking.booking!.bookingStart!);
    var differentOfParkingStart = DateTime.now().difference(bookingStart);
    var avalableTime = parkDuration - (differentOfParkingStart.inSeconds);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          LocationCodeView(
            postCode: booking.carPark?.postCode ?? '',
            parkingId: '${booking.carPark?.carParkPIN ?? ''}',
            parkName: booking.carPark?.carParkName ?? '',
            city: booking.carPark?.city ?? '',
            addressOne: booking.carPark?.addressLineOne ?? '',
            addressTow: booking.carPark?.addressLineTwo ?? '',
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
                    AppLabel(
                      text: parkingController.showParkingFrom.value,
                      fontWeight: FontWeight.bold,
                    ),
                    AppLabel(
                      text: "Today",
                      fontSize: 14,
                      textColor: AppColors.appColorLightGray,
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
                    border: Border.all(color: AppColors.appColorLightGray)),
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
                      text: parkingController.showParkingUntil.value,
                      fontWeight: FontWeight.bold,
                    ),
                    AppLabel(
                      text: "Today",
                      fontSize: 14,
                      textColor: AppColors.appColorLightGray,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                              text: booking.vehicle?.vRN ?? '', fontSize: 14),
                          const SizedBox(
                            width: 10,
                          ),
                          AppLabel(
                              text: booking.vehicle?.model ?? '',
                              fontSize: 12,
                              textColor: AppColors.appColorLightGray),
                        ],
                      ),
                      Row(
                        children: [
                          AppLabel(
                              text: booking.vehicle?.color ?? '',
                              textColor: AppColors.appColorLightGray,
                              fontSize: 12),
                          const SizedBox(
                            width: 10,
                          ),
                          AppLabel(
                              // ignore: unnecessary_string_interpolations
                              text: booking.vehicle?.fuelType != null
                                  ? '(${booking.vehicle?.fuelType ?? ''})'
                                  : '',
                              textColor: AppColors.appColorLightGray,
                              fontSize: 12),
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
            height: 50,
          ),
          CircularCountDownTimer(
            duration: parkDuration,
            initialDuration: parkDuration - avalableTime,
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
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              //debugPrint('Countdown Started');
            },
            onComplete: () {
              //debugPrint('Countdown Ended');
            },
            onChange: (String timeStamp) {
              //debugPrint('Countdown Changed $timeStamp');
            },
          ),
          const SizedBox(
            height: 50,
          ),
          CustomFilledButton(
              text: "Extend Booking",
              clickEvent: () {
                //countDownController.start();
                print(booking.booking?.id);

                Get.to(ExtendBookingDurationScreen(
                  currency: booking.carPark!.currency,
                  buildContext: context,
                  untilTime: booking.booking!.bookingEnd,
                  carParkName: booking.carPark!.carParkName,
                  carParkPin: booking.carPark!.carParkPIN,
                  city: booking.carPark!.city,
                  startTime: booking.booking!.bookingStart,
                  bookingId: booking.booking!.id,
                  vrn: booking.vehicle!.vRN,
                  model: booking.vehicle!.model,
                  color: booking.vehicle!.color,
                  carParkId: booking.carPark!.id,
                  fuelType: booking.vehicle!.fuelType,
                  addressOne: booking.carPark?.addressLineOne,
                  addressTwo: booking.carPark?.addressLineTwo,
                  postCode: booking.carPark?.postCode,
                ));
              }),
        ],
      ),
    );
  }
}
