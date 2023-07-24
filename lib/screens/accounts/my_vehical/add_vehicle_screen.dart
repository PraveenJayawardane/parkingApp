import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/account_controller.dart';

class AddVehicleScreen extends StatelessWidget {
  final GlobalKey<FormState> _vehicleNumberKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();
  var previousRoute = Get.arguments;

  AddVehicleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(bookingController.baseUrl);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
          "Add Vehicle",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(text: "Add Vehicle Number"),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Enter Vehicle Number'),
                  key: _vehicleNumberKey,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Vehicle number required")
                  ]),
                  controller: _vehicleNumberController,
                  onChanged: (value) {
                    _vehicleNumberController.value = TextEditingValue(
                        text: value.toUpperCase(),
                        selection: _vehicleNumberController.selection);
                  })),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0),
          //   child: Row(
          //     children: [
          //       Image.asset("assets/images/lisence_plate_no.png"),
          //       GhostButton(
          //           text: "Foreign Number Plate",
          //           clickEvent: () {
          //             Get.toNamed(Routes.ADD_FOREIGN_VEHICLE_SCREEN);
          //           }),
          //     ],
          //   ),
          // ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => Visibility(
                visible: userController.isLoading.value,
                child: CustomFilledButton(
                    text: "Save",
                    clickEvent: () {
                      AppOverlay.startOverlay(context);
                      userController.isLoading.value = false;
                      AccountController().createVehical(
                          url: bookingController.baseUrl.value,
                          routes: previousRoute ?? Get.previousRoute,
                          numberPlate:
                              _vehicleNumberController.text.toUpperCase());
                      FocusScope.of(context).requestFocus(FocusNode());
                    }),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  // bool _validate() {
  //   if (!_vehicleNumberKey.currentState!.validate()) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
