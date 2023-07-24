import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/molecules/containers/location_code_view.dart';

class EnterLocationScreen extends StatelessWidget {
  var parkingNowController = Get.put(ParkingNowController());
  EnterLocationScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _pinKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  var isFilled = true.obs;
  var textController = TextEditingController();
  var activePinField = [false, false, false, false].obs;

  @override
  Widget build(BuildContext context) {
    parkingNowController.noSearchResultFound.value = false;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.appColorWhite,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.appColorBlack,
            ),
            onPressed: () {
              Get.back();
              parkingNowController.isPinCompleted.value = false;
            },
          ),
          title: Obx(() {
            if (!parkingNowController.isPinCompleted.value) {
              return const Text(
                "Enter Location Code",
                style: TextStyle(color: AppColors.appColorBlack),
              );
            } else {
              return const Text(
                "Tap location to select",
                style: TextStyle(color: AppColors.appColorBlack),
              );
            }
          })),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              thickness: 1,
              color: AppColors.appColorLightGray,
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(() {
              return Visibility(
                visible: parkingNowController.isPinCompleted.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                      onTap: () {
                        parkingNowController.showHowLongParking.value = '';
                        parkingNowController.showTotalDuration.value = '';
                        Get.toNamed(Routes.PARK_NOW_SET_DURATION_SCREEN);
                      },
                      child: LocationCodeView(
                        postCode: parkingNowController
                                .parkingDetails.value.postCode ??
                            '',
                        parkingId:
                            '${parkingNowController.parkingDetails.value.carParkPIN ?? ''}',
                        parkName: parkingNowController
                                .parkingDetails.value.carParkName ??
                            '',
                        addressTow: parkingNowController
                                .parkingDetails.value.addressLineTwo ??
                            '',
                        addressOne: parkingNowController
                                .parkingDetails.value.addressLineOne ??
                            '',
                        city: parkingNowController.parkingDetails.value.city ??
                            '',
                      )),
                ),
              );
            }),
            const SizedBox(
              height: 60,
            ),
            Obx(() {
              return Visibility(
                  visible: !parkingNowController.isPinCompleted.value,
                  child: Column(
                    children: [
                      parkingNowController.noSearchResultFound.value
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Image.asset(
                                    'assets/images/booking_empty_img.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppLabel(
                                        text: 'No result found',
                                        textColor: AppColors.appColorLightGray),
                                    AppLabel(
                                      text: 'Please check your location ID',
                                      textColor: AppColors.appColorLightGray,
                                      fontSize: 12,
                                    )
                                  ],
                                )
                              ],
                            )
                          : Image.asset(
                              "assets/images/location_code_bg_image.png"),
                      !parkingNowController.noSearchResultFound.value
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: AppLabel(
                                text:
                                    "Enter the 4 or 6 digit Location ID of your car park",
                                fontSize: 18,
                                textAlign: TextAlign.center,
                                textColor: AppColors.appColorGray,
                              ),
                            )
                          : const Text(''),
                    ],
                  ));
            }),
            Obx(() {
              return Visibility(
                visible: parkingNowController.isPinCompleted.value,
                child: const SizedBox(
                  height: 200,
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                Obx(
                  () => Visibility(
                    visible: !parkingNowController.isPinCompleted.value,
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          showCursor: isFilled.value,
                          decoration: const InputDecoration(
                              counter: Offstage(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: AppColors.appColorGray03),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 10,
                            height: 1,
                          ),
                          maxLength: 4,
                          controller: textController,
                          autofocus: true,
                          onChanged: (value) {
                            if (textController.text.length == 4) {
                              isFilled.value = false;

                              AppOverlay.startOverlay(context);
                              parkingNowController.setParkNow(
                                  context: context,
                                  token: SharedPref.getToken()!,
                                  id: textController.text,
                                  contrl: parkingNowController);
                            } else {
                              isFilled.value = true;
                            }
                          },
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 100),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         height: 0,
                //         child: ListView.builder(
                //           itemCount: 4,
                //           shrinkWrap: true,
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: (context, index) {
                //             return SizedBox(
                //                 width: 40,
                //                 child: Obx(
                //                   () => Divider(
                //                     thickness: 2,
                //                     color: activePinField[index]
                //                         ? Colors.black
                //                         : Colors.grey,
                //                   ),
                //                 ));
                //           },
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
            // Form(
            //   key: _pinKey,
            //   child: Padding(
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            //       child: PinCodeTextField(
            //         appContext: context,
            //         pastedTextStyle: const TextStyle(
            //           color: AppColors.appColorBlack,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         length: 4,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         obscureText: false,
            //         cursorHeight: 20,
            //         cursorWidth: 1,
            //         blinkWhenObscuring: false,
            //         animationType: AnimationType.fade,
            //         pinTheme: PinTheme(
            //             shape: PinCodeFieldShape.underline,
            //             fieldHeight: 50,
            //             fieldWidth: 50,
            //             activeFillColor: Colors.white,
            //             inactiveColor: AppColors.appColorLightGray,
            //             activeColor: AppColors.appColorBlack,
            //             selectedColor: AppColors.appColorBlack,
            //             fieldOuterPadding: const EdgeInsets.only(right: 0)),
            //         cursorColor: Colors.black,
            //         animationDuration: const Duration(milliseconds: 300),
            //         enableActiveFill: false,
            //         controller: _pinController,
            //         useHapticFeedback: true,
            //         autoFocus: true,
            //         keyboardType: TextInputType.number,
            //         onCompleted: (v) {
            //           //parkingController. isPinCompleted.value = true;
            //           AppOverlay.startOverlay(context);
            //           ParkingNowController().setParkNow(
            //               token: SharedPref.getToken()!,
            //               id: v,
            //               contrl: parkingNowController);
            //         },
            //         onChanged: (value) {
            //           parkingNowController.isPinCompleted.value = false;
            //         },
            //         beforeTextPaste: (text) {
            //           debugPrint("Allowing to paste $text");
            //           //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //           //but you can show anything you want here, like your pop up saying wrong paste format or etc
            //           return true;
            //         },
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
