import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class PrivacyPolicyTabController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  final List<Tab> bookingTabs = const [
    Tab(
      child: Text(
        "United Kindom",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        "Sri Lanka",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];

  @override
  void onInit() {
    tabController = TabController(length: bookingTabs.length, vsync: this);

    super.onInit();
  }
}
