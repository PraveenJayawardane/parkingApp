import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_icon_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../widgets/atoms/app_label.dart';

class RebookScreen extends StatelessWidget {
  const RebookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Booking ID - 123456",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 1,
              color: AppColors.appColorLightGray,
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: LocationCodeView(
                  parkName: 'Boston Central Car Park',
                  city: 'Bond Street',
                  parkingId: "1111",
                  postCode: '',addressOne: '',addressTow: ''),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/demo_img/car_park1.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: AppLabel(
                text: "Booking Information",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Booking ID",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "123456",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Status",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "Completed",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Vehicle Number",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "RK71CBX",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Payment Method",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "VISA ending in 0234",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Booked On",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "23 July 2022, 07:00PM",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Permit Start",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "24 July 2022, 02:00PM",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Permit End",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "24 July 2022, 05:00PM",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Duration",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          ),
                          AppLabel(
                            text: "3 Hours",
                            fontSize: 14,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppLabel(
                            text: "Total Cost",
                            fontSize: 14,
                          ),
                          AppLabel(
                            text: "£ 16.00",
                            fontSize: 14,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.appColorGreen.withOpacity(0.2),
                    border: Border.all(color: AppColors.appColorGreen)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Column(
                      children: [
                        AppLabel(
                          text: "Access Pin Number",
                          fontSize: 14,
                        ),
                        AppLabel(
                          text: "#7865",
                          fontSize: 14,
                          textColor: AppColors.appColorGray,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.qr_code,
                      size: 42,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: BorderedIconButton(
                      text: "QR code",
                      clickEvent: () {},
                      faIcon: const FaIcon(FontAwesomeIcons.qrcode),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: BorderedIconButton(
                      text: "Control",
                      clickEvent: () {},
                      faIcon: const FaIcon(
                        FontAwesomeIcons.roadBarrier,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: AppLabel(
                text: "Space Description",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: AppLabel(
                text:
                    "Lörem ipsum plalana preledes merade. Prende ar fast dynade sespes i kvasivis. Äns biofid rovis fakånt mibyl respektive miren. Terratopi nånannanism. Anter kora. Pal dekarat pseudon berade rev. ",
                fontSize: 15,
                textColor: AppColors.appColorGray,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        AppLabel(
                          text: "You rated",
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RatingBar.builder(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          unratedColor:
                              AppColors.appColorLightGray.withOpacity(0.2),
                          itemCount: 5,
                          itemSize: 30,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomFilledButton(text: "Re-book", clickEvent: () {}),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BorderedButton(text: "View receipt", clickEvent: () {}),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
