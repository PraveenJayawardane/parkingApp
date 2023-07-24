import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/model/dont_know_parking_result.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../dashboard/dashboard_navigation.dart';

class ParkingSummeryScreen extends StatelessWidget {
  ParkingSummeryScreen({Key? key}) : super(key: key);
  DontKnowParkingResult? dontKnowParkingResult = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Bookings",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              thickness: 1,
              color: AppColors.appColorLightGray,
            ),
            Image.asset(
              "assets/images/summery_bg_img.png",
              width: 300,
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            AppLabel(text: "Thank You! for parking with us."),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: [
                          AppLabel(
                            text: "Duration",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          AppLabel(
                            text:
                                '${Duration(milliseconds: dontKnowParkingResult?.booking?.duration ?? 0).inMinutes}',
                            fontSize: 12,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: [
                          AppLabel(
                            text: "Vehicle",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          AppLabel(
                            text: dontKnowParkingResult?.vehicle?.vrn ??
                                '-',
                            fontSize: 12,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLabel(
                        text: "Parking Chargers",
                        fontSize: 14,
                        textColor: AppColors.appColorLightGray,
                      ),
                      AppLabel(
                        text:
                            '${dontKnowParkingResult?.carPark?.parkingFee ?? '-'}',
                        fontSize: 15,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLabel(
                        text: "Service fee",
                        fontSize: 14,
                        textColor: AppColors.appColorLightGray,
                      ),
                      AppLabel(
                        text:
                            '${dontKnowParkingResult?.booking?.serviceFee ?? '-'}',
                        fontSize: 15,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.appColorLightGray,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLabel(
                        text: "Total",
                        fontSize: 15,
                        textColor: AppColors.appColorBlack,
                      ),
                      AppLabel(
                        text:
                            '\$ ${dontKnowParkingResult?.booking?.totalFee ?? '-'}',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomFilledButton(
                      text: "View Receipt",
                      clickEvent: () {
                        Get.toNamed(Routes.RECEIPT_SCREEN,arguments: dontKnowParkingResult);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  BorderedButton(
                      text: "Done",
                      clickEvent: () {
                        Get.offNamed(Routes.DASHBOARD);
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
