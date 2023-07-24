import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/vehicle_card_view.dart';

import '../../constants/app_colors.dart';
import '../../model/Vehical.dart';

class SelectVehicleScreen extends StatelessWidget {
  SelectVehicleScreen({Key? key}) : super(key: key);

  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Select your vehicle",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Divider(
          //   thickness: 1,
          //   color: AppColors.appColorLightGray,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: ListView(
          //     shrinkWrap: true,
          //     children: ListTile.divideTiles(context: context, tiles: [
          //       // VehicleCardView(),
          //       // VehicleCardView()
          //     ]).toList(),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0),
          //   child: GhostButton(
          //       text: "Add another vehicle",
          //       clickEvent: () {
          //         Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
          //       }),
          // )
      
        ],
      ),
    );
  }
}
