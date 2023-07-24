import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class ParkNowFixedDurationTabController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late TabController tabControllerForUpcoming;
  late TabController tabControllerForComplete;

  final List<Tab> bookingTabs = const [
    Tab(
      child: Text(
        "Status",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        "Access",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        " Details",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];

  final List<Tab> bookingTabsInUpcoming = const [
    Tab(
      child: Text(
        "Details",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        "  Access",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];
  final List<Tab> bookingTabsInComplete = const [
    Tab(
      child: Text(
        "Details",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];

  @override
  void onInit() {
    tabController = TabController(length: bookingTabs.length, vsync: this);
    tabControllerForUpcoming =
        TabController(length: bookingTabsInUpcoming.length, vsync: this);
    tabControllerForComplete =
        TabController(length: bookingTabsInComplete.length, vsync: this);

    super.onInit();
  }
}
