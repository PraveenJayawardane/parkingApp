import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../../utils/app_timeZone.dart';
import '../extend_booking/extend_booking_duration_screen.dart';

class FixedDurationBookingStatusTab extends StatelessWidget {
  final BookingDetail booking;
  FixedDurationBookingStatusTab({
    Key? key,
    required this.booking,
  }) : super(key: key);
  CountDownController countDownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    var parkDuration = Duration(milliseconds: booking.duration ?? 1).inSeconds;
    var bookingStart =
        DateTime.fromMillisecondsSinceEpoch(booking.bookingStart!);
    var differentOfParkingStart = DateTime.now().difference(bookingStart);
    var difTime = parkDuration - (differentOfParkingStart.inSeconds);
    var avalableTime = difTime.isLowerThan(0) ? 0 : difTime;

    print(parkDuration - avalableTime);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          LocationCodeView(
            postCode: booking.carPark?[0].postCode ?? '',
            parkingId: '${booking.carPark?[0].carParkPIN ?? ''}',
            parkName: booking.carPark?[0].carParkName ??
                '', //'${parkingFee.data!.carpark!.carParkPIN!}',
            addressTow: booking.carPark?[0].addressLineTwo ?? '',
            city: booking.carPark?[0].city ?? '',
            addressOne: booking.carPark?[0].addressLineOne ??
                '', /*parkingFee.data!.carpark!.addressLineOne! +
                
                ',' +
                parkingFee.data!.carpark!.addressLineTwo!,*/
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
                      text: booking.bookingStart != null
                          ? ' ${DateFormat('HH:mm').format(AppTimeZone.getTimeZone(timeZoneName: booking.timeZone!, milliseconds: booking.bookingStart!))}'
                          : '',
                    ),
                    AppLabel(
                      text: booking.bookingStart != null
                          ? ' ${DateFormat('yyyy-MM-dd').format(AppTimeZone.getTimeZone(timeZoneName: booking.timeZone!, milliseconds: booking.bookingStart!))}'
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
                        text: booking.bookingEnd != null
                            ? ' ${DateFormat('HH:mm').format(AppTimeZone.getTimeZone(timeZoneName: booking.timeZone!, milliseconds: booking.bookingEnd!))}'
                            : ''),
                    AppLabel(
                        textColor: AppColors.appColorGray03,
                        fontSize: 14,
                        text: booking.bookingEnd != null
                            ? ' ${DateFormat('yyyy-MM-dd').format(AppTimeZone.getTimeZone(timeZoneName: booking.timeZone!, milliseconds: booking.bookingEnd!))}'
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
            height: 20,
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.car,
                    color: AppColors.appColorGray,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  booking.vehicle?[0].model != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                        '' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 12),
                              ],
                            ),
                            Row(
                              children: [
                                AppLabel(
                                    text:
                                        '${booking.vehicle?[0].color ?? ''} ' /*booking.vehicleNumberPlate!*/,
                                    fontSize: 12,
                                    textColor: AppColors.appColorLightGray),
                                const SizedBox(
                                  width: 5,
                                ),
                                AppLabel(
                                    text: booking.vehicle?[0].fuelType != null
                                        ? '(${booking.vehicle?[0].fuelType ?? ''} )'
                                        : '' /*booking.vehicleNumberPlate!*/,
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
                      : Text(booking.vehicle?[0].vRN ?? '')
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
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
            height: 50,
          ),
          CustomFilledButton(
              text: "Extend Booking",
              clickEvent: () {

                Get.to(ExtendBookingDurationScreen(
                    currency: booking.carPark?.first.currency,
                    color: booking.vehicle![0].color,
                    model: booking.vehicle![0].model,
                    buildContext: context,
                    untilTime: booking.bookingEnd,
                    carParkId: booking.carPark![0].sId,
                    carParkName: booking.carPark![0].carParkName,
                    carParkPin: booking.carPark![0].carParkPIN,
                    city: booking.carPark![0].city,
                    startTime: booking.bookingStart,
                    bookingId: booking.sId,
                    vrn: booking.vehicle![0].vRN,
                    addressOne: booking.carPark![0].addressLineOne,
                    addressTwo: booking.carPark![0].addressLineTwo,
                    postCode: booking.carPark![0].postCode));
              }),
        ],
      ),
    );
  }
}
