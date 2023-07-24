import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import '../../constants/app_colors.dart';
import '../../controllers/park_later_controller.dart';
import '../../controllers/park_now_controller.dart';
import '../../widgets/molecules/containers/credit_card_view.dart';

class PaymentOptionScreen extends StatelessWidget {
  var parkingController = Get.put(ParkingNowController());
  ParkingLaterController parkingLaterController =
      Get.put(ParkingLaterController());
  final GlobalKey<FormState> _vehicleNumberKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  PaymentOptionScreen({Key? key}) : super(key: key);
  var userController = Get.find<UserController>();
  var parkingType = Get.arguments[0];
  var bookingType = Get.arguments[1];
  var bookingPrice = Get.arguments[2];
  var currency = Get.arguments[3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
          "Payment Options",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(text: "Payment Methods"),
          ),
          const SizedBox(
            height: 30,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userController.cardList.value.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CreditCardView(
                      cardDetail: userController.cardList[index]),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: InkWell(
              onTap: () {
                if (currency == 'LKR') {
                  if (parkingType == 'parkLater') {
                    if (bookingType == "Monthly") {
                      parkingLaterController.payHereDraftBookingMonthly(
                          parkingId:
                              parkingLaterController.parkLaterLocationData.id!,
                          context: context,
                          parkingFromTime: parkingLaterController
                              .parkingFromTime!.millisecondsSinceEpoch,
                          parkingUntilTime: parkingLaterController
                              .parkingUntilTime!.millisecondsSinceEpoch);
                    } else {
                      parkingLaterController
                          .payHereHourleyParkLaterDraftBooking(
                              parkingId: parkingLaterController
                                  .parkLaterLocationData.id!,
                              context: context,
                              parkingFromTime: parkingLaterController
                                  .parkingFromTime!.millisecondsSinceEpoch,
                              parkingUntilTime: parkingLaterController
                                  .parkingUntilTime!.millisecondsSinceEpoch);
                    }
                  } else {
                    parkingController.payHereDraftBooking(
                        context: context,
                        parkingFromTime: parkingController
                            .parkingFromTime!.millisecondsSinceEpoch,
                        parkingUntilTime: parkingController
                            .parkingUntilTime!.millisecondsSinceEpoch,
                        ctrl: parkingController);
                  }
                } else {
                  Get.toNamed(
                      arguments: [parkingType, bookingType, bookingPrice],
                      Routes.ADD_PAYMENT_METHOD_SCREEN);
                }
              },
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.plus, size: 15),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Add Payment Method",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.appColorBlack01,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: CustomFilledButton(text: "Save", clickEvent: () {}),
          // ),
        ],
      ),
    );
  }
}
