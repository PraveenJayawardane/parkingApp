import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class DayMonthTabController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;


  final List<Tab> dayMonthTabs = const [
    Tab(child: Text("Daily",style: TextStyle(color: AppColors.appColorBlack),),),
    Tab(child : Text("Monthly",style: TextStyle(color: AppColors.appColorBlack),),),

  ];


  @override
  void onInit() {
    tabController = TabController(length: dayMonthTabs.length, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

}