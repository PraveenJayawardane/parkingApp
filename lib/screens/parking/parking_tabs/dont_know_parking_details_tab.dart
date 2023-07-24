import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/atoms/app_label.dart';
import '../../../widgets/molecules/buttons/bordered_button.dart';

class DontKnowParkingDetailsTab extends StatefulWidget {
  // final Dontknowparkingbooking dontknowparkingbooking;
  final BookingDetail dontknowparkingbooking;
  const DontKnowParkingDetailsTab(
      {Key? key, required this.dontknowparkingbooking})
      : super(key: key);

  @override
  State<DontKnowParkingDetailsTab> createState() =>
      _DontKnowParkingDetailsTabState();
}

class _DontKnowParkingDetailsTabState extends State<DontKnowParkingDetailsTab> {
  var parkingController = Get.find<ParkingNowController>();

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget
        .dontknowparkingbooking.carPark!.first.images!
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1,
                  color: AppColors.appColorLightGray.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LocationCodeView(
                    postCode:
                        widget.dontknowparkingbooking.carPark?[0].postCode ??
                            '-',
                    addressOne: widget.dontknowparkingbooking.carPark?[0]
                            .addressLineOne ??
                        '-',
                    parkingId:
                        '${widget.dontknowparkingbooking.carPark?[0].carParkPIN ?? '-'}',
                    parkName:
                        widget.dontknowparkingbooking.carPark?[0].carParkName ??
                            '-',
                    city: widget.dontknowparkingbooking.carPark?[0].city ?? '-',
                    addressTow: widget.dontknowparkingbooking.carPark?[0]
                            .addressLineTwo ??
                        '-',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: widget
                          .dontknowparkingbooking.carPark!.first.images!.isEmpty
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
                              children: widget
                                  .dontknowparkingbooking.carPark!.first.images!
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
                                        color: (Theme.of(context).brightness ==
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Booking ID",
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                              AppLabel(
                                text: widget.dontknowparkingbooking.bookingId ??
                                    '-',
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
                                height: 25,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: widget.dontknowparkingbooking
                                                .status ==
                                            "Active"
                                        ? AppColors.appColorGreen
                                            .withOpacity(0.2)
                                        : widget.dontknowparkingbooking
                                                    .status ==
                                                "Upcoming"
                                            ? AppColors.appColorOrange
                                                .withOpacity(0.2)
                                            : widget.dontknowparkingbooking
                                                        .status ==
                                                    "Completed"
                                                ? AppColors.appColorLightGray
                                                    .withOpacity(0.4)
                                                : AppColors.appColorGoogleRed
                                                    .withOpacity(0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: widget.dontknowparkingbooking.status ==
                                          "Active"
                                      ? const Text(
                                          "Active",
                                          style: TextStyle(
                                              color: AppColors.appColorGreen),
                                        )
                                      : widget.dontknowparkingbooking.status ==
                                              "Upcoming"
                                          ? const Text(
                                              "Upcoming",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.appColorOrange),
                                            )
                                          : widget.dontknowparkingbooking
                                                      .status ==
                                                  "Completed"
                                              ? const Text(
                                                  "Completed",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .appColorGray),
                                                )
                                              : const Text(
                                                  "Cancelled",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .appColorGoogleRed),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Vehicle Number",
                                textColor: AppColors.appColorLightGray,
                                fontSize: 14,
                              ),
                              AppLabel(
                                text: widget.dontknowparkingbooking.vehicle?[0]
                                        .vRN ??
                                    '-',
                                fontSize: 14,
                                textColor: AppColors.appColorBlack,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Payment Method",
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       ),
                        //       AppLabel(
                        //         text: "VISA ending in 0234",
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       )
                        //     ],
                        //   ),
                        // ),
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
                              AppLabel(
                                text:
                                    widget.dontknowparkingbooking.bookingDate ??
                                        '-',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppLabel(
                                text: "Permit Start",
                                fontSize: 14,
                                textColor:
                                    const Color.fromRGBO(189, 189, 189, 1),
                              ),
                              AppLabel(
                                text: widget.dontknowparkingbooking
                                            .bookingStart !=
                                        null
                                    ? DateFormat('yyyy-MM-dd HH:mm ').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            widget.dontknowparkingbooking
                                                .bookingStart!))
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
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Permit End",
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorLightGray,
                        //       ),
                        //       AppLabel(
                        //         text: dontknowparkingbooking.bookingEnd != null
                        //             ? DateFormat('yyyy-MM-dd hh:mm a').format(
                        //                 DateTime.fromMillisecondsSinceEpoch(
                        //                     dontknowparkingbooking.bookingEnd!))
                        //             : '',
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorBlack,
                        //         fontWeight: FontWeight.bold,
                        //       )
                        //     ],
                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppLabel(
                        //         text: "Total Parking Fee",
                        //         fontSize: 14,
                        //       ),
                        //       AppLabel(
                        //         text:
                        //             '£ ${dontknowparkingbooking.totalFee?.toStringAsFixed(2) ?? '-'}',
                        //         fontSize: 14,
                        //         textColor: AppColors.appColorBlack,
                        //         fontWeight: FontWeight.bold,
                        //       )
                        //     ],
                        //   ),
                        // ),
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

                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: AppColors.appColorWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: BorderedButton(
                text: "View receipt",
                clickEvent: () {
                  // Get.toNamed(Routes.PARK_NOW_RECIPT_SCREEN,
                  //     arguments: dontknowparkingbooking);
                }),
          ),
        ),
      ],
    );
  }
}
