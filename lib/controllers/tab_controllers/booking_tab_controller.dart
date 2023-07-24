import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class BookingTabController extends GetxController with GetSingleTickerProviderStateMixin {

  late TabController tabController;

  final List<Tab> bookingTabs = const [
    Tab(child: Text("Active",style: TextStyle(color: AppColors.appColorGray),),),
    Tab(child : Text("Upcoming",style: TextStyle(color: AppColors.appColorGray),),),
    Tab(child : Text("Completed",style: TextStyle(color: AppColors.appColorGray),),),
  ];

  @override
  void onInit() {
    tabController = TabController(length: bookingTabs.length, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    // tabController.dispose();
    tabController.dispose();
    super.onClose();
  }

}