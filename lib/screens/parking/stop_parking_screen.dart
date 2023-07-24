import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';

import '../../constants/app_colors.dart';
import '../../widgets/molecules/buttons/bordered_button.dart';

class StopParkingScreen extends StatelessWidget {
  const StopParkingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Bookings",style: TextStyle(color: AppColors.appColorBlack),),
        centerTitle: true,
       backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Divider(thickness: 1,color: AppColors.appColorLightGray,),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/parking_gate.png"),
              AppLabel(text: "Are you sure you want to stop parking?s"),

            ],
          ),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(child: CustomFilledButton(text: "Yes", clickEvent: (){}) ),
                SizedBox(width: 20,),
                Expanded(child: BorderedButton(text: "No",clickEvent: (){},))
                ,

              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
