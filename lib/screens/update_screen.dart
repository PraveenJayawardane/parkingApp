import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/routes.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Time To Update',
              style: TextStyle(color: AppColors.appColorBlack)),
          backgroundColor: AppColors.appColorWhite),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 300,
            child: Image.asset(
              'assets/images/get_started_bg_img.png',
            ),
          ),
          const Text('We added new features to make'),
          const Text('your experience as smooth as'),
          const Text('possible.'),
          const SizedBox(height: 80),
          SizedBox(
            height: 40,
            width: 300,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.appColorBlack),
                onPressed: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid
                        ? 'https://play.google.com/store/apps/details?id=com.parkfinda.customer&hl=en&gl=US'
                        : 'https://apps.apple.com/lk/app/parkfinda/id6449968748';
                    final url = Uri.parse(
                      Platform.isAndroid ? appId : appId,
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: AppColors.appColorWhite),
                )),
          ),
          const SizedBox(height: 10),
          const Text('Or'),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            width: 300,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.appColorBlack)),
                onPressed: () {
                  Get.offAllNamed(Routes.DIRECT_DASHBOARD);
                },
                child: const Text('Not Now')),
          ),
        ]),
      ),
    );
  }
}
