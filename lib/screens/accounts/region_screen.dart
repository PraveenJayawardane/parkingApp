import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';

import '../../constants/app_colors.dart';
import '../../services/local/shared_pref.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({Key? key}) : super(key: key);

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  var userController = Get.find<UserController>();

  Country? country;

  @override
  void initState() {
    super.initState();
    print(country);
    print(userController.curentRegion);
    print(SharedPref.getTimeZone());
    if (userController.curentRegion == false) {
      country = SharedPref.getTimeZone() == 'Asia/Colombo'
          ? Country.unitedKindom
          : Country.sriLanka;
    } else {
      country ??= SharedPref.getTimeZone() == 'Asia/Colombo'
          ? Country.sriLanka
          : Country.unitedKindom;
    }
  }

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
          "Change Country",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Sri Lanka'),
            trailing: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('assets/images/sl_flag.png')),
            leading: Radio(
              value: Country.sriLanka,
              groupValue: country,
              onChanged: (Country? value) {
                setState(() {
                  country = value;

                  if (SharedPref.getTimeZone() == 'Asia/Colombo' &&
                      value?.name == 'sriLanka') {
                    userController.curentRegion = true;
                  } else {
                    userController.curentRegion = false;
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('United Kindom'),
            trailing: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('assets/images/uk_flag.png')),
            leading: Radio(
              value: Country.unitedKindom,
              groupValue: country,
              onChanged: (Country? value) {
                setState(() {
                  country = value;

                  if (SharedPref.getTimeZone() == 'Europe/London' &&
                      value?.name == 'unitedKindom') {
                    userController.curentRegion = true;
                  } else {
                    userController.curentRegion = false;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum Country {
  sriLanka,
  unitedKindom,
}
