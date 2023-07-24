import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/bordered_button.dart';

import '../../../constants/routes.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/park_later_controller.dart';
import '../../../utils/google_map_style.dart';
import '../../../widgets/atoms/app_label.dart';
import '../../../widgets/molecules/containers/location_code_view.dart';

class ParkLaterBookedDetailsScreen extends StatelessWidget {
  GoogleMapController? mapController;
  CountDownController countDownController = CountDownController();
  BookingController bookingController = Get.find<BookingController>();

  ParkLaterBookedDetailsScreen({Key? key}) : super(key: key);
  ParkingLaterController parkingLaterController =
      Get.find<ParkingLaterController>();
  List<MarkerData> allMarkers = [];

  _customMarker(String? price) {
    return Column(
      children: const [
        FaIcon(
          FontAwesomeIcons.locationDot,
          color: AppColors.appColorBlack,
          size: 16,
        )
      ],
    );
  }

  loadLocation() {
    //TODO FILTER THE EV, RV LOCATION FROM SAME API
    LatLng latlng;
    latlng = LatLng(bookingController.parkLaterBooking.carPark!.latitude!,
        bookingController.parkLaterBooking.carPark!.longitude!);

    allMarkers.add(
      MarkerData(
          marker: Marker(
              markerId:
                  MarkerId(bookingController.parkLaterBooking.booking!.id!),
              position: latlng),
          child: _customMarker("")),
    );
  }

