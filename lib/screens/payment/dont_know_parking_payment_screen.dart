import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:flutterme_credit_card/flutterme_credit_card.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/park_now_controller.dart';
import '../../controllers/user_controller.dart';

class DontKnowParkingPaymentScreen extends StatelessWidget {
  DontKnowParkingPaymentScreen({super.key});

  final GlobalKey<FormState> paymentKey = GlobalKey<FormState>();
  var userController = Get.find<UserController>();
  var parkingController = Get.put(ParkingNowController());
  var bookingController = Get.put(BookingController());
  TextEditingController paymentController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  late TextEditingController cardNumber = TextEditingController();
  late TextEditingController expiryDate = TextEditingController();
  late TextEditingController cvv = TextEditingController();
  late TextEditingController cardName = TextEditingController();
  late TextEditingController postalCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
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
          title: const Text('Add Payment',
              style: TextStyle(color: AppColors.appColorBlack)),
          backgroundColor: AppColors.appColorWhite),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLabel(text: 'Name on the card'),
                      FMHolderField(
                        controller: cardName,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: 'Card holder is required')
                        ]),
                        decoration: const InputDecoration(
                          hintText: "John Doe",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppLabel(text: 'Card number'),
                      FMNumberField(
                        controller: cardNumber,
                        decoration: const InputDecoration(
                          hintText: "xxxx-xxxx-xxxx-xxxx",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(text: 'Expiry'),
                              FMValidThruField(
                                controller: expiryDate,
                                cursorColor: const Color(0xFF49B7AE),
                                decoration: const InputDecoration(
                                  hintText: "****",
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(text: 'CVV'),
                              FMCvvField(
                                controller: cvv,
                                decoration: const InputDecoration(
                                  hintText: "***",
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppLabel(text: 'Postal Code'),
                      FMHolderField(
                        controller: postalCode,
                        decoration: const InputDecoration(
                          hintText: "WC2N5DU",
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 70,
            ),
            CustomFilledButton(
                text: 'Pay',
                width: 300,
                clickEvent: () {
                  if (formKey.currentState!.validate()) {
                    print(parkingController.iDontKnowParkingId.value);
                    print(parkingController.iDontKnowParkingId);
                    print(cardNumber.text.numericOnly());
                    print(expiryDate.text.numericOnly());
                    print(cvv.text);

                    parkingController.confirmIDontKnowParkingBooking(
                        bookingId: parkingController.iDontKnowParkingId.value,
                        parkingType: 'dontKnowParking',
                        context: context,
                        ccnumber: cardNumber.text.numericOnly(),
                        ccexp: expiryDate.text.numericOnly(),
                        cvv: cvv.text);
                  } else {
                    print('invalid!');
                  }
                })
          ],
        ),
      ),
    );
  }
}
