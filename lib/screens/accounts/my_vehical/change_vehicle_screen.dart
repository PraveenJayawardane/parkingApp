import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/vehicle_card_view.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/constant.dart';
import '../../../services/local/shared_pref.dart';

class ChangeVehicleScreen extends StatefulWidget {
  const ChangeVehicleScreen({Key? key}) : super(key: key);

  @override
  State<ChangeVehicleScreen> createState() => _ChangeVehicleScreen();
}

class _ChangeVehicleScreen extends State<ChangeVehicleScreen> {
  UserController userController = Get.find<UserController>();
  var preveiusRoute = ''.obs;
  var changeVehicalScreen = true;
  var bookingId = Get.arguments;
  @override
  void initState() {
    userController.getVehicleData(
        url: SharedPref.getTimeZone() == 'Asia/Colombo'
            ? Constant.slUrl
            : Constant.ukUrl);
    preveiusRoute.value = Get.routing.previous;
    super.initState();
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
            // ignore: prefer_is_empty
            if (userController.vehicles?.value?.data?.length == 0) {
              userController.selectedVehicle?.value = null;
              userController.selectedVehicle?.refresh();
            }
            // AppBackButton().getBack();
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
        title: const Text(
          "My Vehicles",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (userController.isVehicleLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (userController.vehicles!.value!.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Add Vehicle",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.appColorLightBlue),
                  ),
                ),
                onTap: () => Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                    arguments: preveiusRoute.value),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppLabel(
                  text: "My Vehicles",
                  textColor: AppColors.appColorBlack01,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userController.vehicles!.value!.data!.length,
                    itemBuilder: (context, index) {
                      return VehicleCardView(
                          bookingId: bookingId,
                          changeVehicleScreen: changeVehicalScreen,
                          vehicle:
                              userController.vehicles!.value!.data![index]);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Add Vehicle",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.appColorBlack),
                  ),
                ),
                onTap: () => Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                    arguments: preveiusRoute.value),
              )
            ],
          );
        }
      }),
    );
  }
}
