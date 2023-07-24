import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Vehical.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../services/local/shared_pref.dart';

class ParkAgainScreen extends StatelessWidget {
  ParkAgainScreen({Key? key}) : super(key: key);

  var status = false.obs;
  String? bottomSheetTitle;
  String? bottomSheetBodyText;

  var userController = Get.find<UserController>();
  var parkingController = Get.put(ParkingNowController());
  var bookingController = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    parkingController.showHowLongParking.value = '';
    parkingController.showTotalDuration.value = '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
          "Duration",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1,
                  color: AppColors.appColorLightGray,
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LocationCodeView(
                    postCode: '',
                    parkingId: '${SharedPref.carParkPin() ?? '-'}',
                    parkName: SharedPref.getCarParkName() ?? '-',
                    city: SharedPref.getCity() ?? '-',
                    addressOne: '',
                    addressTow: '',
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AppLabel(
                              text: "How long are you parking for?",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: InkWell(
                              onTap: () {
                                if (parkingController
                                        .isIDontKnowParkingTime.value ==
                                    false) {
                                  if (parkingController
                                          .isIDontKnowParkingTime.value ==
                                      false) {
                                    AppBottomSheet()
                                        .parkAgainSelectHoursBottomSheet(
                                            context: context,
                                            controller: parkingController);
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return AppLabel(
                                      text: parkingController
                                          .showHowLongParking.value,
                                      fontSize: 14,
                                      textColor: AppColors.appColorLightGray,
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
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                              visible: parkingController
                                  .isAvalabilityOfTimeSlotParkAgain.value,
                              child: Row(
                                children: [
                                  Obx(() {
                                    return Checkbox(
                                        value: parkingController
                                            .isIDontKnowParkingTime.value,
                                        onChanged: (value) {
                                          parkingController
                                              .isIDontKnowParkingTime
                                              .value = value!;

                                          parkingController
                                              .isIDontKnowParkingTime
                                              .value = value;
                                        });
                                  }),
                                  AppLabel(
                                    text: "I don’t know how long I’m staying",
                                    fontSize: 14,
                                  )
                                ],
                              ),
                            );
                          }),
                          Obx(() {
                            return Visibility(
                              visible: parkingController
                                      .showHowLongParking.value.isEmpty
                                  ? false
                                  : true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                            text: "Parking From",
                                            fontSize: 14,
                                            textColor: AppColors.appColorGray,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Obx(() {
                                            return AppLabel(
                                              text: parkingController
                                                  .showParkingFrom.value,
                                              fontWeight: FontWeight.bold,
                                            );
                                          }),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          AppLabel(
                                            text: parkingController
                                                        .parkingUntilTime ==
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
                                            .parkAgainSelectHoursBottomSheet(
                                                context: context,
                                                controller: parkingController);
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
                                              text: "Parking Until",
                                              fontSize: 14,
                                              textColor: AppColors.appColorGray,
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Obx(() {
                                              return AppLabel(
                                                text: parkingController
                                                    .showParkingUntil.value,
                                                fontWeight: FontWeight.bold,
                                              );
                                            }),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            AppLabel(
                                              text: parkingController
                                                          .parkingUntilTime ==
                                                      null
                                                  ? ""
                                                  : "${parkingController.parkingUntilTime!.day} ${parkingController.getMonth(parkingController.parkingUntilTime!.month)} ${parkingController.getFormattedDay(parkingController.parkingUntilTime!)}",
                                              fontSize: 14,
                                              textColor: AppColors.appColorGray,
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
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            color: AppColors.appColorLightGray.withOpacity(0.2),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Column(
                              children: [
                                Obx(() {
                                  return AppLabel(
                                      text: parkingController
                                              .showTotalDuration.value.isEmpty
                                          ? "-"
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return Visibility(
                    visible: parkingController.showHowLongParking.value.isEmpty
                        ? false
                        : true,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      '\$ ${parkingController.parkingFee.value.data?.price?.parkingFee ?? ''}',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                            bottomSheetTitle =
                                                "Purpose of a service fee",
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
                                      '\$ ${parkingController.parkingFee.value.data?.price?.serviceFee ?? '-'}',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Visibility(
                            visible: parkingController.activeSMSReceipt.value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      AppLabel(
                                        text: "SMS fee",
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
                                                bottomSheetTitle =
                                                    "Purpose of a SMS fee",
                                                bottomSheetBodyText =
                                                    "SMS will be sent as soon as your payment is made for your booking. Additional service fee will be added.");
                                          },
                                          child: const Icon(
                                            Icons.info,
                                            size: 18,
                                            color: AppColors.appColorLightGray,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Obx(() {
                          return Visibility(
                            visible: parkingController.activeSMSReminder.value,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      AppLabel(
                                        text: "SMS reminder fee",
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
                                                bottomSheetTitle =
                                                    "Purpose of a SMS reminder fee",
                                                bottomSheetBodyText =
                                                    "SMS Reminder will send you SMS a few minutes before your parking session ends. For this service additional fee will be added.");
                                          },
                                          child: const Icon(
                                            Icons.info,
                                            size: 18,
                                            color: AppColors.appColorLightGray,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Total Parking Fee",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              Obx(
                                () => AppLabel(
                                  text:
                                      '\$ ${parkingController.parkingFee.value.data?.price?.total ?? '-'}',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          indent: 10,
                          color: AppColors.appColorLightGray,
                          endIndent: 10,
                        ),
                      ],
                    ),
                  );
                }),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppLabel(text: "Vehicle"),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Obx(
                                            () => Expanded(
                                              flex: 3,
                                              child: userController.vehicles
                                                              ?.value!.data !=
                                                          null &&
                                                      userController
                                                          .vehicles!
                                                          .value!
                                                          .data!
                                                          .isNotEmpty
                                                  ? DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .appColorBlack),
                                                        isExpanded: true,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        iconSize: 0,
                                                        hint: AppLabel(
                                                            text: userController
                                                                .dropDownShowValue
                                                                .value,
                                                            fontSize: 14),
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        items: userController
                                                            .vehicles!
                                                            .value!
                                                            .data!
                                                            .map((Vehicle
                                                                items) {
                                                          return DropdownMenuItem(
                                                              onTap: () {
                                                                userController
                                                                        .dropDownShowValue
                                                                        .value =
                                                                    '${items.vRN} - ${items.model}(${items.color})';
                                                              },
                                                              value: items.id,
                                                              child: Row(
                                                                children: [
                                                                  AppLabel(
                                                                      text: items
                                                                          .vRN!),
                                                                  AppLabel(
                                                                    text:
                                                                        ' - ${items.model}(${items.color})',
                                                                    fontSize:
                                                                        14,
                                                                  )
                                                                ],
                                                              ));
                                                        }).toList(),
                                                        onChanged: (newValue) {
                                                          userController
                                                                  .dropDownValue
                                                                  .value =
                                                              newValue
                                                                  .toString();
                                                        },
                                                      ),
                                                    )
                                                  : const Text('Add Vehicle'),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onPressed: () {
                              Get.toNamed(Routes.MY_VEHICLES_SCREEN);
                            },
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
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.moneyBill1,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AppLabel(
                                  text: "Select or Add payment method",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                )
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),
                //----->

                const SizedBox(
                  height: 16,
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            return CustomFilledButton(
                text: parkingController.isIDontKnowParkingTime.value
                    ? "Start Parking"
                    : "Confirm",
                bgColor: parkingController
                            .showHowLongParking.value.isNotEmpty ||
                        parkingController.isIDontKnowParkingTime.value == true
                    ? AppColors.appColorBlack
                    : AppColors.appColorLightGray,
                clickEvent: parkingController
                        .isAvalabilityOfTimeSlotParkAgain.value
                    ? () {
                        if (parkingController.isIDontKnowParkingTime.value) {
                          parkingController.checkIdontKnowParkingBooking(
                              ctrl: parkingController,
                              context: context,
                              parkingFromTime:
                                  DateTime.now().millisecondsSinceEpoch);
                        } else {
                          parkingController.draftBooking(
                              billingId: '',
                              cardType: '',
                              cavv: '',
                              directoryServerId: '',
                              eci: '',
                              firstName: '',
                              lastName: '',
                              paymentToken: '',
                              threeDsVersion: '',
                              ctrl: parkingController,
                              context: context,
                              parkingFromTime: parkingController
                                  .parkingFromTime!.millisecondsSinceEpoch,
                              parkingUntilTime: parkingController
                                  .parkingUntilTime!.millisecondsSinceEpoch);
                        }
                      }
                    : () {
                        print('object');
                      });
          }),
        )
      ]),
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
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(
              text: bottomSheetBodyText,
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
