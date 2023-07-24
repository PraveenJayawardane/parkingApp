import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/input_fields/app_input_field.dart';
import '../../constants/app_colors.dart';
import '../../widgets/molecules/buttons/custom_filled_button.dart';

class ChangeNameScreen extends StatelessWidget {
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  ChangeNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = "Aaron";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
       backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(icon: const Icon(
          Icons.arrow_back_ios, color: AppColors.appColorBlack,),
          onPressed: () {
            Get.back();
          },),
        title: const Text(
          "Change Name",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1, color: AppColors.appColorLightGray,),

          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(text: "First name"),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppInputField(
                formKey: _nameKey,
                controller: _nameController,
                inputType: TextInputType.text,
                validator: MultiValidator(
                    [
                      RequiredValidator(errorText: "Vehicle number required")
                    ]),
                hintText: "Enter license plate number"),
          ),


          Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(text: "Save", clickEvent: (){}),
          ),
          SizedBox(height: 30,)

        ],
      ),
    );
  }
}
