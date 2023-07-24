import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class ParkNowDontKnowParkingTabController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late TabController dontKnowtabController;

  final List<Tab> bookingTabs = const [
    Tab(
      child: Text(
        "Status",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        "Details",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];
  final List<Tab> dontKnowbookingTabs = const [
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
        "Details",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];

  @override
  void onInit() {
    tabController = TabController(length: bookingTabs.length, vsync: this);
    dontKnowtabController =
        TabController(length: dontKnowbookingTabs.length, vsync: this);
    super.onInit();
  }
}
