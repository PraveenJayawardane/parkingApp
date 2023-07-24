import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:shimmer/shimmer.dart';

class BookingstatusloadingShimmer extends StatelessWidget {
  const BookingstatusloadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors().shimmerBaseColor,
      highlightColor: AppColors().shimmerLightColor,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors().shimmerContainerColor,
                            borderRadius: BorderRadius.circular(10)),
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 17,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: AppColors().shimmerContainerColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: AppColors().shimmerContainerColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.appColorLightGray)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.appColorLightGray)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.car,
                    color: AppColors.appColorGray,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      AppLabel(text: "RK71CBX"),
                      SizedBox(
                        height: 8,
                      ),
                      AppLabel(
                        text: "MG Black",
                        textColor: AppColors.appColorLightGray,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),
          CircularCountDownTimer(
            duration: 120,
            initialDuration: 0,
            width: 200,
            height: 200,
            ringColor: AppColors.appColorLightGray.withOpacity(0.5),
            ringGradient: null,
            fillColor: AppColors.appColorGreen,
            fillGradient: null,
            backgroundColor: AppColors.appColorWhite,
            backgroundGradient: null,
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
                fontSize: 33.0,
                color: AppColors.appColorBlack,
                fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.HH_MM_SS,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {},
            onComplete: () {},
            onChange: (String timeStamp) {},
          ),

          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width/0.50,
            decoration: BoxDecoration(
                color: AppColors().shimmerContainerColor,
                borderRadius: BorderRadius.circular(10)),
          ),

        ],
      ),
    );
  }
}
