import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/atoms/app_label.dart';
import '../../../widgets/molecules/buttons/bordered_button.dart';

class DontKnowParkingRegisterDetailsTab extends StatelessWidget {
  final FixedDurationbooking dontknowparkingbooking;

  DontKnowParkingRegisterDetailsTab(
      {Key? key, required this.dontknowparkingbooking})
      : super(key: key);
  var parkingController = Get.find<ParkingNowController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  color: AppColors.appColorLightGray.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LocationCodeView(addressTow:  parkingController.parkingDetails.value.addressLineTwo ??
                            '' ,
                    postCode:
                        parkingController.parkingDetails.value.postCode ?? '',
                    city: parkingController.parkingDetails.value.city ?? '',
                    parkingId:
                        '${parkingController.parkingDetails.value.carParkPIN ?? ''}',
                    parkName:
                        parkingController.parkingDetails.value.carParkName ??
                            '',
                    addressOne:
                        parkingController.parkingDetails.value.addressLineOne ??
                            '',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        "assets/images/demo_img/car_park1.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: AppLabel(
                            text: "Booking Information",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Booking ID",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                              AppLabel(
                                text:
                                    dontknowparkingbooking.booking?.bookingId ??
                                        '-',
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Status",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                Container(
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: dontknowparkingbooking
                                                  .booking?.status ==
                                              "Active"
                                          ? AppColors.appColorGreen
                                              .withOpacity(0.2)
                                          : dontknowparkingbooking
                                                      .booking?.status ==
                                                  "Upcoming"
                                              ? AppColors.appColorOrange
                                                  .withOpacity(0.2)
                                              : dontknowparkingbooking
                                                          .booking?.status ==
                                                      "Completed"
                                                  ? AppColors.appColorLightGray
                                                      .withOpacity(0.4)
                                                  : AppColors.appColorGoogleRed
                                                      .withOpacity(0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: dontknowparkingbooking
                                                .booking?.status ==
                                            "Active"
                                        ? const Text(
                                            "Active",
                                            style: TextStyle(
                                                color: AppColors.appColorGreen),
                                          )
                                        : dontknowparkingbooking
                                                    .booking?.status ==
                                                "Upcoming"
                                            ? const Text(
                                                "Upcoming",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .appColorOrange),
                                              )
                                            : dontknowparkingbooking
                                                        .booking?.status ==
                                                    "Completed"
                                                ? const Text(
                                                    "Completed",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appColorGray),
                                                  )
                                                : const Text(
                                                    "Cancelled",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appColorGoogleRed),
                                                  ),
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Vehicle Number",
                                textColor: AppColors.appColorLightGray,
                                fontSize: 14,
                              ),
                              AppLabel(
                                text:
                                    dontknowparkingbooking.vehicle?.vRN ?? '-',
                                fontSize: 14,
                                textColor: AppColors.appColorBlack,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Payment Method",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                              AppLabel(
                                text: "VISA ending in 0234",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Booked On",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                              AppLabel(
                                text: dontknowparkingbooking
                                        .booking?.bookingDate ??
                                    '-',
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Permit Start",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                              AppLabel(
                                text: dontknowparkingbooking
                                            .booking?.bookingStart !=
                                        null
                                    ? '${DateFormat("yyyy-MM-dd  hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(dontknowparkingbooking.booking!.bookingStart!))} '
                                    : '',
                                fontSize: 14,
                                textColor: AppColors.appColorBlack,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Permit End",
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       ),
                        //       AppLabel(
                        //         text:
                        //             '${dontknowparkingbooking.booking?.bookingEnd ?? '-'}',
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Duration",
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       ),
                        //       AppLabel(
                        //         text:
                        //             '${dontknowparkingbooking.booking?.duration ?? '-'}',
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 8,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Total Cost",
                        //         fontSize: 14,
                        //       ),
                        //       AppLabel(
                        //         text:
                        //             '\$ ${dontknowparkingbooking.booking?.totalFee ?? '-'}',
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.bold,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BorderedButton(
              text: "View receipt",
              clickEvent: () {
                print('object');
              }),
        ),
      ],
    );
  }
}
