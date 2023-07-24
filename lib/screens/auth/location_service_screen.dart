import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/auth_controller.dart';
import 'package:parkfinda_mobile/permissions/location_permission.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';

import '../../constants/routes.dart';

class LocationServiceScreen extends StatelessWidget {
  const LocationServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.appColorLightGray.withOpacity(0.3)),
              child: const Icon(
                Icons.location_on_outlined,
                size: 50,
                color: AppColors.appColorGray,
              ),
            ),
          ),
          const SizedBox(
            height: 36,
          ),
          AppLabel(
            text: "Location Services",
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
          const SizedBox(
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                    child: AppLabel(
                  fontSize: 14,
                  text:
                      "Sharing your location allows us to direct you to available spaces and makes paying even easier. You can read about how we use your data in our",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.appColorGray,
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          GestureDetector(
            child: AppLabel(
              text: "Privacy Policy.",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              Get.toNamed(Routes.PRIVACY_POLICY_SCREEN);
            },
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(
                text: "Let’s do it",
                clickEvent: () async {
                  bool status =
                      await LocationPermission().getLocationPermission();
                  if (status) {
                    AuthController().guestUserLogin(context);
                  }
                }),
          ),
          const SizedBox(
            height: 8,
          ),
          GhostButton(
              text: "Skip",
              color: AppColors.appColorGray,
              clickEvent: () {
                AuthController().guestUserLogin(context);
              })
        ],
      ),
    );
  }
}
