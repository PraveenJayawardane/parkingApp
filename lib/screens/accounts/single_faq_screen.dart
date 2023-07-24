import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';

import '../../constants/app_colors.dart';
class SingleFAQScreen extends StatelessWidget {
  const SingleFAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
        title: const Text(
          "How to change password",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
            child: AppLabel(text: "Content here",fontSize: 12,textColor: AppColors.appColorLightGray,),
          )
        ],
      ),
    );
  }
}
