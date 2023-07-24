import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../constants/app_colors.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "QR Code",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        children: const [
          Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          SizedBox(
            height: 150,
          ),
          // Center(
          //   child: QrImage(
          //     data: "https://www.google.lk/",
          //     version: QrVersions.auto,
          //     size: 250.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
