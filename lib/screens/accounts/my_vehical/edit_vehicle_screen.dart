import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Vehical.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

import '../../../constants/app_colors.dart';

class EditVehicleScreen extends StatelessWidget {
  final Vehicle vehical;
  final GlobalKey<FormState> _vehicleNumberKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  var userController = Get.find<UserController>();

  EditVehicleScreen({Key? key, required this.vehical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _vehicleNumberController.text = vehical.vRN!;
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
          "Edit Vehicle",
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
            child: AppLabel(
              text: "Edit Vehicle Number",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter license plate number'),
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

                      AccountController().editVehicle(
                          vehical.id!, _vehicleNumberController.text);
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

  bool _validate() {
    if (!_vehicleNumberKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
