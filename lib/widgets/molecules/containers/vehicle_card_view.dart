import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/park_later_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';

import '../../../constants/app_colors.dart';
import '../../../model/Vehical.dart';
import '../../../screens/accounts/my_vehical/edit_vehicle_screen.dart';
import '../../atoms/app_label.dart';

class VehicleCardView extends StatelessWidget {
  var userController = Get.find<UserController>();
  var parkLaterController = Get.put(ParkingLaterController());
  final Vehicle vehicle;
  final bool changeVehicleScreen;
  final String? bookingId;
  VehicleCardView(
      {Key? key,
      required this.vehicle,
      required this.changeVehicleScreen,
      required this.bookingId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(vehicle.id);
    return ListTile(
      onTap: Get.previousRoute != '/DirectDashbord' ||
              Get.previousRoute == '/SingleBookingScreen'
          ? () {
              if (Get.previousRoute == '/SingleBookingScreen') {
                userController.selectedVehicleInUpcomeingBooking?.value =
                    vehicle;
                if (changeVehicleScreen) {
                  print(vehicle.id);
                  parkLaterController.changeVrn(
                      bookingId: bookingId!,
                      context: context,
                      vehicleId: vehicle.id!);
                }

                Get.back();
              } else if (Get.previousRoute != '/DirectDashbord') {
                print('select');
                userController.selectedVehicle?.value = vehicle;
                print(userController.selectedVehicle?.value?.id);
                Get.back();
              }
            }
          : null,
      leading: Container(
          decoration: BoxDecoration(
              color: AppColors.appColorBlack,
              borderRadius: BorderRadius.circular(6)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: FaIcon(
              FontAwesomeIcons.car,
              size: 16,
              color: AppColors.appColorWhite,
            ),
          )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(
            text: vehicle.vRN ?? '',
            fontSize: 14,
          ),
          AppLabel(
            text:
                '${vehicle.model ?? ''}${vehicle.model != null ? '(${vehicle.color ?? ''})' : ''}',
            fontSize: 12,
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        color: AppColors.appColorBlack,
        onPressed: () {
          showEditVehicleBottomSheet(context);
        },
      ),
    );
  }

  void showEditVehicleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.28,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.appColorWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppLabel(
                          text: "Edit",
                          textColor: AppColors.appColorBlack01,
                        ),
                      ),
                      onTap: () {
                        Get.to(EditVehicleScreen(
                          vehical: vehicle,
                        ));
                      },
                    ),
                    const Divider(
                      thickness: 1,
                      color: AppColors.appColorWhiteGray01,
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AppLabel(
                            text: "Delete",
                            textColor: AppColors.appColorGoogleRed,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text(
                                  'Delete Vehicle?',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: AppColors.appColorBlack01),
                                ),
                                content: const Text(
                                  'Are you sure you want to delete this vehicle?',
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(color: AppColors.appColorGray),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      AppOverlay.startOverlay(context);
                                      AccountController().deleteVehicle(
                                          url: vehicle.baseURL!,
                                          token: SharedPref.getToken()!,
                                          id: vehicle.id!);
                                      Get.back();
                                      Get.back();
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.appColorWhite),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: AppLabel(
                        text: "Cancel",
                        textColor: AppColors.appColorBlack01,
                      ),
                    ),
                    onTap: () {
                      print('object');
                      Get.back();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
