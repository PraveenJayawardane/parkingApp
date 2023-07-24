import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/utils/app_bottom_sheets.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_heading.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

class VehicleTypeGroupButton extends StatelessWidget {
  var isEVVehicle = false.obs;
  var isRVVehicle = true.obs;

  VehicleTypeGroupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(() {
          return GestureDetector(
            onTap: (){
              isEVVehicle.value = true;
              isRVVehicle.value = !isEVVehicle.value;
              AppBottomSheet().showEVPinTypeBottomSheet(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isEVVehicle.value
                      ? AppColors.appColorBlack
                      : AppColors.appColorWhite),
              child: Row(
                children: [
                  Icon(
                    Icons.power_rounded,
                    size: 16,
                    color: isEVVehicle.value
                        ? AppColors.appColorWhite
                        : AppColors.appColorBlack,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    "EV",
                    style: TextStyle(
                      fontSize: 12,
                        color: isEVVehicle.value
                            ? AppColors.appColorWhite
                            : AppColors.appColorBlack),
                  )
                ],
              ),
            ),
          );
        }),
        const SizedBox(width: 6,),
        Obx(() {
          return GestureDetector(
            onTap: (){
            isRVVehicle.value = true;
            isEVVehicle.value = !isRVVehicle.value;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isRVVehicle.value
                      ? AppColors.appColorBlack
                      : AppColors.appColorWhite),
              child: Row(
                children: [
                  Icon(
                    Icons.fire_truck,
                    size: 16,
                    color: isRVVehicle.value
                        ? AppColors.appColorWhite
                        : AppColors.appColorBlack,
                  ),
                  const SizedBox(width: 4,),
                  Text(
                    "RV",
                    style: TextStyle(
                        fontSize: 12,
                        color: isRVVehicle.value
                            ? AppColors.appColorWhite
                            : AppColors.appColorBlack),
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }



}
