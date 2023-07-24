import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/routes.dart';
import '../../atoms/app_label.dart';
import '../buttons/ghost_button.dart';

class CustomDatePicker {
  void setFixedDateTime(
      {required BuildContext context,
      required DateTime startDate,
      required DateTime endDate}) {
    DateTime? pickDateTime;
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
          SizedBox(
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
                AppLabel(text: "Select a Date and Time"),
                GhostButton(
                  text: "Done",
                  clickEvent: () {
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
                height: 180,
                width: 200,
                child: DatePickerWidget(
                  pickerTheme: const DateTimePickerTheme(
                      dividerColor: AppColors.appColorBlack),
                  initialDate: DateTime.now(),
                  firstDate: startDate,
                  lastDate: endDate,
                  dateFormat: "Edd-MMMM",
                  onChange: (dateTime, selectedIndex) {
                    year = dateTime.year;
                    month = dateTime.month;
                    day = dateTime.day;
                    pickDateTime = DateTime(year, month, day, hours, minutes);
                    print(pickDateTime);
                  },
                ),
              ),
              Container(
                width: 160,
                height: 180,
                color: AppColors.appColorWhite,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: 72,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    Positioned(
                        top: 108,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    const Positioned(
                        bottom: 81,
                        left: 55,
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    TimePickerSpinner(
                      isForce2Digits: true,
                      normalTextStyle:
                          const TextStyle(fontSize: 15, color: Colors.grey),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 16, color: Colors.black),
                      itemHeight: 35,
                      minutesInterval: 1,
                      spacing: 5,
                      is24HourMode: false,
                      onTimeChange: (DateTime time) {
                        hours = time.hour;
                        minutes = time.minute;

                        pickDateTime =
                            DateTime(year, month, day, hours, minutes);
                        print(pickDateTime);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setStartDateTime(
      {required BuildContext context,
      required DateTime startDate,
      required DateTime endDate}) {
    DateTime? pickDateTime;
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
          SizedBox(
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
                    }),
                AppLabel(text: "Parking From"),
                GhostButton(
                  text: "Done",
                  clickEvent: () {
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
                height: 180,
                width: 200,
                child: DatePickerWidget(
                  pickerTheme: const DateTimePickerTheme(
                      dividerColor: AppColors.appColorBlack),
                  initialDate: DateTime.now(),
                  firstDate: startDate,
                  lastDate: endDate,
                  dateFormat: "Edd-MMMM",
                  onChange: (dateTime, selectedIndex) {
                    year = dateTime.year;
                    month = dateTime.month;
                    day = dateTime.day;
                    pickDateTime = DateTime(year, month, day, hours, minutes);
                    print(pickDateTime);
                  },
                ),
              ),
              Container(
                width: 160,
                height: 180,
                color: AppColors.appColorWhite,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: 72,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    Positioned(
                        top: 108,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    const Positioned(
                        bottom: 81,
                        left: 55,
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    TimePickerSpinner(
                      isForce2Digits: true,
                      normalTextStyle:
                          const TextStyle(fontSize: 15, color: Colors.grey),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 16, color: Colors.black),
                      itemHeight: 35,
                      minutesInterval: 1,
                      spacing: 5,
                      is24HourMode: false,
                      onTimeChange: (DateTime time) {
                        hours = time.hour;
                        minutes = time.minute;

                        pickDateTime =
                            DateTime(year, month, day, hours, minutes);
                        print(pickDateTime);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setEndDateTime({
    required BuildContext context,
    required DateTime startDate,
    required DateTime endDate,
    required ParkingNowController controller,
  }) {
    DateTime? pickDateTime;
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
                  text: "Parking Until",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Done",
                  clickEvent: () {
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
                height: 180,
                width: 200,
                child: DatePickerWidget(
                  pickerTheme: const DateTimePickerTheme(
                      dividerColor: AppColors.appColorBlack),
                  initialDate: DateTime.now(),
                  firstDate: startDate,
                  lastDate: endDate,
                  dateFormat: "Edd-MMMM",
                  onChange: (dateTime, selectedIndex) {
                    year = dateTime.year;
                    month = dateTime.month;
                    day = dateTime.day;
                    pickDateTime = DateTime(year, month, day, hours, minutes);
                    print(pickDateTime);
                  },
                ),
              ),
              Container(
                width: 160,
                height: 180,
                color: AppColors.appColorWhite,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: 72,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    Positioned(
                        top: 108,
                        left: 20,
                        child: Container(
                          height: 2,
                          width: 120,
                          color: AppColors.appColorBlack,
                        )),
                    const Positioned(
                        bottom: 81,
                        left: 55,
                        child: Text(
                          ':',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    TimePickerSpinner(
                      isForce2Digits: true,
                      normalTextStyle:
                          const TextStyle(fontSize: 15, color: Colors.grey),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 16, color: Colors.black),
                      itemHeight: 35,
                      minutesInterval: 1,
                      spacing: 5,
                      is24HourMode: false,
                      onTimeChange: (DateTime time) {
                        hours = time.hour;
                        minutes = time.minute;

                        pickDateTime =
                            DateTime(year, month, day, hours, minutes);
                        print(pickDateTime);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
