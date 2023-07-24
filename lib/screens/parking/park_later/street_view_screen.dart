import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';

class StreetViewScreen extends StatelessWidget {
  double latitude = Get.arguments[0];
  double longitude = Get.arguments[1];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              FlutterGoogleStreetView(
                initPos: LatLng(latitude, longitude),
                initSource: StreetViewSource.outdoor,
                initBearing: 30,
                streetNamesEnabled: true,
                userNavigationEnabled: true,
                zoomGesturesEnabled: true,
                onStreetViewCreated: (StreetViewController controller) async {},
              ),
              Positioned(
                top: 12.0,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Card(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: AppColors.appColorWhite,
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.appColorBlack,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
