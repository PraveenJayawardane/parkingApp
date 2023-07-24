import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/constant.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../services/local/shared_pref.dart';
import '../../../utils/app_bottom_sheets.dart';
import '../../../utils/app_custom_toast.dart';
import '../../../widgets/molecules/buttons/custom_filled_button.dart';
import '../../../widgets/molecules/buttons/ghost_button.dart';

class ExtendBookingDurationScreen extends StatefulWidget {
  final int? carParkPin;
  final String? carParkName;
  final String? city;
  final int? startTime;
  final String? vrn;
  final String? bookingId;
  final String? carParkId;
  final int? untilTime;
  final BuildContext buildContext;
  final String? model;
  final String? color;
  final String? fuelType;
  final String? postCode;
  final String? addressOne;
  final String? addressTwo;
  final String? currency;

  const ExtendBookingDurationScreen(
      {Key? key,
      required this.currency,
      required this.carParkPin,
      required this.carParkName,
      required this.city,
      required this.startTime,
      required this.carParkId,
      required this.vrn,
      this.bookingId,
      required this.untilTime,
      required this.buildContext,
      this.model,
      this.color,
      this.fuelType,
      this.postCode,
      this.addressOne,
      this.addressTwo})
      : super(key: key);

  @override
  State<ExtendBookingDurationScreen> createState() =>
      _ExtendBookingDurationScreenState();
}

