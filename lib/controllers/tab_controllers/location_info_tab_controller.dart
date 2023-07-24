import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class LocationInfoTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final List<Tab> locationInfoTabs = const [
    Tab(
      child: Text(
        "Information",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
    Tab(
      child: Text(
        "How it works",
        style: TextStyle(color: AppColors.appColorBlack),
      ),
    ),
  ];

  @override
  void onInit() {
    tabController = TabController(length: locationInfoTabs.length, vsync: this);

    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
