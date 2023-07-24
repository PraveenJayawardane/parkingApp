import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_place/google_place.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/ghost_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/vehicle_card_view.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';

import '../../constants/app_colors.dart';

class AddForeignVehicleScreen extends StatelessWidget {
  final GlobalKey<FormState> _vehicleNumberPlateKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNumberPlateController =
      TextEditingController();
  final GlobalKey<FormState> _vehicleNameKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNameController = TextEditingController();
  final GlobalKey<FormState> _vehicleModelKey = GlobalKey<FormState>();
  final TextEditingController _vehicleModelController = TextEditingController();
  var userController = Get.find<UserController>();

  AddForeignVehicleScreen({Key? key}) : super(key: key);

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
            child: AppLabel(text: "Add Foreign Number Plate"),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppInputField(
                formKey: _vehicleNumberPlateKey,
                controller: _vehicleNumberPlateController,
                inputType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Vehicle Plate number required")
                ]),
                hintText: "Enter license plate number"),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppInputField(
                formKey: _vehicleNameKey,
                controller: _vehicleNameController,
                inputType: TextInputType.text,
                validator: MultiValidator(
                    [RequiredValidator(errorText: "Vehicle number required")]),
                hintText: "Enter vehicle name"),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppInputField(
                formKey: _vehicleModelKey,
                controller: _vehicleModelController,
                inputType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Enter vehicle model required")
                ]),
                hintText: "Enter vehicle model"),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(
              () => Visibility(
                visible: userController.isLoading.value,
                child: CustomFilledButton(
                    text: "Save",
                    clickEvent: () {
                      if (_isValidate()) {
                        AppOverlay.startOverlay(context);
                        userController.isLoading.value = false;

                        // AccountController().addForeignNumberPlate(
                        //     _vehicleNumberPlateController.text,
                        //     _vehicleNameController.text,
                        //     _vehicleModelController.text);
                      }
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  bool _isValidate() {
    if (!_vehicleNumberPlateKey.currentState!.validate()) {
      return false;
    } else if (!_vehicleModelKey.currentState!.validate()) {
      return false;
    } else if (!_vehicleNameKey.currentState!.validate()) {
      return false;
    } else {
      return true;
    }
  }
}
