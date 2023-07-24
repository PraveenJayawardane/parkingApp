import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class BookingimageloadingShimmer extends StatelessWidget {
  const BookingimageloadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors().shimmerBaseColor,
      highlightColor: AppColors().shimmerLightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors().shimmerContainerColor,
              borderRadius: BorderRadius.circular(6)
              ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/5,
          // child: ClipRRect(
          //   borderRadius: BorderRadius.circular(6),
          //   child: Container(
          //     // height: 8,
          //     // width: 50,
          //     decoration: BoxDecoration(
          //         color: AppColors().shimmerContainerColor,
          //         borderRadius: BorderRadius.circular(10)),
          //   ),
          // ),
        ),
      ),
    );
  }
}
