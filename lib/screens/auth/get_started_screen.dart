import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_heading.dart';
import '../../widgets/atoms/app_label.dart';
import '../../widgets/molecules/buttons/bordered_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 8,
          ),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Card(
              child: Center(
                  child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.appColorBlack,
                size: 16,
              )),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            color: AppColors.appColorLightGray.withOpacity(0.1),
            child: Center(
              child: Image.asset("assets/images/get_started_bg_img.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeading(text: 'Get started', fontSize: 24),
                const SizedBox(
                  height: 10,
                ),
                AppLabel(
                  text: 'Sign in or create an account to continue',
                  fontSize: 16,
                  textColor: AppColors.appColorGray,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                BorderedButton(
                    text: "Log in with email or phone number",
                    clickEvent: () {
                      Get.toNamed(Routes.LOGIN);
                    }),
                const SizedBox(
                  height: 10,
                ),
                BorderedButton(
                    text: "Create an account with email address",
                    clickEvent: () {
                      Get.toNamed(Routes.SIGNUP);
                    }),
                const SizedBox(
                  height: 30,
                ),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          spacing: 5, // <-- Spacing between children
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppLabel(
                                  text:
                                      "By proceeding with creating an account, you agree",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.appColorGray,
                                ),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppLabel(
                                    text: "to the Car Park ",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    textColor: AppColors.appColorGray,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.TERMS_OF_USE_SCREEN);
                                    },
                                    child: const Text(
                                      ' Terms & Conditions ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500, // light
                                        // italic
                                      ),
                                    ),
                                  ),
                                  AppLabel(
                                    text: " and",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    textColor: AppColors.appColorGray,
                                  ),
                                ]),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.PRIVACY_POLICY_SCREEN);
                              },
                              child: const Text(
                                'Privacy Policy.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // Center(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Expanded(
                //           child: AppLabel(
                //         textAlign: TextAlign.center,
                //         fontSize: 14,
                //         text:
                //             'By proceeding with creating an account, you agree to theCar Park Terms & Conditions and Privacy Policy.',
                //       )),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
