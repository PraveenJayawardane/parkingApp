import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../utils/app_timeZone.dart';
import '../../../widgets/atoms/app_label.dart';

class FixedDurationParkingDetailsTab extends StatefulWidget {
  final FixedDurationbooking parkNowBooking;

  const FixedDurationParkingDetailsTab({Key? key, required this.parkNowBooking})
      : super(key: key);

  @override
  State<FixedDurationParkingDetailsTab> createState() =>
      _FixedDurationParkingDetailsTabState();
}

class _FixedDurationParkingDetailsTabState
    extends State<FixedDurationParkingDetailsTab> {
  var parkingController = Get.find<ParkingNowController>();

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.parkNowBooking.carPark!.images!
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                          imageUrl: item, fit: BoxFit.fill, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ))
        .toList();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: LocationCodeView(
                      postCode: widget.parkNowBooking.carPark?.postCode ?? '',
                      parkingId:
                          '${widget.parkNowBooking.carPark?.carParkPIN ?? ''}',
                      parkName:
                          widget.parkNowBooking.carPark?.carParkName ?? '',
                      city: widget.parkNowBooking.carPark?.city ?? '',
                      addressOne:
                          widget.parkNowBooking.carPark?.addressLineOne ?? '',
                      addressTow:
                          widget.parkNowBooking.carPark?.addressLineTwo ?? '',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: widget.parkNowBooking.carPark!.images!.isEmpty
                        ? false
                        : true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Column(
                            children: [
                              Expanded(
                                child: CarouselSlider(
                                  items: imageSliders,
                                  carouselController: _controller,
                                  options: CarouselOptions(
                                      autoPlay: false,
                                      enlargeCenterPage: true,
                                      aspectRatio: 2.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.parkNowBooking.carPark!.images!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black)
                                              .withOpacity(_current == entry.key
                                                  ? 0.9
                                                  : 0.4)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                AppLabel(
                                  text: "Booking ID",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                const Spacer(),
                                AppLabel(
                                  text: widget
                                          .parkNowBooking.booking?.bookingId ??
                                      '-',
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                  textOverflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Status",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                Container(
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: widget.parkNowBooking.booking
                                                  ?.status ==
                                              "Active"
                                          ? AppColors.appColorGreen
                                              .withOpacity(0.2)
                                          : widget.parkNowBooking.booking
                                                      ?.status ==
                                                  "Upcoming"
                                              ? AppColors.appColorOrange
                                                  .withOpacity(0.2)
                                              : widget.parkNowBooking.booking
                                                          ?.status ==
                                                      "Completed"
                                                  ? AppColors.appColorLightGray
                                                      .withOpacity(0.4)
                                                  : AppColors.appColorGreen
                                                      .withOpacity(0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: widget.parkNowBooking.booking
                                                ?.status ==
                                            "Active"
                                        ? const Text(
                                            "Active",
                                            style: TextStyle(
                                                color: AppColors.appColorGreen),
                                          )
                                        : widget.parkNowBooking.booking
                                                    ?.status ==
                                                "Upcoming"
                                            ? const Text(
                                                "Upcoming",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .appColorOrange),
                                              )
                                            : widget.parkNowBooking.booking
                                                        ?.status ==
                                                    "Completed"
                                                ? const Text(
                                                    "Completed",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appColorGray),
                                                  )
                                                : const Text(
                                                    "Active",
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .appColorGreen),
                                                  ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Vehicle Number",
                                  textColor: AppColors.appColorLightGray,
                                  fontSize: 14,
                                ),
                                AppLabel(
                                  text:
                                      widget.parkNowBooking.vehicle?.vRN ?? '-',
                                  fontSize: 14,
                                  textColor: AppColors.appColorBlack,
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Booked On",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                AppLabel(
                                  text: widget.parkNowBooking.booking
                                          ?.bookingDate ??
                                      '',
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Parking From",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                AppLabel(
                                  text: widget.parkNowBooking.booking
                                              ?.bookingStart !=
                                          null
                                      ? '${DateFormat("yyyy-MM-dd  hh:mm a").format(AppTimeZone.getTimeZone(timeZoneName: widget.parkNowBooking.booking!.timeZone!, milliseconds: widget.parkNowBooking.booking!.bookingStart!))} '
                                      : '',
                                  fontSize: 14,
                                  textColor: AppColors.appColorBlack,
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Parking Until",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                AppLabel(
                                  text: widget.parkNowBooking.booking
                                              ?.bookingEnd !=
                                          null
                                      ? '${DateFormat("yyyy-MM-dd  hh:mm a").format(AppTimeZone.getTimeZone(timeZoneName: widget.parkNowBooking.booking!.timeZone!, milliseconds: widget.parkNowBooking.booking!.bookingEnd!))} '
                                      : '',
                                  fontSize: 14,
                                  textColor: AppColors.appColorBlack,
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Duration",
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                ),
                                AppLabel(
                                  text:
                                      '${ParkingNowController().getDuration(widget.parkNowBooking.booking!.duration!)}',
                                  fontSize: 14,
                                  textColor: AppColors.appColorLightGray,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLabel(
                                  text: "Total Parking fee",
                                  fontSize: 14,
                                ),
                                AppLabel(
                                  text:
                                      '${widget.parkNowBooking.carPark?.currency}${widget.parkNowBooking.booking?.totalFee?.toStringAsFixed(2) ?? ''}',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //   child:
                  //       CustomFilledButton(text: "Extend Booking", clickEvent: () {}),
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: BorderedButton(
          //       text: "View receipt",
          //       clickEvent: () {
          //         Get.toNamed(Routes.PARK_NOW_FIXED_DURATION_RECIPT_SCREEN,
          //             arguments: parkNowBooking);
          //       }),
          // ),
        ],
      ),
    );
  }
}
