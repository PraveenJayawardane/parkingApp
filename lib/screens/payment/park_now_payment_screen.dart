import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:flutterme_credit_card/flutterme_credit_card.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/park_now_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ParkNowPaymentScreen extends StatelessWidget {
  ParkNowPaymentScreen({super.key});

  final GlobalKey<FormState> paymentKey = GlobalKey<FormState>();
  var userController = Get.find<UserController>();
  var parkingController = Get.put(ParkingNowController());
  var bookingController = Get.put(BookingController());
  var accountController = Get.put(AccountController());
  TextEditingController paymentController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  late TextEditingController cardNumber = TextEditingController();
  late TextEditingController expiryDate = TextEditingController();
  late TextEditingController cvv = TextEditingController();
  late TextEditingController firstName = TextEditingController();
  late TextEditingController lastName = TextEditingController();
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
          title: const Text('Payment',
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
                      AppLabel(text: 'First name'),
                      FMHolderField(
                        controller: firstName,
                        onChanged: (value) {
                          firstName.value = TextEditingValue(
                              text: toBeginningOfSentenceCase(value)!,
                              selection: firstName.selection);
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'First is required')
                        ]),
                        decoration: const InputDecoration(
                          hintText: "John",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppLabel(text: 'Last name'),
                      FMHolderField(
                        controller: lastName,
                        onChanged: (value) {
                          lastName.value = TextEditingValue(
                              text: toBeginningOfSentenceCase(value)!,
                              selection: lastName.selection);
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Last name is required')
                        ]),
                        decoration: const InputDecoration(
                          hintText: "Doe",
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
                        onChanged: (value) {
                          postalCode.value = TextEditingValue(
                              text: value.toUpperCase(),
                              selection: postalCode.selection);
                        },
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomFilledButton(
                  text: 'Save',
                  clickEvent: () {
                    if (formKey.currentState!.validate()) {
                      // AccountController().saveCardDetail(
                      //     firstName: firstName.text,
                      //     lastName: lastName.text,
                      //     context: context,
                      //     cardNumber: cardNumber.text.numericOnly(),
                      //     expiry: expiryDate.text.numericOnly());
                    }

                    // print(parkingController.parkingDetails.value.id!);
                    // print(parkingController.parkingFromTime!.millisecond
                    //     .toString());
                    // print(parkingController.parkingUntilTime!.millisecond
                    //     .toString());
                    // print(parkingController.parkingFee.value.data?.slotID);

                    // if (parkingController.isIDontKnowParkingTime.value ==
                    //     false) {
                    //   print('----------------booking id');
                    //   print(parkingController.bookingId.value);
                    //   bookingController.makeFixedDurationBooking(
                    //       vaultId: userController
                    //           .selectedCard.value!.customerVaultId!,
                    //       context: context,
                    //       parkingType: "parkNow",
                    //       bookingId: parkingController.bookingId.value);
                    // } else {
                    //   bookingController.makeDontKnowDurationBooking(
                    //     context: context,
                    //     parkingType: "dontKnowParking",
                    //     vehicleNumberPate: userController.dropDownValue.value,
                    //     carParkId: parkingController.parkingDetails.value.id!,
                    //     bookingStartTime:
                    //         DateTime.now().millisecondsSinceEpoch.toString(),
                    //   );
                    // }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
