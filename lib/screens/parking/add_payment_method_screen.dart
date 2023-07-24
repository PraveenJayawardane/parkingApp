import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/screens/accounts/nmi_payment_screen.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';

import '../../constants/app_colors.dart';

class AddPaymentMethodScreen extends StatelessWidget {
  AddPaymentMethodScreen({Key? key}) : super(key: key);
  var parkingType = Get.arguments[0];
  var bookingType = Get.arguments[1];
  var bookingPrice = Get.arguments[2];

  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    print(parkingType);
    print(bookingType);
    print(bookingPrice);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Add Payment Method",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                //  Get.toNamed(Routes.PARK_NOW_PAYMENT_SCREEN);
                Get.to(NmiPaymentScreen(
                  price: bookingPrice,
                  bookigType: bookingType,
                  parkingType: parkingType,
                ));
              },
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.creditCard),
                  const SizedBox(
                    width: 10,
                  ),
                  AppLabel(text: "Credit or Debit card"),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Divider(
              thickness: 1,
              color: AppColors.appColorLightGray,
            ),
          ),
          // Visibility(
          //   visible:
          //       defaultTargetPlatform == TargetPlatform.android ? true : false,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: InkWell(
          //       onTap: () {
          //         Get.to(ParkNowPaymentScreen());
          //       },
          //       child: Row(
          //         children: [
          //           const FaIcon(FontAwesomeIcons.google),
          //           const SizedBox(
          //             width: 10,
          //           ),
          //           AppLabel(text: "Google Pay"),
          //           const Spacer(),
          //           const Icon(Icons.arrow_forward_ios)
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Visibility(
          //   visible:
          //       defaultTargetPlatform == TargetPlatform.android ? true : false,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          //     child: Divider(
          //       thickness: 1,
          //       color: AppColors.appColorLightGray,
          //     ),
          //   ),
          // ),
          // Visibility(
          //   visible: defaultTargetPlatform == TargetPlatform.iOS ? true : false,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: InkWell(
          //       onTap: () {},
          //       child: Row(
          //         children: [
          //           const FaIcon(FontAwesomeIcons.apple),
          //           const SizedBox(
          //             width: 10,
          //           ),
          //           AppLabel(text: "Apple Pay"),
          //           const Spacer(),
          //           const Icon(Icons.arrow_forward_ios)
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Visibility(
          //   visible: defaultTargetPlatform == TargetPlatform.iOS ? true : false,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          //     child: Divider(
          //       thickness: 1,
          //       color: AppColors.appColorLightGray,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
