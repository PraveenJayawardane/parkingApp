import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/custom_date_picker.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_bottom_sheets.dart';
class ParkLaterExtendBookingScreen extends StatelessWidget {
  ParkLaterExtendBookingScreen({Key? key}) : super(key: key);
  var isFixedDuration = false.obs;
  ParkingNowController parkingController = Get.put(ParkingNowController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: AppColors.appColorBlack,),onPressed: (){Get.back();},),
        title: const Text(
          "Extend Booking",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            const Divider(thickness: 1,color: AppColors.appColorLightGray,),
            const SizedBox(height: 16,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: LocationCodeView(parkName: 'Boston Central Car Park', city: 'Bond Street',parkingId: "1111",postCode: '',addressOne: '',addressTow: ''),
            ),

            const SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AppLabel(text: "How long are you parking for?"),
                      ),
                      const SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8),
                        child: InkWell(
                          onTap: (){
                            AppBottomSheet().selectHoursBottomSheet(null,context: context,controller: parkingController);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(text: "Until 15:08 Today",fontSize: 14,textColor: AppColors.appColorLightGray,),
                              const Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(thickness: 1,color: AppColors.appColorLightGray,),
                      ),

                      Container(
                        color: AppColors.appColorLightGray.withOpacity(0.2),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          children: [
                            AppLabel(text: "1 Hour"),
                            AppLabel(text: "Total duration",fontSize: 14,textColor: AppColors.appColorLightGray,)
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppLabel(text: "Vehicle"),
            ),
            const SizedBox(height: 16,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: (){ Get.toNamed(Routes.SELECT_VEHICLE_SCREEN);},
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.car,size: 18,),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      children: [
                        Row(children: [
                          AppLabel(text: "RK71CBX MG Black",fontSize: 14,textColor: AppColors.appColorLightGray,),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,size: 16,)
                        ],),
                        Divider(thickness: 1,color: AppColors.appColorLightGray,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

            const SizedBox(height: 24,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppLabel(text: "Payments"),
            ),
            const SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.moneyBill1,size: 18,),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Column(
                      children: [
                        Row(children: [
                          AppLabel(text: "Card ending - 6598",fontSize: 14,textColor: AppColors.appColorLightGray,),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,size: 16,)
                        ],),
                        Divider(thickness: 1,color: AppColors.appColorLightGray,)
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16,),

            const SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLabel(text: "Parking Chargers",textColor: AppColors.appColorLightGray,fontSize: 14,),
                  AppLabel(text: "£ 6.00",fontSize: 14,)
                ],
              ),
            ),

            const SizedBox(height: 16,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    AppLabel(text: "Service fee",textColor: AppColors.appColorLightGray,fontSize: 14,),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        infoBottomSheet(context);
                      },
                        child: Icon(Icons.info,size: 18,color: AppColors.appColorLightGray,))
                  ],),

                  AppLabel(text: "£ 1.00",fontSize: 14,)
                ],
              ),
            ),

            const SizedBox(height: 16,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLabel(text: "Vat",textColor: AppColors.appColorLightGray,fontSize: 14,),
                  AppLabel(text: "£ 1.00",fontSize: 14,)
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 1,color: AppColors.appColorLightGray,),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLabel(text: "Total",fontSize: 16,fontWeight: FontWeight.bold,),
                  AppLabel(text: "£ 8.00",fontSize: 16,fontWeight: FontWeight.bold,)
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomFilledButton(text: "Update Booking", clickEvent: (){
                Get.back();
              }),
            ),

            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }

  void infoBottomSheet(BuildContext context){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor:
      AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.clear))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(text: "Purpose of a service fee"),
          ),
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(text: "Lörem ipsum plalana preledes merade. Prende ar fast dynade sespes i kvasivis. Äns biofid rovis fakånt mibyl respektive miren.",fontSize: 12,),
          ),
          SizedBox(height: 60,)
        ],
      ),
    );
  }

}
