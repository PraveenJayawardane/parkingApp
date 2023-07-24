import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/constant.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../model/Bookingdetail.dart';
import '../../../services/local/shared_pref.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../accounts/nmi_payment_screen.dart';

class BookAgainSetDurationScreen extends StatefulWidget {
  const BookAgainSetDurationScreen({Key? key}) : super(key: key);

  @override
  State<BookAgainSetDurationScreen> createState() =>
      _BookAgainSetDurationScreenState();
}

class _BookAgainSetDurationScreenState
    extends State<BookAgainSetDurationScreen> {
  BookingDetail? bookingDetail = Get.arguments;

  var status = false.obs;

  String? bottomSheetTitle;

  String? bottomSheetBodyText;

  var userController = Get.find<UserController>();

  var parkingController = Get.put(ParkingNowController());

  var bookingController = Get.put(BookingController());

  var promoCodeController = TextEditingController();

  var promoCodeButtonState = false.obs;

  Rx<Barcode>? result;

  Rx<QRViewController>? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            // parkingController.showHowLongParking.value = '';
            // parkingController.showTotalDuration.value = '';
            parkingController.bookAgainLoading.value = true;
            Get.back();
          },
        ),
        title: const Text(
          "Duration",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: LocationCodeView(
                      postCode: bookingDetail?.carPark?[0].postCode ?? '',
                      parkingId:
                          '${bookingDetail?.carPark?[0].carParkPIN ?? ''}',
                      parkName: bookingDetail?.carPark?[0].carParkName ?? '',
                      addressTow:
                          bookingDetail?.carPark?[0].addressLineTwo ?? '',
                      city: bookingDetail?.carPark?[0].city ?? '',
                      addressOne:
                          bookingDetail?.carPark?[0].addressLineOne ?? '',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(
                              () => Visibility(
                                visible: !parkingController
                                    .isIDontKnowParkingTime.value,
                                child: InkWell(
                                  onTap: () {
                                    if (parkingController
                                            .isIDontKnowParkingTime.value ==
                                        false) {
                                      if (parkingController
                                              .isIDontKnowParkingTime.value ==
                                          false) {
                                        AppBottomSheet().selectHoursBottomSheet(
                                            null,
                                            context: context,
                                            controller: parkingController);
                                      }
                                    }
                                  },
                                  child: SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: AppLabel(
                                            text:
                                                "How long are you parking for?",
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8),
                                          child: InkWell(
                                            onTap: () {
                                              print(bookingDetail
                                                  ?.carPark?.first.currency);
                                              if (bookingDetail?.carPark?.first
                                                      .currency ==
                                                  'LKR') {
                                                bookingController.baseUrl
                                                    .value = Constant.slUrl;
                                              } else {
                                                bookingController.baseUrl
                                                    .value = Constant.ukUrl;
                                              }

                                              print(bookingController.baseUrl);

                                              if (parkingController
                                                      .isIDontKnowParkingTime
                                                      .value ==
                                                  false) {
                                                if (parkingController
                                                        .isIDontKnowParkingTime
                                                        .value ==
                                                    false) {
                                                  AppBottomSheet()
                                                      .selectHoursBottomSheet(
                                                          bookingDetail
                                                              ?.carParkId,
                                                          context: context,
                                                          controller:
                                                              parkingController);
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Obx(() {
                                                  return AppLabel(
                                                    text: parkingController
                                                        .showHowLongParking
                                                        .value,
                                                    fontSize: 14,
                                                    textColor: AppColors
                                                        .appColorLightGray,
                                                  );
                                                }),
                                                const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: AppColors.appColorGray,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Divider(
                                            thickness: 1,
                                            color: AppColors.appColorLightGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Obx(() {
                            //   return Visibility(
                            //     visible: parkingController
                            //             .showHowLongParking.value.isNotEmpty
                            //         ? false
                            //         : true,
                            //     child: Row(
                            //       children: [
                            //         Obx(() {
                            //           return Checkbox(
                            //               value: parkingController
                            //                   .isIDontKnowParkingTime.value,
                            //               onChanged: (value) {
                            //                 parkingController
                            //                     .isIDontKnowParkingTime
                            //                     .value = value!;

                            //                 parkingController
                            //                     .isIDontKnowParkingTime
                            //                     .value = value;
                            //               });
                            //         }),
                            //         AppLabel(
                            //           text:
                            //               "I don’t know how long I'm parking for",
                            //           fontSize: 14,
                            //         )
                            //       ],
                            //     ),
                            //   );
                            // }),
                            Obx(() {
                              return Visibility(
                                visible: parkingController
                                        .showHowLongParking.value.isEmpty
                                    ? false
                                    : true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppColors
                                                    .appColorWhiteGray02)),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            AppLabel(
                                              text: "Park From",
                                              fontSize: 14,
                                              textColor: AppColors.appColorGray,
                                            ),
                                            Obx(() {
                                              return AppLabel(
                                                text: parkingController
                                                    .showParkingFrom.value,
                                                fontWeight: FontWeight.bold,
                                              );
                                            }),
                                            AppLabel(
                                              text: parkingController
                                                          .parkingFromTime ==
                                                      null
                                                  ? ""
                                                  : "${parkingController.parkingFromTime!.day} ${parkingController.getMonth(parkingController.parkingFromTime!.month)} ${parkingController.getFormattedDay(parkingController.parkingFromTime!)}",
                                              fontSize: 14,
                                              textColor: AppColors.appColorGray,
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
                                          child: InkWell(
                                        onTap: () {
                                          AppBottomSheet()
                                              .selectHoursBottomSheet(null,
                                                  context: context,
                                                  controller:
                                                      parkingController);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: AppColors
                                                      .appColorWhiteGray02)),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              AppLabel(
                                                text: "Park Until",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.appColorGray,
                                              ),
                                              Obx(() {
                                                return AppLabel(
                                                  text: parkingController
                                                      .showParkingUntil.value,
                                                  fontWeight: FontWeight.bold,
                                                );
                                              }),
                                              AppLabel(
                                                text: parkingController
                                                            .parkingUntilTime ==
                                                        null
                                                    ? ""
                                                    : "${parkingController.parkingUntilTime!.day} ${parkingController.getMonth(parkingController.parkingUntilTime!.month)} ${parkingController.getFormattedDay(parkingController.parkingUntilTime!)}",
                                                fontSize: 14,
                                                textColor:
                                                    AppColors.appColorGray,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Obx(
                              () => Visibility(
                                visible: !parkingController
                                    .isIDontKnowParkingTime.value,
                                child: Container(
                                  color: AppColors.appColorLightGray
                                      .withOpacity(0.2),
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Obx(() {
                                        return AppLabel(
                                            text: parkingController
                                                    .showTotalDuration
                                                    .value
                                                    .isEmpty
                                                ? " "
                                                : parkingController
                                                    .showTotalDuration.value);
                                      }),
                                      AppLabel(
                                        text: "Total duration",
                                        fontSize: 14,
                                        textColor: AppColors.appColorLightGray,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: parkingController.isAvalabilityOfTimeSlot.value,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Parking Chargers",
                                  textColor: AppColors.appColorLightGray,
                                  fontSize: 14,
                                ),
                                Obx(
                                  () => AppLabel(
                                    text:
                                        '${bookingDetail?.carPark?.first.currency}${parkingController.parkingFee.value.data?.price?.parkingFee?.toStringAsFixed(2) ?? ''}',
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    AppLabel(
                                      text: "Service fee",
                                      textColor: AppColors.appColorLightGray,
                                      fontSize: 14,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          infoBottomSheet(
                                              context,
                                              bottomSheetTitle = "Service fee",
                                              bottomSheetBodyText =
                                                  "Service fees is cost of running the platform and providing customer support on your booking.");
                                        },
                                        child: const Icon(
                                          Icons.info,
                                          size: 18,
                                          color: AppColors.appColorLightGray,
                                        ))
                                  ],
                                ),
                                Obx(
                                  () => AppLabel(
                                    text:
                                        '${bookingDetail?.carPark?.first.currency}${parkingController.parkingFee.value.data?.price?.serviceFee?.toStringAsFixed(2) ?? ''}',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 16.0),
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           AppLabel(text: 'Add promo code:'),
                          //         ],
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //         height: 60,
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(5),
                          //             border: Border.all(
                          //                 color: AppColors.appColorGreen)),
                          //         child: Padding(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //           child: Row(children: [
                          //             Expanded(
                          //                 flex: 3,
                          //                 child: TextFormField(
                          //                   controller: promoCodeController,
                          //                   keyboardType: TextInputType.phone,
                          //                   onChanged: (value) {
                          //                     if (value.isNotEmpty) {
                          //                       promoCodeButtonState.value =
                          //                           true;
                          //                     } else {
                          //                       promoCodeButtonState.value =
                          //                           false;
                          //                     }
                          //                   },
                          //                   decoration: const InputDecoration(
                          //                       border: InputBorder.none,
                          //                       hintText: 'Enter code'),
                          //                 )),
                          //             Expanded(
                          //                 flex: 1,
                          //                 child: CustomFilledButton(
                          //                   bgColor: promoCodeButtonState.value
                          //                       ? AppColors.appColorBlack
                          //                       : AppColors.appColorGray03,
                          //                   height: 40,
                          //                   clickEvent:
                          //                       promoCodeButtonState.value
                          //                           ? () {}
                          //                           : () {},
                          //                   text: 'Apply',
                          //                 ))
                          //           ]),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       InkWell(
                          //         onTap: (() {
                          //           print('object');
                          //         }),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             const Icon(Icons.confirmation_num,
                          //                 color: AppColors.appColorGray03),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             AppLabel(
                          //               text: 'Cancel adding promo code',
                          //               fontSize: 15,
                          //               textColor: AppColors.appColorGoogleRed,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       AppLabel(
                          //         text: 'Or',
                          //         textColor: AppColors.appColorBlack,
                          //       ),
                          //       InkWell(
                          //         onTap: () => Get.to(const AppQrScanner()),
                          //         child: AppLabel(
                          //           text: 'Scan QR',
                          //           textColor: AppColors.appColorBlack,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(
                              height: 2,
                              color: AppColors.appColorLightGray,
                              endIndent: 10,
                              indent: 10),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Total Parking Fee",
                                  fontSize: 15,
                                ),
                                Obx(
                                  () => AppLabel(
                                    text:
                                        '${bookingDetail?.carPark?.first.currency}${parkingController.parkingFee.value.data?.price?.total?.toStringAsFixed(2) ?? ''}',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(
                            thickness: 1,
                            endIndent: 10,
                            indent: 10,
                            color: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppLabel(text: "Vehicle"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        if (SharedPref.isGuestAccount()) {
                          Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
                        } else {
                          // ignore: prefer_is_empty
                          if (userController.vehicles?.value?.data?.length ==
                              0) {
                            Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                                arguments: Get.previousRoute);
                          } else {
                            Get.toNamed(Routes.MY_VEHICLES_SCREEN);
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.car,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Obx(
                                      () => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              AppLabel(
                                                  fontSize: 14,
                                                  text: userController
                                                          .selectedVehicle
                                                          ?.value
                                                          ?.vRN ??
                                                      'Add Vehicle'),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              AppLabel(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  text: userController
                                                          .selectedVehicle
                                                          ?.value
                                                          ?.model ??
                                                      ''),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              AppLabel(
                                                  fontSize: 10,
                                                  textColor:
                                                      AppColors.appColorGray03,
                                                  text: userController
                                                          .selectedVehicle
                                                          ?.value
                                                          ?.color ??
                                                      ''),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              AppLabel(
                                                  fontSize: 10,
                                                  textColor:
                                                      AppColors.appColorGray03,
                                                  text: userController
                                                              .selectedVehicle
                                                              ?.value
                                                              ?.fuelType !=
                                                          null
                                                      ? '(${userController.selectedVehicle?.value?.fuelType ?? ''})'
                                                      : '')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.penToSquare),
                                  onPressed: () {
                                    if (SharedPref.isGuestAccount()) {
                                      Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
                                    } else {
                                      // ignore: prefer_is_empty
                                      if (userController
                                              .vehicles?.value?.data?.length ==
                                          0) {
                                        Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                                            arguments: Get.previousRoute);
                                      } else {
                                        Get.toNamed(Routes.MY_VEHICLES_SCREEN);
                                      }
                                    }
                                  })
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppLabel(text: "Payments"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        if (SharedPref.isGuestAccount()) {
                          AppBottomSheet().signUpBottomSheet(context);
                        } else {
                          if (userController.selectedVehicle == null) {
                            AppCustomToast.warningToast(
                                'Please Add Vehicle To Continue');
                          } else {
                            if (parkingController
                                    .parkingFee.value.data?.carpark?.currency ==
                                'LKR') {
                              if (userController.selectedCard.value?.ccNumber ==
                                  null) {
                                parkingController.payHereDraftBooking(
                                    context: context,
                                    parkingFromTime: parkingController
                                        .parkingFromTime!
                                        .millisecondsSinceEpoch,
                                    parkingUntilTime: parkingController
                                        .parkingUntilTime!
                                        .millisecondsSinceEpoch,
                                    ctrl: parkingController);
                              } else {
                                Get.toNamed(arguments: [
                                  'parkNow',
                                  '',
                                  '',
                                  parkingController
                                      .parkingFee.value.data?.carpark?.currency
                                ], Routes.PAYMENT_OPTION_SCREEN);
                              }
                            } else {
                              if (userController.selectedCard.value?.ccNumber ==
                                  null) {
                                Get.to(NmiPaymentScreen(
                                  price: parkingController
                                      .parkingFee.value.data!.price!.total!
                                      .toStringAsFixed(2),
                                  bookigType: '',
                                  parkingType: 'parkNow',
                                ));
                              } else {
                                Get.toNamed(arguments: [
                                  'parkNow',
                                  '',
                                  '',
                                  parkingController
                                      .parkingFee.value.data?.carpark?.currency
                                ], Routes.PAYMENT_OPTION_SCREEN);
                              }
                            }
                          }
                        }
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              if (SharedPref.isGuestAccount()) {
                                                AppBottomSheet()
                                                    .signUpBottomSheet(context);
                                              } else {
                                                if (userController
                                                        .selectedVehicle ==
                                                    null) {
                                                  AppCustomToast.warningToast(
                                                      'Please Add Vehicle To Continue');
                                                } else {
                                                  if (parkingController
                                                          .parkingFee
                                                          .value
                                                          .data
                                                          ?.carpark
                                                          ?.currency ==
                                                      'LKR') {
                                                    if (userController
                                                            .selectedCard
                                                            .value
                                                            ?.ccNumber ==
                                                        null) {
                                                      parkingController.payHereDraftBooking(
                                                          context: context,
                                                          parkingFromTime:
                                                              parkingController
                                                                  .parkingFromTime!
                                                                  .millisecondsSinceEpoch,
                                                          parkingUntilTime:
                                                              parkingController
                                                                  .parkingUntilTime!
                                                                  .millisecondsSinceEpoch,
                                                          ctrl:
                                                              parkingController);
                                                    } else {
                                                      Get.toNamed(
                                                          arguments: [
                                                            'parkNow',
                                                            '',
                                                            parkingController
                                                                .parkingFee
                                                                .value
                                                                .data!
                                                                .price!
                                                                .total!
                                                                .toStringAsFixed(
                                                                    2),
                                                            parkingController
                                                                .parkingFee
                                                                .value
                                                                .data
                                                                ?.carpark
                                                                ?.currency
                                                          ],
                                                          Routes
                                                              .PAYMENT_OPTION_SCREEN);
                                                    }
                                                  } else {
                                                    if (userController
                                                            .selectedCard
                                                            .value
                                                            ?.ccNumber ==
                                                        null) {
                                                      Get.to(NmiPaymentScreen(
                                                        price: parkingController
                                                            .parkingFee
                                                            .value
                                                            .data!
                                                            .price!
                                                            .total!
                                                            .toStringAsFixed(2),
                                                        bookigType: '',
                                                        parkingType: 'parkNow',
                                                      ));
                                                    } else {
                                                      Get.toNamed(
                                                          arguments: [
                                                            'parkNow',
                                                            '',
                                                            parkingController
                                                                .parkingFee
                                                                .value
                                                                .data!
                                                                .price!
                                                                .total!
                                                                .toStringAsFixed(
                                                                    2),
                                                            parkingController
                                                                .parkingFee
                                                                .value
                                                                .data
                                                                ?.carpark
                                                                ?.currency
                                                          ],
                                                          Routes
                                                              .PAYMENT_OPTION_SCREEN);
                                                    }
                                                  }
                                                }
                                              }
                                            },
                                            child: userController
                                                        .selectedCard.value ==
                                                    null
                                                ? Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      AppLabel(
                                                        text: "Add Payment",
                                                        fontSize: 14,
                                                        textColor: AppColors
                                                            .appColorBlack,
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      const Icon(
                                                          FontAwesomeIcons
                                                              .creditCard,
                                                          size: 20,
                                                          color: AppColors
                                                              .appColorBlack),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        userController
                                                                .selectedCard
                                                                .value
                                                                ?.ccNumber
                                                                ?.replaceRange(
                                                                    4, 4, ' ')
                                                                .replaceRange(
                                                                    9, 9, ' ')
                                                                .replaceRange(
                                                                    14,
                                                                    14,
                                                                    ' ') ??
                                                            '',
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .appColorGray,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          child: const FaIcon(
                                              FontAwesomeIcons.penToSquare),
                                          onTap: () {
                                            if (SharedPref.isGuestAccount()) {
                                              AppBottomSheet()
                                                  .signUpBottomSheet(context);
                                            } else {
                                              if (userController
                                                      .selectedVehicle?.value ==
                                                  null) {
                                                AppCustomToast.warningToast(
                                                    'Please Add Vehicle To Continue');
                                              } else {
                                                if (parkingController
                                                        .parkingFee
                                                        .value
                                                        .data
                                                        ?.carpark
                                                        ?.currency ==
                                                    'LKR') {
                                                  if (userController
                                                          .selectedCard
                                                          .value
                                                          ?.ccNumber ==
                                                      null) {
                                                    parkingController.payHereDraftBooking(
                                                        context: context,
                                                        parkingFromTime:
                                                            parkingController
                                                                .parkingFromTime!
                                                                .millisecondsSinceEpoch,
                                                        parkingUntilTime:
                                                            parkingController
                                                                .parkingUntilTime!
                                                                .millisecondsSinceEpoch,
                                                        ctrl:
                                                            parkingController);
                                                  } else {
                                                    Get.toNamed(
                                                        arguments: [
                                                          'parkNow',
                                                          '',
                                                          parkingController
                                                              .parkingFee
                                                              .value
                                                              .data!
                                                              .price!
                                                              .total!
                                                              .toStringAsFixed(
                                                                  2),
                                                          parkingController
                                                              .parkingFee
                                                              .value
                                                              .data
                                                              ?.carpark
                                                              ?.currency
                                                        ],
                                                        Routes
                                                            .PAYMENT_OPTION_SCREEN);
                                                  }

                                                  // startOneTimePayment(context);
                                                } else {
                                                  if (userController
                                                          .selectedCard
                                                          .value
                                                          ?.ccNumber ==
                                                      null) {
                                                    Get.to(NmiPaymentScreen(
                                                      price: parkingController
                                                          .parkingFee
                                                          .value
                                                          .data!
                                                          .price!
                                                          .total!
                                                          .toStringAsFixed(2),
                                                      bookigType: '',
                                                      parkingType: 'parkNow',
                                                    ));
                                                  } else {
                                                    Get.toNamed(
                                                        arguments: [
                                                          'parkNow',
                                                          '',
                                                          parkingController
                                                              .parkingFee
                                                              .value
                                                              .data!
                                                              .price!
                                                              .total!
                                                              .toStringAsFixed(
                                                                  2),
                                                          parkingController
                                                              .parkingFee
                                                              .value
                                                              .data
                                                              ?.carpark
                                                              ?.currency
                                                        ],
                                                        Routes
                                                            .PAYMENT_OPTION_SCREEN);
                                                  }
                                                }
                                              }
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        AppLabel(
                          text: "Cancellation policy",
                          textColor: AppColors.appColorLightGray,
                          fontSize: 14,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                            onTap: () {
                              infoBottomSheet(
                                  context,
                                  bottomSheetTitle = "Cancellation policy",
                                  bottomSheetBodyText =
                                      "By making a booking or reservation on our Mobile, Website or Call to Park, you accept and agree to the relevant parking booking conditions, including cancellation and no-show policies. Please refer to the Terms & Conditions Above for more details.\n\n•	Within 24 hours of the time when the parking session is due to start no refund will be issued.\n\n•	At least 24 hours before the time when the parking session is due to start full refund without the service fee.\n\n•	After the parking session has started no refund will be issued.");
                            },
                            child: const Icon(
                              Icons.info,
                              size: 18,
                              color: AppColors.appColorLightGray,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: AppColors.appColorWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                  ),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Obx(() {
                return CustomFilledButton(
                    btnController: userController.selectedVehicle?.value?.vRN !=
                            null &&
                        parkingController.parkingFee.value.data?.price?.total !=
                            null,
                    text: parkingController.isIDontKnowParkingTime.value
                        ? "Start Parking"
                        : "Confirm",
                    bgColor:
                        userController.selectedVehicle?.value?.vRN != null &&
                                parkingController
                                        .parkingFee.value.data?.price?.total !=
                                    null
                            ? AppColors.appColorBlack
                            : AppColors.appColorLightGray,
                    clickEvent: () {
                      if (parkingController.isIDontKnowParkingTime.value) {
                        if (SharedPref.isGuestAccount()) {
                          AppBottomSheet().signUpBottomSheet(context);
                        } else {
                          if (userController.selectedCard.value?.ccNumber !=
                              null) {
                            parkingController.checkIdontKnowParkingBooking(
                                ctrl: parkingController,
                                context: context,
                                parkingFromTime:
                                    DateTime.now().millisecondsSinceEpoch);
                          } else {
                            AppCustomToast.warningToast(
                                'Please select valid payment method');
                          }
                        }
                      } else {
                        if (SharedPref.isGuestAccount()) {
                          AppBottomSheet().signInBottomSheet(context);
                        } else {
                          if (userController.selectedCard.value?.ccNumber !=
                              null) {
                            parkingController.parkAgainDraftBooking(
                                currency:
                                    bookingDetail?.carPark?.first.currency,
                                ctrl: parkingController,
                                context: context,
                                parkingFromTime: parkingController
                                    .parkingFromTime!.millisecondsSinceEpoch,
                                parkingUntilTime: parkingController
                                    .parkingUntilTime!.millisecondsSinceEpoch);
                          } else {
                            AppCustomToast.warningToast(
                                'Please select valid payment method');
                          }
                        }
                      }
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }

  void infoBottomSheet(
      BuildContext context, bottomSheetTitle, bottomSheetBodyText) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(text: bottomSheetTitle),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppLabel(
              text: bottomSheetBodyText,
              textAlign: TextAlign.justify,
              fontSize: 12,
              textColor: AppColors.appColorGray,
            ),
          ),
          const SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
