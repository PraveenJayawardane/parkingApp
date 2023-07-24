import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/park_later_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/constant.dart';
import '../constants/routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/network_controller.dart';
import '../controllers/park_now_controller.dart';
import '../model/fixed_duration_booking.dart';
import '../model/park_again.dart';
import '../screens/parking/park_later/park_later_booked_details_screen.dart';
import '../screens/parking/park_now/park_now_fixed_duration_booked_details_screen.dart';
import '../services/local/shared_pref.dart';
import '../widgets/atoms/app_heading.dart';
import '../widgets/atoms/app_label.dart';
import '../widgets/molecules/buttons/ghost_button.dart';
import '../widgets/molecules/input_fields/app_email_&_password_field.dart';
import '../widgets/molecules/input_fields/app_input_field.dart';
import '../widgets/molecules/input_fields/app_password_field.dart';
import 'app_custom_toast.dart';
import 'app_overlay.dart';
import 'package:intl/intl.dart';

class AppBottomSheet {
  var networkController = Get.find<NetworkController>();
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();

  void accessControlBottomSheet(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [AppLabel(text: "Access Control")],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appColorGreen),
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/open_barrier.png"),
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: AppLabel(
                              text: "Open entry/exit barrier",
                              fontSize: 10,
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appColorGoogleRed),
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/close_barrier.png"),
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: AppLabel(
                              text: "Close entry/exit barrier",
                              fontSize: 10,
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appColorGreen),
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/open_door.png"),
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: AppLabel(
                              text: "Open pedestrian door",
                              fontSize: 10,
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void selectHoursBottomSheet(String? id,
      {required BuildContext context,
      required ParkingNowController controller}) {
    int selectedFixedTime = 0;
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AppLabel(
                  text: "      ",
                ),
                const Spacer(),
                AppLabel(
                  text: "Set Duration",
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
            color: AppColors.appColorGray,
          ),
          const SizedBox(
            height: 30,
          ),
          AppLabel(text: "Select hours"),
          const SizedBox(
            height: 20,
          ),
          GroupButton(
            isRadio: true,
            onSelected: (val, index, isSelected) {
              selectedFixedTime = index + 1;
              if (selectedFixedTime > 0) {
                var parkUntil =
                    DateTime.now().add(Duration(hours: selectedFixedTime));
                controller.parkingFromTime = DateTime.now();
                controller.parkingUntilTime = parkUntil;
                print(parkUntil.day);
                print(DateTime.now().day);
                controller.showHowLongParking.value = parkUntil.day ==
                        DateTime.now().day
                    ? "Until ${parkUntil.hour}:${parkUntil.minute < 10 ? '0${parkUntil.minute}' : parkUntil.minute} Today"
                    : "Until ${parkUntil.hour}:${parkUntil.minute < 10 ? '0${parkUntil.minute}' : parkUntil.minute} ${parkUntil.day} ${parkUntil.month}  ";
                controller.showParkingFrom.value =
                    "${controller.parkingFromTime?.hour}:${controller.parkingFromTime!.minute < 10 ? '0${controller.parkingFromTime?.minute}' : controller.parkingFromTime?.minute}";
                controller.showParkingUntil.value =
                    "${controller.parkingUntilTime?.hour}:${controller.parkingUntilTime!.minute < 10 ? '0${controller.parkingUntilTime?.minute}' : controller.parkingUntilTime?.minute}";
                controller.showTotalDuration.value = "$selectedFixedTime Hours";

                //add api call
                print(controller.parkingFromTime!);
                print(controller.parkingUntilTime);

                ParkingNowController().calculateBill(id,
                    ctrl: controller,
                    context: context,
                    parkingFromTime:
                        controller.parkingFromTime!.millisecondsSinceEpoch,
                    parkingUntilTime:
                        controller.parkingUntilTime!.millisecondsSinceEpoch);

                Get.back();
              }
            },
            buttons: const ["1hr", "2hr", "3hr", "4hr", "5hr"],
            options: GroupButtonOptions(
              selectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorWhite,
              ),
              selectedColor: AppColors.appColorBlack,
              unselectedColor: AppColors.appColorWhite,
              unselectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorGray,
              ),
              selectedBorderColor: AppColors.appColorGray,
              unselectedBorderColor:
                  AppColors.appColorLightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
              spacing: 10,
              runSpacing: 10,
              groupingType: GroupingType.wrap,
              direction: Axis.horizontal,
              buttonHeight: 40,
              buttonWidth: 40,
              textAlign: TextAlign.center,
              textPadding: EdgeInsets.zero,
              alignment: Alignment.center,
              elevation: 0,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomFilledButton(
                text: "Set Custom Duration",
                clickEvent: () {
                  Get.back();
                  setCustomDuration(id,
                      context: context,
                      startDate:
                          DateTime.now().add(const Duration(minutes: 15)),
                      endDate: DateTime.now().add(const Duration(days: 14)),
                      controller: controller);
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void amendBookingselectHoursBottomSheet(
      {required BuildContext context,
      String? bookingId,
      required ParkingNowController controller}) {
    setAmendCustomDuration(
        bookinId: bookingId!,
        context: context,
        startDate: DateTime.now().add(const Duration(minutes: 15)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        controller: controller);
  }

  void amendBookingselectHoursFromBottomSheet(
      {required BuildContext context,
      String? bookingId,
      required ParkingNowController controller}) {
    setAmendCustomDurationFromTime(
        bookinId: bookingId!,
        context: context,
        startDate: DateTime.now().add(const Duration(minutes: 15)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        controller: controller);
  }

  void selectExtendBookingHoursBottomSheet(
      {required BuildContext context,
      required String id,
      required String numberPlate,
      required int? startTime,
      required ParkingNowController controller}) {
    int selectedFixedTime = 0;
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AppLabel(
                  text: "      ",
                ),
                const Spacer(),
                AppLabel(
                  text: "Set Duration",
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      if (selectedFixedTime > 0) {
                        var parkUntil =
                            DateTime.fromMillisecondsSinceEpoch(startTime!)
                                .add(Duration(hours: selectedFixedTime));
                        controller.parkingFromTime = DateTime.now();
                        controller.parkingUntilTime = parkUntil;
                        controller.showHowLongParking.value =
                            "Until ${parkUntil.hour}:${parkUntil.minute < 10 ? '0${parkUntil.minute}' : parkUntil.minute} Today";
                        controller.showParkingFrom.value =
                            "${controller.parkingFromTime?.hour}:${controller.parkingFromTime!.minute < 10 ? '0${controller.parkingFromTime?.minute}' : controller.parkingFromTime?.minute}";
                        controller.showParkingUntil.value =
                            "${controller.parkingUntilTime?.hour}:${controller.parkingUntilTime!.minute < 10 ? '0${controller.parkingUntilTime?.minute}' : controller.parkingUntilTime?.minute}";
                        controller.showTotalDuration.value =
                            "$selectedFixedTime Hours";

                        ParkingNowController().extendBookingChecking(
                            context: context,
                            controller: controller,
                            id: id,
                            bookingEnd: controller
                                .parkingUntilTime!.millisecondsSinceEpoch);

                        Get.back();
                      }
                    },
                    child: AppLabel(
                      text: "Done",
                      textColor: AppColors.appColorLightBlue,
                      fontSize: 13,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
            color: AppColors.appColorGray,
          ),
          const SizedBox(
            height: 30,
          ),
          AppLabel(text: "Select hours"),
          const SizedBox(
            height: 20,
          ),
          GroupButton(
            isRadio: true,
            onSelected: (val, index, isSelected) {
              selectedFixedTime = index + 1;
            },
            buttons: const ["1hr", "2hr", "3hr", "4hr", "5hr"],
            options: GroupButtonOptions(
              selectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorWhite,
              ),
              selectedColor: AppColors.appColorBlack,
              unselectedColor: AppColors.appColorWhite,
              unselectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorGray,
              ),
              selectedBorderColor: AppColors.appColorGray,
              unselectedBorderColor:
                  AppColors.appColorLightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
              spacing: 10,
              runSpacing: 10,
              groupingType: GroupingType.wrap,
              direction: Axis.horizontal,
              buttonHeight: 40,
              buttonWidth: 40,
              textAlign: TextAlign.center,
              textPadding: EdgeInsets.zero,
              alignment: Alignment.center,
              elevation: 0,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomFilledButton(
                text: "Set Custom Duration",
                clickEvent: () {
                  Get.back();
                  setCustomDuration(null,
                      context: context,
                      startDate:
                          DateTime.now().add(const Duration(minutes: 15)),
                      endDate: DateTime.now().add(const Duration(hours: 24)),
                      controller: controller);
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void setCustomDuration(
    String? id, {
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required ParkingNowController controller,
  }) {
    DateTime pickedEndDateTime = startDate;
    DateTime pickedStartDateTime = DateTime.now();

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
                    // controller.showParkingFrom.value =
                    // "${controller.parkingFromTime?.hour}:${controller.parkingFromTime?.minute}";

                    controller.parkingFromTime = pickedStartDateTime;
                    controller.parkingUntilTime = pickedEndDateTime;

                    controller.showHowLongParking.value = pickedEndDateTime
                                .day ==
                            pickedStartDateTime.day
                        ? "Until ${DateFormat('HH:mm: a').format(pickedEndDateTime)}  Today"
                        : "Until ${DateFormat('EEEE MMMM dd HH:mm: a').format(pickedEndDateTime)}";

                    // controller.showHowLongParking.value =
                    //     "Until ${pickedEndDateTime.hour}:${pickedEndDateTime.minute < 10 ? '0${pickedEndDateTime.minute}' : pickedEndDateTime.minute} Today";
                    controller.showParkingFrom.value =
                        "${pickedStartDateTime.hour}:${pickedStartDateTime.minute < 10 ? '0${pickedStartDateTime.minute}' : pickedStartDateTime.minute}";

                    controller.showParkingUntil.value =
                        "${pickedEndDateTime.hour}:${pickedEndDateTime.minute < 10 ? '0${pickedEndDateTime.minute}' : pickedEndDateTime.minute}";

                    var deference = pickedEndDateTime
                            .difference(pickedStartDateTime)
                            .inMinutes +
                        1;
                    print(pickedStartDateTime);
                    print(pickedEndDateTime);
                    var hours = deference ~/ 60;
                    var minutes = deference % 60;
                    // print(deference);
                    // print(startDate.millisecondsSinceEpoch);
                    // print(pickedEndDateTime.millisecondsSinceEpoch);
                    controller.showTotalDuration.value =
                        "$hours Hours $minutes Minutes";

                    ParkingNowController().calculateBill(id,
                        ctrl: controller,
                        context: context,
                        parkingFromTime: startDate.millisecondsSinceEpoch,
                        parkingUntilTime:
                            pickedEndDateTime.millisecondsSinceEpoch);

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
                        minimumDate: startDate,
                        //DateTime.now(),
                        maximumDate: endDate,
                        //DateTime.now().add(const Duration(days: 30)),
                        initialDateTime: controller.parkingUntilTime,
                        //DateTime.now().add(const Duration(minutes: 15)),
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedTime) {
                          pickedEndDateTime = pickedTime;
                          //controller.parkingUntilTime = pickDateTime;

                          // controller.parkingFromDay =
                          //     DateTime(year, month, day);
                          // controller.parkingFromDayName = DateTime(month, day);
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

  void setAmendCustomDuration({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required String bookinId,
    required ParkingNowController controller,
  }) {
    DateTime pickedEndDateTime = controller.parkingUntilTime ??
        DateTime.now().add(const Duration(minutes: 15));
    DateTime pickedStartDateTime = DateTime.now();

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
                    // controller.showParkingFrom.value =
                    // "${controller.parkingFromTime?.hour}:${controller.parkingFromTime?.minute}";
                    // controller.parkingFromTime = pickedStartDateTime;
                    controller.parkingUntilTime = pickedEndDateTime;
                    // print(pickedEndDateTime);

                    // controller.showHowLongParking.value =
                    //     "Until ${pickedEndDateTime.hour}:${pickedEndDateTime.minute < 10 ? '0${pickedEndDateTime.minute}' : pickedEndDateTime.minute} Today";
                    // controller.showParkingFrom.value =
                    //     "${pickedStartDateTime.hour}:${pickedStartDateTime.minute < 10 ? '0${pickedStartDateTime.minute}' : pickedStartDateTime.minute}";

                    // controller.showParkingUntil.value =
                    //     "${pickedEndDateTime.hour}:${pickedEndDateTime.minute < 10 ? '0${pickedEndDateTime.minute}' : pickedEndDateTime.minute}";

                    controller.showParkingUntil.value =
                        "${getFormattedDay(pickedEndDateTime) != 'Today' ? pickedEndDateTime.day : ''} ${getFormattedDay(pickedEndDateTime) != 'Today' ? getMonth(pickedEndDateTime.month) : ''} ${getFormattedDay(pickedEndDateTime)} at ${pickedEndDateTime.hour < 10 ? "0${pickedEndDateTime.hour}" : pickedEndDateTime.hour} : ${pickedEndDateTime.minute < 10 ? "0${pickedEndDateTime.minute}" : pickedEndDateTime.minute}";

                    var deference = pickedEndDateTime
                        .difference(controller.parkingFromTime!)
                        .inMinutes;
                    var hours = deference ~/ 60;
                    var minutes = deference % 60;
                    print(deference);
                    controller.showTotalDuration.value =
                        "$hours Hours $minutes Minutes";

                    print(controller.parkingUntilTime!.millisecondsSinceEpoch);
                    print(controller.parkingFromTime!.millisecondsSinceEpoch);
                    print(bookinId);

                    bookingController.checkAmendBooking(
                        bookingId: bookinId,
                        context: context,
                        bookingEnd:
                            controller.parkingUntilTime!.millisecondsSinceEpoch,
                        bookingStart:
                            controller.parkingFromTime!.millisecondsSinceEpoch);

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
                        minimumDate: controller.parkingFromTime,
                        //DateTime.now(),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 30)),
                        initialDateTime: controller.parkingUntilTime!,
                        //DateTime.now().add(const Duration(minutes: 15)),
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedTime) {
                          pickedEndDateTime = pickedTime;
                          //controller.parkingUntilTime = pickDateTime;

                          // controller.parkingFromDay =
                          //     DateTime(year, month, day);
                          // controller.parkingFromDayName = DateTime(month, day);
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

  void setAmendCustomDurationFromTime({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required String bookinId,
    required ParkingNowController controller,
  }) {
    DateTime pickedEndDateTime = DateTime.now().add(const Duration(minutes: 5));

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
                  text: "Park From",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Next",
                  clickEvent: () {
                    //TODO
                    controller.parkingFromTime = pickedEndDateTime;

                    controller.showParkingFrom.value =
                        "${getFormattedDay(pickedEndDateTime) != 'Today' ? pickedEndDateTime.day : ''} ${getFormattedDay(pickedEndDateTime) != 'Today' ? getMonth(pickedEndDateTime.month) : ''} ${getFormattedDay(pickedEndDateTime)} at ${pickedEndDateTime.hour < 10 ? "0${pickedEndDateTime.hour}" : pickedEndDateTime.hour} : ${pickedEndDateTime.minute < 10 ? "0${pickedEndDateTime.minute}" : pickedEndDateTime.minute}";

                    Get.back();
                    AppBottomSheet().amendBookingselectHoursBottomSheet(
                        bookingId: bookinId,
                        context: context,
                        controller: controller);
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
                        minimumDate: DateTime.now(),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 30)),
                        initialDateTime: controller.parkingFromTime,
                        //DateTime.now().add(const Duration(minutes: 15)),
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedTime) {
                          pickedEndDateTime = pickedTime;
                          controller.parkingUntilTime =
                              pickedTime.add(const Duration(minutes: 15));

                          // controller.parkingFromDay =
                          //     DateTime(year, month, day);
                          // controller.parkingFromDayName = DateTime(month, day);
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

  void setCustomDurationParkLaterUntil({
    required BuildContext context,
    required ParkingLaterController controller,
  }) {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;

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
                    // ignore: deprecated_member_use
                    if (controller.parkingUntilTime.isNull) {
                      controller.showParkingUntil.value = '';
                      AppCustomToast.errorToast('Pick a Until time');
                    } else {
                      controller.showParkingUntil.value =
                          "${controller.parkingUntilTime?.hour}:${controller.parkingUntilTime?.minute}";
                    }
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
                        minimumDate: controller.parkingUntilTime!
                            .add(const Duration(minutes: 15)),
                        initialDateTime: controller.parkingUntilTime!
                            .add(const Duration(minutes: 15)),
                        maximumDate: controller.parkingUntilTime!
                            .add(const Duration(days: 30)),
                        use24hFormat: true,
                        onDateTimeChanged: ((pickDateTime) {
                          print(pickDateTime);
                          year = pickDateTime.year;
                          hours = pickDateTime.hour;
                          month = pickDateTime.month;
                          day = pickDateTime.day;
                          minutes = pickDateTime.minute;
                          controller.parkingUntilTime =
                              DateTime(year, month, day, hours, minutes);
                          controller.parkingUntilDay =
                              DateTime(year, month, day);
                          controller.parkingUntilDayName = DateTime(month, day);
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

  void stopBooKingConformation(
      {required BuildContext context, required Function onSuccess}) {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/parking_gate.png"),
              AppLabel(text: "Are you sure you want to stop parking?"),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomFilledButton(
                        text: "Yes",
                        clickEvent: () {
                          onSuccess();
                        })),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: BorderedButton(
                  text: "No",
                  clickEvent: () {
                    Get.back();
                  },
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  void bookingCancelingConfirmBottomSheet(
      {required BuildContext context,
      required String bookingId,
      required String reason}) {
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
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(
              text: "Are you sure you want to cancel the booking?",
              textColor: AppColors.appColorBlack01,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(
                text: "Yes",
                clickEvent: () {
                  Get.back();
                  bookingController.cancelBooking(
                      id: bookingId, context: context, reason: reason);
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BorderedButton(
                text: "No",
                borderColor: AppColors.appColorGray,
                clickEvent: () {
                  Get.back();
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void bookingCancelingReasonsBottomSheet(
      {required BuildContext context, required String bookingId}) {
    var q1 = false.obs;
    var q2 = false.obs;
    var q3 = false.obs;
    var q4 = false.obs;
    var q5 = false.obs;
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
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(
              text: "Help us understand the reason",
              fontWeight: FontWeight.w500,
              textColor: AppColors.appColorBlack01,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                      value: q1.value,
                      onChanged: (value) {
                        q1.value = value!;
                        q2.value = false;
                        q3.value = false;
                        q4.value = false;
                        q5.value = false;
                      });
                }),
                AppLabel(
                  text: "I changed my mind",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                      value: q2.value,
                      onChanged: (value) {
                        q2.value = value!;
                        q1.value = false;
                        q3.value = false;
                        q4.value = false;
                        q5.value = false;
                      });
                }),
                AppLabel(
                  text: "I need to change details of the booking",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                      value: q3.value,
                      onChanged: (value) {
                        q3.value = value!;
                        q2.value = false;
                        q1.value = false;
                        q4.value = false;
                        q5.value = false;
                      });
                }),
                AppLabel(
                  text: "Car breakdown",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                      value: q4.value,
                      onChanged: (value) {
                        q4.value = value!;
                        q2.value = false;
                        q3.value = false;
                        q1.value = false;
                        q5.value = false;
                      });
                }),
                AppLabel(
                  text: "Using public transport",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                      value: q5.value,
                      onChanged: (value) {
                        q5.value = value!;
                        q2.value = false;
                        q3.value = false;
                        q4.value = false;
                        q1.value = false;
                      });
                }),
                AppLabel(
                  text: "Other",
                  fontSize: 14,
                  textColor: AppColors.appColorBlack,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(
                text: "Done",
                clickEvent: () {
                  if (cancellationReason(
                          q1.value, q2.value, q3.value, q4.value, q5.value) !=
                      null) {
                    Get.back();
                    bookingCancelingConfirmBottomSheet(
                        reason: cancellationReason(
                            q1.value, q2.value, q3.value, q4.value, q5.value)!,
                        context: context,
                        bookingId: bookingId);
                  } else {
                    AppCustomToast.warningToast('Pleace Select Cancel Reason');
                  }
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  String? cancellationReason(bool q1, bool q2, bool q3, bool q4, bool q5) {
    if (q1) {
      return 'I changed my mind';
    } else if (q2) {
      return 'I need to change details of the booking';
    } else if (q3) {
      return 'Car breakdown';
    } else if (q4) {
      return 'Using public transport';
    } else if (q5) {
      return 'Other';
    } else {
      return null;
    }
  }

  void showEVPinTypeBottomSheet(BuildContext context) {
    var isSelectedType = 1.obs;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 1;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 1
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-1.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "Type 1",
                      fontSize: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 2;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 2
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-3.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "Type 2",
                      fontSize: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 3;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 3
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-2.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "3 Pin",
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomFilledButton(
                  text: "Show me EV parking spaces", clickEvent: () {}),
            )
          ],
        ),
      ),
    );
  }

  void parkAgainSelectHoursBottomSheet(
      {required BuildContext context,
      required ParkingNowController controller}) {
    int selectedFixedTime = 0;
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                AppLabel(
                  text: "      ",
                ),
                const Spacer(),
                AppLabel(
                  text: "Set Duration",
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1,
            color: AppColors.appColorGray,
          ),
          const SizedBox(
            height: 30,
          ),
          AppLabel(text: "Select hours"),
          const SizedBox(
            height: 20,
          ),
          GroupButton(
            isRadio: true,
            onSelected: (val, index, isSelected) {
              selectedFixedTime = index + 1;
              if (selectedFixedTime > 0) {
                var parkUntil =
                    DateTime.now().add(Duration(hours: selectedFixedTime));
                controller.parkingFromTime = DateTime.now();
                controller.parkingUntilTime = parkUntil;
                controller.showHowLongParking.value =
                    "Until ${parkUntil.hour}:${parkUntil.minute < 10 ? '0${parkUntil.minute}' : parkUntil.minute} Today";
                controller.showParkingFrom.value =
                    "${controller.parkingFromTime?.hour}:${controller.parkingFromTime!.minute < 10 ? '0${controller.parkingFromTime?.minute}' : controller.parkingFromTime?.minute}";
                controller.showParkingUntil.value =
                    "${controller.parkingUntilTime?.hour}:${controller.parkingUntilTime!.minute < 10 ? '0${controller.parkingUntilTime?.minute}' : controller.parkingUntilTime?.minute}";
                controller.showTotalDuration.value = "$selectedFixedTime Hours";

                //add api call
                ParkingNowController().parkAgainCalculateBill(
                    ctrl: controller,
                    context: context,
                    parkingFromTime:
                        controller.parkingFromTime!.millisecondsSinceEpoch,
                    parkingUntilTime:
                        controller.parkingUntilTime!.millisecondsSinceEpoch);

                Get.back();
              }
            },
            buttons: const ["1hr", "2hr", "3hr", "4hr", "5hr"],
            options: GroupButtonOptions(
              selectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorWhite,
              ),
              selectedColor: AppColors.appColorBlack,
              unselectedColor: AppColors.appColorWhite,
              unselectedTextStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.appColorGray,
              ),
              selectedBorderColor: AppColors.appColorGray,
              unselectedBorderColor:
                  AppColors.appColorLightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
              spacing: 10,
              runSpacing: 10,
              groupingType: GroupingType.wrap,
              direction: Axis.horizontal,
              buttonHeight: 40,
              buttonWidth: 40,
              textAlign: TextAlign.center,
              textPadding: EdgeInsets.zero,
              alignment: Alignment.center,
              elevation: 0,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomFilledButton(
                text: "Set Custom Duration",
                clickEvent: () {
                  Get.back();
                  setCustomDuration(null,
                      context: context,
                      startDate:
                          DateTime.now().add(const Duration(minutes: 15)),
                      endDate: DateTime.now().add(const Duration(hours: 24)),
                      controller: controller);
                }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void signUpBottomSheet(BuildContext context) {
    final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();

    final GlobalKey<FormState> fNameKey = GlobalKey<FormState>();
    final TextEditingController fNameController = TextEditingController();

    final GlobalKey<FormState> lNameKey = GlobalKey<FormState>();
    final TextEditingController lNameController = TextEditingController();

    final GlobalKey<FormState> pNoKey = GlobalKey<FormState>();
    final TextEditingController pNoController = TextEditingController();

    final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();
    final TextEditingController phoneNumberController = TextEditingController();
    final selectedCountryCode = '+44'.obs;
    String? page = '/BottomSheet';
    String? phoneNumber;
    String? countryCode;

    bool _isValidate() {
      if (!emailKey.currentState!.validate()) {
        return false;
      } else if (!passwordKey.currentState!.validate()) {
        return false;
      } else if (!fNameKey.currentState!.validate()) {
        return false;
      } else if (!lNameKey.currentState!.validate()) {
        return false;
      } else if (!phoneNumberKey.currentState!.validate()) {
        return false;
      } else {
        return true;
      }
    }

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         Get.back();
              //         print('object');
              //       },
              //       child: SizedBox(
              //         height: 10,
              //         width: 60,
              //         child: IconButton(
              //             onPressed: () {}, icon: const Icon(Icons.clear)),
              //       ),
              //     )
              //   ],
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeading(text: 'Create an account', fontSize: 26),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLabel(
                      text: "First name",
                      fontSize: 13,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppInputField(
                      formKey: fNameKey,
                      controller: fNameController,
                      inputType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "First name is Required"),
                      ]),
                      hintText: "eg. John",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppLabel(
                      text: "Last name",
                      fontSize: 14,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppInputField(
                      formKey: lNameKey,
                      controller: lNameController,
                      inputType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Last name is Required"),
                      ]),
                      hintText: "eg. Smith",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppLabel(
                      text: "Email address",
                      fontSize: 14,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppInputField(
                      formKey: emailKey,
                      controller: emailController,
                      inputType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Email is Required"),
                        EmailValidator(errorText: "Enter a Valid Email")
                      ]),
                      hintText: "eg. johnsmith@gmail.com",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppLabel(
                      text: "Create password",
                      fontSize: 14,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppPasswordField(
                      formKey: passwordKey,
                      controller: passwordController,
                      inputType: TextInputType.text,
                      isObscure: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Password is Required"),
                        MinLengthValidator(8,
                            errorText: "Must be at least 8 characters")
                      ]),
                      hintText: "Must be at least 8 characters",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppLabel(
                      text: "Phone number",
                      fontSize: 14,
                      textColor: AppColors.appColorBlack01,
                    ),
                    Form(
                      key: phoneNumberKey,
                      child: InternationalPhoneNumberInput(
                        initialValue: PhoneNumber(isoCode: 'GB'),
                        onInputChanged: (value) {
                          print(value.phoneNumber);
                          countryCode = value.dialCode;
                          phoneNumber = value.phoneNumber;
                        },
                        autoFocusSearch: true,
                        autoValidateMode: AutovalidateMode.always,
                        inputDecoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter phone number",
                            hintStyle:
                                TextStyle(color: AppColors.appColorLightGray)),
                        inputBorder: InputBorder.none,
                        selectorConfig: const SelectorConfig(
                            showFlags: false,
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: AppColors.appColorBlack,
                    ),
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
                                      text: "By signing up, I agree to the ",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppColors.appColorGray,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.TERMS_OF_USE_SCREEN);
                                      },
                                      child: const Text(
                                        'Terms and Conditions',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    AppLabel(
                                      text: " and ",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      textColor: AppColors.appColorGray,
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(
                                              Routes.PRIVACY_POLICY_SCREEN);
                                        },
                                        child: const Text(
                                          ' Privacy Policy.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w500, // light
                                            // italic
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => Visibility(
                        visible: userController.isLoading.value,
                        child: CustomFilledButton(
                            text: "Create Account",
                            clickEvent: () {
                              if (_isValidate()) {
                                AppOverlay.startOverlay(context);
                                userController.isLoading.value = false;
                                AuthController().emailSignUp(
                                    countryCode: countryCode!,
                                    page: page,
                                    context: context,
                                    firstName: fNameController.text,
                                    lastName: lNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneNumber!);
                              }
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppLabel(
                                textAlign: TextAlign.center,
                                fontSize: 12,
                                text: 'Already have an account?',
                                textColor: AppColors.appColorGray,
                                fontWeight: FontWeight.w400,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                  signInBottomSheet(context);
                                },
                                child: AppLabel(
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                  fontSize: 12,
                                  text: ' Sign In',
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  String? getFormattedDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final parkingDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final parkingDayName = DateTime(dateTime.month, dateTime.day);
    if (parkingDay == today) {
      return 'Today';
    } else if (parkingDay == tomorrow) {
      return '';
    } else {
      return "";
    }
  }

  String getMonth(int monthNo) {
    String pickedMon = "";
    var months = {
      1: "Jan",
      2: "Feb",
      3: "Mar",
      4: "Apr",
      5: "May",
      6: "Jun",
      7: "Jul",
      8: "Agu",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec",
    };

    months.forEach((key, value) {
      if (key == monthNo) {
        pickedMon = value;
      }
    });

    return pickedMon;
  }

  void signInBottomSheet(BuildContext context) {
    final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();

    final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
    final TextEditingController passwordController = TextEditingController();
    String? page = '/BottomSheet';

    bool _isValidate() {
      if (!emailKey.currentState!.validate()) {
        return false;
      } else if (!passwordKey.currentState!.validate()) {
        return false;
      } else {
        return true;
      }
    }

    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                padding: const EdgeInsets.only(left: 16.0, top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeading(text: 'Welcome Back!', fontSize: 26),
                    const SizedBox(
                      height: 10,
                    ),
                    AppLabel(
                      text: 'Sign in to your account',
                      fontSize: 16,
                      textColor: AppColors.appColorGray,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLabel(
                      text: "Email address or phone number",
                      fontSize: 13,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppEmailPasswordField(
                      formKey: emailKey,
                      controller: emailController,
                      inputType: TextInputType.text,
                      hintText: "eg. johnsmith@gmail.com or +447900000000",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppLabel(
                      text: "Password",
                      fontSize: 13,
                      textColor: AppColors.appColorBlack01,
                    ),
                    AppPasswordField(
                      formKey: passwordKey,
                      controller: passwordController,
                      inputType: TextInputType.text,
                      isObscure: true,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Email is Required"),
                      ]),
                      hintText: "Enter your password",
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      GhostButton(
                          text: "Forgot Password?",
                          clickEvent: () {
                            Get.toNamed(Routes.FORGET_PASSWORD_SCREEN);
                          })
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => Visibility(
                        visible: userController.isLoading.value,
                        child: CustomFilledButton(
                            text: "Login",
                            clickEvent: () async {
                              if (_isValidate()) {
                                AppOverlay.startOverlay(context);
                                userController.isLoading.value = false;
                                AuthController().emailSignIn(
                                    page: page,
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void payHerePayment(
      {required BuildContext context,
      required FixedDurationbooking booking,
      required String id,
      required double amount}) async {
    Map paymentObject = {
      "sandbox": false, // true if using Sandbox Merchant ID
      "preapprove": true,
      "merchant_id": Constant.payhereMerchantId,
      "merchant_secret": Constant.payhereMerchantSecret,
      "notify_url": Constant.payhereNotifyUrl,
      "first_name": userController.user.value?.firstName,
      "last_name": userController.user.value?.lastName,
      "email": userController.user.value?.email,
      "phone": userController.user.value?.mobileNumber,
      "address": "Moroththa,Madahapola",
      "city": "Colombo",
      "country": "LK",
      "order_id": id,
      "items": id,
      "currency": "LKR",
      "amount": amount.toStringAsFixed(2),
    };
    PayHere.startPayment(
      paymentObject,
      (paymentId) async {
        print(booking.booking?.parkingType);
        if (booking.booking?.parkingType == 'parkLater') {
          ParkAgain parkAgain = ParkAgain(
              carParkPin: booking.carPark!.carParkPIN,
              carParkName: booking.carPark!.carParkName,
              id: booking.carPark!.id,
              timeZone: booking.booking!.timeZone,
              endTime: booking.booking!.bookingStart,
              startTime: booking.booking!.bookingEnd,
              city: booking.carPark!.city);
          SharedPref().setParkAgainDetails(parkAgain: parkAgain);
          await bookingController.getAllBooking();
          await userController.getCardDetail();
          AppOverlay.hideOverlay();

          //Get.offAll(()=>ParkLaterBookedDetailsScreen());
          Get.offUntil(
              MaterialPageRoute(
                  builder: (context) => ParkLaterBookedDetailsScreen()),
              (route) {
            var currentRoute = route.settings.name;
            if (currentRoute == Routes.DIRECT_DASHBOARD) {
              return true;
            } else if (currentRoute == Routes.DASHBOARD) {
              return true;
            } else {
              return false;
            }
          });
        } else {
          ParkAgain parkAgain = ParkAgain();
          parkAgain = ParkAgain(
              dontKnowParking: false,
              timeZone: booking.booking!.timeZone,
              carParkPin: booking.carPark!.carParkPIN,
              carParkName: booking.carPark!.carParkName,
              endTime: booking.booking!.bookingStart,
              startTime: booking.booking!.bookingEnd,
              id: booking.booking!.carParkId);
          SharedPref().setParkAgainDetails(parkAgain: parkAgain);
          //  userController.getCardDetail();
          await bookingController.getAllBooking();
          AppOverlay.hideOverlay();
          Get.offUntil(
              MaterialPageRoute(
                  builder: (context) => ParkNowFixedDurationBookedDetailsScreen(
                        booking: booking,
                      )), (route) {
            var currentRoute = route.settings.name;
            if (currentRoute == Routes.DIRECT_DASHBOARD) {
              return true;
            } else if (currentRoute == Routes.DASHBOARD) {
              return true;
            } else {
              return false;
            }
          });
        }
      },
      (error) {
        AppOverlay.hideOverlay();
        print("One Time Payment Failed. Error: $error");
        showAlert(context, "Payment Failed", error);
      },
      () {
        AppOverlay.hideOverlay();
        print("One Time Payment Dismissed");
        showAlert(context, "Payment Dismissed", "");
      },
    );
  }

  void showAlert(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
