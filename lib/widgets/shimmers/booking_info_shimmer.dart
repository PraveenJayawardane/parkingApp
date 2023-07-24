import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:shimmer/shimmer.dart';

class BookinginfoShimmer extends StatelessWidget {
  const BookinginfoShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors().shimmerBaseColor,
      highlightColor: AppColors().shimmerLightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
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
              height: 20,
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
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 70,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                    textColor: AppColors.appColorLightGray,
                    fontSize: 14,
                  ),
                  Container(
                    height: 8,
                    width: 60,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 100,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 120,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 150,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 150,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                  Container(
                    height: 8,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColors().shimmerContainerColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
