import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/constant.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/vehicle_card_view.dart';

import '../../constants/app_colors.dart';
import '../../services/local/shared_pref.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({Key? key}) : super(key: key);

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  UserController userController = Get.find<UserController>();
  BookingController bookingController = Get.find<BookingController>();
  var preveiusRoute = ''.obs;
  @override
  void initState() {
    preveiusRoute.value = Get.routing.previous;
    if (preveiusRoute.value == '/ParkNowSetDurationScreen' ||
        preveiusRoute.value == '/ParkLaterSetDurationScreen' ||
        preveiusRoute.value == '/BookAgainSetDurationScreen') {
    } else {
      if (SharedPref.getTimeZone() == 'Asia/Colombo') {
        bookingController.baseUrl.value = Constant.slUrl;
      } else {
        bookingController.baseUrl.value = Constant.ukUrl;
      }
      if (userController.curentRegion == false) {
        userController.getVehicleData(
            url: SharedPref.getTimeZone() == 'Asia/Colombo'
                ? Constant.ukUrl
                : Constant.slUrl);
        bookingController.baseUrl.value =
            SharedPref.getTimeZone() == 'Asia/Colombo'
                ? Constant.ukUrl
                : Constant.slUrl;
      } else {
        if (preveiusRoute.value == '/DirectDashbord' ||
            preveiusRoute.value == '/Dashboard') {
          userController.getVehicleData(
              url: SharedPref.getTimeZone() == 'Asia/Colombo'
                  ? Constant.slUrl
                  : Constant.ukUrl);
        } else {
          if (SharedPref.getCurerentParkCurrency() != null) {
            userController.getVehicleData(
                url: SharedPref.getCurerentParkCurrency() == 'LKR'
                    ? Constant.slUrl
                    : Constant.ukUrl);
          }
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Get.previousRoute);
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
              Visibility(
                visible: true,
                child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: const [
                        Icon(FontAwesomeIcons.plus, size: 15),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Add Vehicle",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.appColorBlack01,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                      arguments: preveiusRoute.value),
                ),
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
                height: 16,
              ),
              Obx(
                () => Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: userController.vehicles!.value!.data!.length,
                    itemBuilder: (context, index) {
                      return VehicleCardView(
                          changeVehicleScreen: false,
                          bookingId: null,
                          vehicle:
                              userController.vehicles!.value!.data![index]);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Visibility(
                visible: true,
                child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: const [
                          Icon(FontAwesomeIcons.plus, size: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Add Vehicle",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.appColorBlack01,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(bookingController.baseUrl);
                      Get.toNamed(Routes.ADD_VEHICLE_SCREEN,
                          arguments: preveiusRoute.value);
                    }),
              )
            ],
          );
        }
      }),
    );
  }
}