class _ExtendBookingDurationScreenState
    extends State<ExtendBookingDurationScreen> {
  DateTime? startDateTime;

  DateTime? endDateTime;

  var showUntilDateTime = "".obs;

  var showTimeDuration = "".obs;

  var showUntilDurationDay = "".obs;

  var status = false.obs;

  String? bottomSheetTitle;

  String? bottomSheetBodyText;

  var userController = Get.find<UserController>();

  var parkingController = Get.put(ParkingNowController());

  var bookingController = Get.put(BookingController());
  @override
  void initState() {
    // TODO: implement initState
    setUrl();
    extendBookingCalculateBill();
    super.initState();
  }

  void setUrl() {
    if (widget.currency == 'LKR') {
      bookingController.baseUrl.value = Constant.slUrl;
    } else {
      bookingController.baseUrl.value = Constant.ukUrl;
    }
  }

  void extendBookingCalculateBill() {
    parkingController.showHowLongParking.value = '';
    parkingController.showTotalDuration.value = '';

    startDateTime = DateTime.fromMillisecondsSinceEpoch(widget.untilTime!);

    endDateTime = startDateTime!.add(const Duration(minutes: 15));

    var difference = endDateTime!.difference(startDateTime!).inMinutes;
    var hours = difference ~/ 60;
    var minutes = difference % 60;

    showUntilDateTime.value =
        "${endDateTime!.hour < 10 ? "0${endDateTime!.hour}" : endDateTime!.hour}:${endDateTime!.minute < 10 ? "0${endDateTime!.minute}" : endDateTime!.minute}";
    showTimeDuration.value =
        "${hours < 1 ? "" : "$hours Hours"} ${minutes < 1 ? "" : "$minutes Minutes"}";
    showUntilDurationDay.value =
        "${endDateTime!.day} ${getMonth(endDateTime!.month)} ${getFormattedDay(endDateTime!)}";
    bookingController.extendBookingCalculateBill(
        parkingId: widget.bookingId!,
        context: widget.buildContext,
        parkingFromTime: startDateTime!.millisecondsSinceEpoch,
        parkingUntilTime: endDateTime!.millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
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
                      postCode: widget.postCode ?? '-',
                      parkingId: '${widget.carParkPin ?? '-'}',
                      parkName: widget.carParkName ?? '-',
                      city: widget.city ?? '-',
                      addressOne: widget.addressOne ?? '',
                      addressTow: widget.addressTwo ?? '',
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
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color:
                                                AppColors.appColorWhiteGray02)),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        AppLabel(
                                          text: "Extend From",
                                          fontSize: 14,
                                          textColor: AppColors.appColorGray,
                                        ),
                                        AppLabel(
                                          text:
                                              "${startDateTime!.hour < 10 ? "0${startDateTime!.hour}" : startDateTime!.hour}:${startDateTime!.minute < 10 ? "0${startDateTime!.minute}" : startDateTime!.minute}",
                                          fontWeight: FontWeight.bold,
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
                                        border: Border.all(
                                            color:
                                                AppColors.appColorWhiteGray02)),
                                    child: InkWell(
                                      onTap: () {
                                        selectExtendBookingHoursBottomSheet(
                                            context);
                                      },
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AppLabel(
                                            text: "Extend Until",
                                            fontSize: 14,
                                            textColor: AppColors.appColorGray,
                                          ),
                                          Column(
                                            children: [
                                              Obx(() {
                                                return AppLabel(
                                                  text: showUntilDateTime.value,
                                                  fontWeight: FontWeight.bold,
                                                );
                                              }),
                                              Obx(() {
                                                return AppLabel(
                                                  text: showUntilDurationDay
                                                      .value,
                                                  fontSize: 14,
                                                  textColor:
                                                      AppColors.appColorGray,
                                                );
                                              }),
                                            ],
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
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              color:
                                  AppColors.appColorLightGray.withOpacity(0.2),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  Obx(() {
                                    return AppLabel(
                                        text: showTimeDuration.isEmpty
                                            ? "-"
                                            : showTimeDuration.value);
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
                  Obx(() {
                    if (!bookingController.extendBookingHasPrice.value) {
                      return Container();
                    } else {
                      return Visibility(
                        visible:
                            !bookingController.extendBookingPriceLoading.value,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Parking Fee",
                                    textColor: AppColors.appColorLightGray,
                                    fontSize: 14,
                                  ),
                                  AppLabel(
                                    text:
                                        '${bookingController.extendParkingFee.currency}${bookingController.extendParkingFee.parkingCharges?.toStringAsFixed(2) ?? '-'}',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),

                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 16.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           AppLabel(
                            //             text: "Service fee",
                            //             textColor: AppColors.appColorLightGray,
                            //             fontSize: 14,
                            //           ),
                            //           const SizedBox(
                            //             width: 8,
                            //           ),
                            //           GestureDetector(
                            //               onTap: () {
                            //                 infoBottomSheet(
                            //                     context,
                            //                     bottomSheetTitle =
                            //                         "Purpose of a service fee",
                            //                     bottomSheetBodyText =
                            //                         "Service fees is cost of running the platform and providing customer support on your booking.");
                            //               },
                            //               child: const Icon(
                            //                 Icons.info,
                            //                 size: 18,
                            //                 color: AppColors.appColorLightGray,
                            //               ))
                            //         ],
                            //       ),
                            //       AppLabel(
                            //         text:
                            //             '£${bookingController.extendParkingFee.serviceFee?.toStringAsFixed(2) ?? '-'}',
                            //         fontSize: 14,
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Total Parking Fee",
                                    fontSize: 15,
                                  ),
                                  AppLabel(
                                    text:
                                        '${bookingController.extendParkingFee.currency}${bookingController.extendParkingFee.newTotalParkingFee?.toStringAsFixed(2) ?? '-'}',
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.car,
                                    color: AppColors.appColorGray,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLabel(
                                          text:
                                              '${widget.vrn ?? ''}  ${widget.model ?? ''}' /*booking.vehicleNumberPlate!*/,
                                          fontSize: 14),
                                      Row(
                                        children: [
                                          AppLabel(
                                              text:
                                                  '${widget.color ?? ''} ' /*booking.vehicleNumberPlate!*/,
                                              fontSize: 12,
                                              textColor:
                                                  AppColors.appColorLightGray),
                                          AppLabel(
                                              text: widget.fuelType != null
                                                  ? '(${widget.fuelType ?? ''} )'
                                                  : '' /*booking.vehicleNumberPlate!*/,
                                              fontSize: 12,
                                              textColor:
                                                  AppColors.appColorLightGray),
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
                    child: InkWell(
                      onTap: () {
                        if (SharedPref.isGuestAccount()) {
                          AppBottomSheet().signUpBottomSheet(context);
                        } else {
                          // Get.toNamed(
                          //     arguments: ['', ''],
                          //     Routes.PAYMENT_OPTION_SCREEN);
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
                                              // Get.toNamed(
                                              //     arguments: ['', ''],
                                              //     Routes
                                              //         .ADD_PAYMENT_METHOD_SCREEN);
                                            },
                                            child: userController
                                                        .selectedCard.value ==
                                                    null
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                          color: AppColors
                                                              .appColorBlack,
                                                        )),
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .googlePay,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      AppLabel(
                                                        text: "GOOGLE PAY",
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
                                                                .cardList
                                                                .value
                                                                .first
                                                                .ccNumber
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
                                        // InkWell(
                                        //   child: const FaIcon(
                                        //       FontAwesomeIcons.penToSquare),
                                        //   onTap: () {
                                        //     if (SharedPref.isGuestAccount()) {
                                        //       AppBottomSheet()
                                        //           .signUpBottomSheet(context);
                                        //     } else {
                                        //       // Get.toNamed(
                                        //       //     arguments: ['', ''],
                                        //       //     Routes.PAYMENT_OPTION_SCREEN);
                                        //     }
                                        //   },
                                        // ),
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
                          const SizedBox(
                            height: 8,
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
                    height: 20,
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
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: Obx(
                  () => CustomFilledButton(
                      btnController:
                          bookingController.extendBookingHasPrice.value,
                      text: "Confirm",
                      bgColor: AppColors.appColorBlack,
                      clickEvent: () {
                        if (userController.cardList.value.first.ccNumber !=
                            null) {
                          if (bookingController
                                  .extendParkingFee.redirectToPaymentGateway ==
                              true) {
                            parkingController.draftExtendBooking(
                                cardType: bookingController
                                    .extendParkingFee.currency!,
                                context: context,
                                id: widget.bookingId!,
                                bookingEnd:
                                    endDateTime!.millisecondsSinceEpoch);
                          } else {
                            parkingController.extendBookigWithoutPaymentGateway(
                                context: context,
                                id: widget.bookingId!,
                                bookingEnd:
                                    endDateTime!.millisecondsSinceEpoch);
                          }
                        } else {
                          AppCustomToast.warningToast(
                              'Please select valid payment method');
                        }
                      }),
                )),
          ),
        ],
      ),
    );
  }

  void selectExtendBookingHoursBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park Until",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Done",
                  clickEvent: () {
                    bookingController.extendBookingCalculateBill(
                        parkingId: widget.bookingId!,
                        context: context,
                        parkingFromTime: startDateTime!.millisecondsSinceEpoch,
                        parkingUntilTime: endDateTime!.millisecondsSinceEpoch);
                    Get.back();
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate:
                            startDateTime!.add(const Duration(minutes: 30)),
                        maximumDate:
                            startDateTime!.add(const Duration(days: 30)),
                        initialDateTime:
                            startDateTime!.add(const Duration(minutes: 30)),
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          endDateTime = pickedDateTime;
                          showUntilDateTime.value =
                              "${endDateTime!.hour < 10 ? "0${endDateTime!.hour}" : endDateTime!.hour}:${endDateTime!.minute < 10 ? "0${endDateTime!.minute}" : endDateTime!.minute}";

                          var difference =
                              endDateTime!.difference(startDateTime!).inMinutes;
                          var hours = difference ~/ 60;
                          var minutes = difference % 60;

                          showTimeDuration.value =
                              "${hours < 1 ? "" : "$hours Hours"} ${minutes < 1 ? "" : "$minutes Minutes"}";
                          showUntilDurationDay.value =
                              "${endDateTime!.day} ${getMonth(endDateTime!.month)} ${getFormattedDay(endDateTime!)}";
                        })),
                  ),
                ),
              ),
            ],
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

  String getMonth(int monthNo) {
    String pickedMon = "";
    var months = {
      1: "January",
      2: "February",
      3: "March",
      4: "April",
      5: "May",
      6: "June",
      7: "July",
      8: "August",
      9: "September",
      10: "October",
      11: "November",
      12: "December",
    };

    months.forEach((key, value) {
      if (key == monthNo) {
        pickedMon = value;
      }
    });

    return pickedMon;
  }

  String? getFormattedDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final parkingDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (parkingDay == today) {
      return '';
    } else if (parkingDay == tomorrow) {
      return '';
    } else {
      return "";
    }
  }
}
