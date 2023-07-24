import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/routes.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreen();
}

class _SelectCountryScreen extends State<SelectCountryScreen> {
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
          "Settings",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      FaIcon(FontAwesomeIcons.earthAsia),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Country",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ]),
                onTap: () {
                  Get.toNamed(Routes.REGION_SCREEN);
                }),
            const Divider()
          ],
        ),
      ),
    );
  }
}

enum Country {
  sriLanka,
  unitedKindom,
}