  @override
  Widget build(BuildContext context) {
    //loadLocation();
    var bookingStart = DateTime.fromMillisecondsSinceEpoch(
        bookingController.parkLaterBooking.booking!.bookingStart!);
    var bookingEnd = DateTime.fromMillisecondsSinceEpoch(
        bookingController.parkLaterBooking.booking!.bookingEnd!);
    var parkDuration = Duration(
            milliseconds: bookingController.parkLaterBooking.booking!.duration!)
        .inSeconds;
    var deferenceOfParkingStart = DateTime.now().difference(bookingStart);
    var availableIme = parkDuration - deferenceOfParkingStart.inSeconds;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.offAllNamed(Routes.DIRECT_DASHBOARD);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Card(
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: AppColors.appColorWhite,
                    borderRadius: BorderRadius.circular(4)),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.appColorBlack,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: CustomGoogleMapMarkerBuilder(
                  customMarkers: allMarkers,
                  screenshotDelay: const Duration(milliseconds: 0),
                  builder: (BuildContext context, Set<Marker>? markers) {
                    return GoogleMap(
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      markers: markers ?? {},
                      onMapCreated: (controller) {
                        mapController = controller;
                        mapController
                            ?.setMapStyle(GoogleMapStyle.googleMapStyle);
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            bookingController
                                .parkLaterBooking.carPark!.latitude!,
                            bookingController
                                .parkLaterBooking.carPark!.longitude!,
                          ),
                          zoom: 16),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LocationCodeView(
                postCode:
                    '${bookingController.parkLaterBooking.carPark!.postCode}',
                parkName:
                    '${bookingController.parkLaterBooking.carPark!.carParkName}',
                addressOne:
                    '${bookingController.parkLaterBooking.carPark!.addressLineOne}',
                parkingId:
                    "${bookingController.parkLaterBooking.carPark!.carParkPIN}",
                city: '${bookingController.parkLaterBooking.carPark!.city}',
                addressTow:
                    "${bookingController.parkLaterBooking.carPark!.addressLineTwo}",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.appColorLightGray)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        AppLabel(
                          text: "Parking From",
                          fontSize: 14,
                          textColor: AppColors.appColorGray,
                        ),
                        AppLabel(
                          text:
                              "${bookingStart.hour < 10 ? "0${bookingStart.hour}" : bookingStart.hour}:${bookingStart.minute < 10 ? "0${bookingStart.minute}" : bookingStart.minute}",
                          fontWeight: FontWeight.bold,
                        ),
                        AppLabel(
                          text:
                              "${bookingStart.day} ${getMonth(bookingStart.month)} ${parkingLaterController.getFormattedDay(bookingStart)}",
                          fontSize: 14,
                          textColor: AppColors.appColorGray,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.appColorLightGray)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        AppLabel(
                          text: "Parking Until",
                          fontSize: 14,
                          textColor: AppColors.appColorGray,
                        ),
                        AppLabel(
                          text:
                              "${bookingEnd.hour < 10 ? "0${bookingEnd.hour}" : bookingEnd.hour}:${bookingEnd.minute < 10 ? "0${bookingEnd.minute}" : bookingEnd.minute}",
                          fontWeight: FontWeight.bold,
                        ),
                        AppLabel(
                          text:
                              "${bookingEnd.day} ${getMonth(bookingEnd.month)} ${parkingLaterController.getFormattedDay(bookingEnd)}",
                          fontSize: 14,
                          textColor: AppColors.appColorGray,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.car,
                              color: AppColors.appColorGray,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLabel(
                                  text:
                                      "${bookingController.parkLaterBooking.vehicle?.vRN}",
                                  fontWeight: FontWeight.w500,
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                AppLabel(
                                  text:
                                      "${bookingController.parkLaterBooking.vehicle?.model ?? ""} (${bookingController.parkLaterBooking.vehicle?.color})",
                                  textColor: AppColors.appColorGray,
                                  fontSize: 12,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 14),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLabel(text: 'Booking Fee'),
                                AppLabel(
                                  text:
                                      "${bookingController.parkLaterBooking.carPark?.currency ?? ''}${bookingController.parkLaterBooking.booking?.totalFee?.toStringAsFixed(2) ?? ''}",
                                  textColor: AppColors.appColorGray,
                                  fontSize: 12,
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            CircularCountDownTimer(
              duration: parkDuration,
              initialDuration: parkDuration - availableIme,
              controller: countDownController,
              width: 150,
              height: 150,
              ringColor: AppColors.appColorGreen,
              ringGradient: null,
              fillColor: AppColors.appColorGreen,
              fillGradient: null,
              backgroundColor: AppColors.appColorWhite,
              backgroundGradient: null,
              strokeWidth: 20.0,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(
                  fontSize: 24.0,
                  color: AppColors.appColorBlack,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.HH_MM_SS,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {},
              onComplete: () {},
              onChange: (String timeStamp) {},
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //     flex: 3,
                  //     child: CustomFilledButton(
                  //         text: "Extend Booking",
                  //         clickEvent: () {
                  //           Get.to(ExtendBookingDurationScreen(
                  //             color: bookingController
                  //                 .parkLaterBooking.vehicle!.color,
                  //             model: bookingController
                  //                 .parkLaterBooking.vehicle!.model,
                  //             buildContext: context,
                  //             untilTime: bookingController
                  //                 .parkLaterBooking.booking!.bookingEnd!,
                  //             carParkId: bookingController
                  //                 .parkLaterBooking.carPark!.id,
                  //             carParkName: bookingController
                  //                 .parkLaterBooking.carPark!.carParkName,
                  //             carParkPin: bookingController
                  //                 .parkLaterBooking.carPark!.carParkPIN,
                  //             city: bookingController
                  //                 .parkLaterBooking.carPark!.addressLineOne,
                  //             startTime: bookingStart.millisecondsSinceEpoch,
                  //             bookingId: bookingController
                  //                 .parkLaterBooking.booking!.id,
                  //             vrn: bookingController
                  //                 .parkLaterBooking.vehicle!.vRN,
                  //           ));
                  //         })),

                  Expanded(
                      flex: 2,
                      child: BorderedButton(
                        text: 'Manage Booking',
                        clickEvent: () {
                          Get.toNamed(Routes.SINGLE_BOOK_SCREEN,
                              arguments: bookingController.upcomingBooking[0]);
                        },
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: BorderedButton(
                        text: 'Help',
                        clickEvent: () {
                          Get.toNamed(Routes.HELP_SCREEN);
                        },
                      )),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  String? getFormattedDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final parkingDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final parkingDayName = DateTime(dateTime.month, dateTime.day);
    if (parkingDay == today) {
      return 'Today';
    } else if (parkingDay == tomorrow) {
      return 'Tomorrow';
    } else {
      return "";
    }
  }

  String getMonth(int monthNo) {
    String pickedMon = "";
    var months = {
      1: "Jan",
      2: "Feb",
      3: "Mar",
      4: "Apr",
      5: "May",
      6: "Jun",
      7: "Jul",
      8: "Agu",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec",
    };

    months.forEach((key, value) {
      if (key == monthNo) {
        pickedMon = value;
      }
    });

    return pickedMon;
  }
}
