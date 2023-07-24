import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';

class LocationCodeView extends StatelessWidget {
  final String parkName;
  final String addressOne;
  final String addressTow;
  final String city;
  final String parkingId;
  final String? postCode;
  const LocationCodeView({
    Key? key,
    required this.parkName,
    required this.parkingId,
    required this.postCode,
    required this.addressOne,
    required this.addressTow,
    required this.city,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.appColorWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.appColorLightGray,
              offset: Offset(
                1.0,
                1.0,
              ),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  AppLabel(
                    text: parkingId,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  AppLabel(text: "Location ID", fontSize: 14),
                ],
              )),
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6)),
                      color: Color.fromARGB(255, 237, 236, 236),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 8, bottom: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabel(
                            text: parkName,
                            fontSize: 16,
                          ),
                          // AppLabel(
                          //   text: addressOne,
                          //   fontSize: 10,
                          //   textOverflow: TextOverflow.ellipsis,
                          // ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // AppLabel(
                              //   text: addressTow,
                              //   fontSize: 10,
                              //   textOverflow: TextOverflow.ellipsis,
                              // ),
                              // Visibility(
                              //   visible: addressTow != "",
                              //   child: AppLabel(
                              //     text: ',',
                              //     fontSize: 10,
                              //     textOverflow: TextOverflow.ellipsis,
                              //   ),
                              // ),
                              AppLabel(
                                text: "$postCode ",
                                fontSize: 10,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              AppLabel(
                                text: city ?? '',
                                fontSize: 10,
                                textOverflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
