import 'package:flutter/material.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class LocationCodeViewLoadingShimmer extends StatelessWidget {
  const LocationCodeViewLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors().shimmerBaseColor,
      highlightColor: AppColors().shimmerLightColor,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [],
                    ),
                  ),
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
                          height: 20,
                          width: 200,
                          decoration: BoxDecoration(
                              color: AppColors().shimmerContainerColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 20,
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
    );
  }
}
