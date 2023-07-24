import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';

import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';


import '../../../constants/app_colors.dart';
import '../../../model/fixed_duration_booking.dart';


class ParkNowFixedDurationReceiptScreen extends StatelessWidget {
  ParkNowFixedDurationReceiptScreen({Key? key}) : super(key: key);

  FixedDurationbooking bookingDetail = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Receipt",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                    'assets/images/app_launcher_icon.png'),
                              ),
                              const Text('Parkfinda')
                            ]),
                        const Divider(
                          thickness: 1,
                          color: AppColors.appColorLightGray,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                          "${bookingDetail.carPark?.addressLineOne ?? '-'},${bookingDetail.carPark?.addressLineTwo ?? '-'},${bookingDetail.carPark?.city ?? '-'}",
                                          style: const TextStyle(fontSize: 12)),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Phone: +44 (0) 20 7430 9371",
                                        style: TextStyle(fontSize: 12)),
                                    Text("Email: info@parkfinda.com",
                                        style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("VAT No : 331 4080 12",
                                        style: TextStyle(fontSize: 13)),
                                    Text("Receipt No : 12345678",
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Receipt Date : ${bookingDetail.booking?.bookingDate ?? ''}",
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Location",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              bookingDetail
                                                      .carPark?.carParkName ??
                                                  '-',
                                              style: const TextStyle(
                                                color:
                                                    AppColors.appColorLightGray,
                                                fontSize: 14,
                                              )),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Permit Number",
                                              style: TextStyle(fontSize: 14)),
                                          Text("2307-29987",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Status",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              bookingDetail.booking?.status ??
                                                  '-',
                                              style:
                                                  const TextStyle(
                                                      color: AppColors
                                                          .appColorLightGray,
                                                      fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Permit Start",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              '${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).year}-${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).month < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).month}-${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).day < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).day}  ${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).hour < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).hour}:${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).minute < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingStart ?? 1).minute}',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Permit End",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              '${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).year}-${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).month < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).month}-${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).day < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).day}  ${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).hour < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).hour}:${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).minute < 10 ? '0' : ''}${DateTime.fromMillisecondsSinceEpoch(bookingDetail.booking?.bookingEnd ?? 1).minute}',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text("Number of Vehicles",
                                              style: TextStyle(fontSize: 14)),
                                          Text("1",
                                              style: TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("License Plate Number",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              bookingDetail.vehicle?.vRN ?? '-',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Customer Name",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              SharedPref()
                                                      .getUser()
                                                      .firstName ??
                                                  '',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Booked On",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              bookingDetail
                                                      .booking?.bookingDate ??
                                                  '-',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Parking Price",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              '\$ ${bookingDetail.booking?.bookingFee ?? '-'}',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Service Fee",
                                              style: TextStyle(fontSize: 14)),
                                          Text(
                                              '\$ ${bookingDetail.booking?.serviceFee ?? '-'}',
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .appColorLightGray,
                                                  fontSize: 14)),
                                        ]),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Cost",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          '\$ ${bookingDetail.booking?.totalFee ?? '-'}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color:
                                                  AppColors.appColorLightGray,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                 
                
              
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(
                text: "Download Receipt",
                clickEvent: () async {
                  // screenshotController
                  //     .capture(delay: const Duration(seconds: 1))
                  //     .then((value) {
                  //   if (value != null) {
                  //     PdfApi().generatePdf(value);
                  //   }
                  // });
                }),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BorderedButton(text: "Email Receipt", clickEvent: () {}),
          ),
        ],
      ),
    );
  }
}
