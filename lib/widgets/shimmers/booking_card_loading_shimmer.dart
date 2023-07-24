import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:shimmer/shimmer.dart';

class BookingCardLodingShimmer extends StatelessWidget {
  const BookingCardLodingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors().shimmerBaseColor,
      highlightColor: AppColors().shimmerLightColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 15,
              width: 300,
              decoration: BoxDecoration(
                  color: AppColors().shimmerContainerColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 30,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors().shimmerContainerColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.appColorLightGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLabel(
                      text: "From",
                      fontSize: 14,
                      textColor: AppColors.appColorGray,
                    ),
                    Container(
                      height: 10,
                      width: 170,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.appColorLightGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLabel(
                      text: "Untill",
                      fontSize: 14,
                      textColor: AppColors.appColorGray,
                    ),
                    Container(
                      height: 10,
                      width: 150,
                      decoration: BoxDecoration(
                          color: AppColors().shimmerContainerColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: AppColors().shimmerContainerColor,
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}
