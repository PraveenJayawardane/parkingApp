import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../utils/app_timeZone.dart';
import '../../../widgets/atoms/app_label.dart';
import '../../../widgets/molecules/buttons/custom_filled_button.dart';
import '../extend_booking/extend_booking_duration_screen.dart';

class FixedDurationBookingDetailsTab extends StatefulWidget {
  final BookingDetail bookingdetail;
  const FixedDurationBookingDetailsTab({
    Key? key,
    required this.bookingdetail,
  }) : super(key: key);

  @override
  State<FixedDurationBookingDetailsTab> createState() =>
      _FixedDurationBookingDetailsTabState();
}

class _FixedDurationBookingDetailsTabState
    extends State<FixedDurationBookingDetailsTab> {
  //var parkingController = Get.find<ParkingNowController>();
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget
        .bookingdetail.carPark!.first.images!
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
      body: SafeArea(
        child: Column(
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
                        postCode:
                            widget.bookingdetail.carPark?[0].postCode ?? '',
                        parkingId:
                            '${widget.bookingdetail.carPark?[0].carParkPIN ?? ''}',
                        parkName:
                            widget.bookingdetail.carPark?[0].carParkName ?? '',
                        addressTow:
                            widget.bookingdetail.carPark?[0].addressLineTwo ??
                                '',
                        addressOne:
                            widget.bookingdetail.carPark?[0].addressLineOne ??
                                '',
                        city: widget.bookingdetail.carPark?[0].city ?? '',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible:
                          widget.bookingdetail.carPark!.first.images!.isEmpty
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
                                        .bookingdetail.carPark!.first.images!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      return GestureDetector(
                                        onTap: () => _controller
                                            .animateToPage(entry.key),
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
                                                  .withOpacity(
                                                      _current == entry.key
                                                          ? 0.9
                                                          : 0.4)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ))),
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
                                    textOverflow: TextOverflow.ellipsis,
                                    text: widget.bookingdetail.bookingId ??
                                        '', //parkNowBooking.bookingId ?? '-',
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        color: widget.bookingdetail.status ==
                                                "Active"
                                            ? AppColors.appColorGreen
                                                .withOpacity(0.2)
                                            : widget.bookingdetail.status ==
                                                    "Upcoming"
                                                ? Colors.amber.withOpacity(0.2)
                                                : widget.bookingdetail.status ==
                                                        "Completed"
                                                    ? AppColors
                                                        .appColorFacebookBlue
                                                        .withOpacity(0.4)
                                                    : AppColors
                                                        .appColorGoogleRed
                                                        .withOpacity(0.2)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: widget.bookingdetail.status ==
                                              "Active"
                                          ? const Text(
                                              "Active",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.appColorGreen),
                                            )
                                          : widget.bookingdetail.status ==
                                                  "Upcoming"
                                              ? const Text(
                                                  "Upcoming",
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                )
                                              : widget.bookingdetail.status ==
                                                      "Completed"
                                                  ? const Text(
                                                      "Completed",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .appColorFacebookBlue),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Vehicle Number",
                                    textColor: AppColors.appColorLightGray,
                                    fontSize: 14,
                                  ),
                                  AppLabel(
                                    text: widget
                                            .bookingdetail.vehicle![0].vRN ??
                                        '-', //parkNowBooking.vehicleNumberPlate ?? '-',
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
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 16.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Booked On",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    text:
                                        '${widget.bookingdetail.bookingDate!.split('T').first.toString() ?? '-'} ${widget.bookingdetail.bookingDate!.split('T').last.toString() ?? '-'}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Parking From",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    fontSize: 14,
                                    textColor: AppColors.appColorBlack,
                                    fontWeight: FontWeight.bold,
                                    text: widget.bookingdetail.bookingStart !=
                                            null
                                        ? '${DateFormat("yyyy-MM-dd  HH:mm").format(AppTimeZone.getTimeZone(timeZoneName: widget.bookingdetail.timeZone!, milliseconds: widget.bookingdetail.bookingStart!))} '
                                        : '',
                                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Parking Until",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    fontSize: 14,
                                    textColor: AppColors.appColorBlack,
                                    fontWeight: FontWeight.bold,
                                    text: widget.bookingdetail.bookingEnd !=
                                            null
                                        ? '${DateFormat("yyyy-MM-dd  HH:mm").format(AppTimeZone.getTimeZone(timeZoneName: widget.bookingdetail.timeZone!, milliseconds: widget.bookingdetail.bookingEnd!))} '
                                        : '',
                                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Duration",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    text:
                                        '${ParkingNowController().getDuration(widget.bookingdetail.duration!)}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Total Parking Fee",
                                    fontSize: 14,
                                  ),
                                  AppLabel(
                                    text:
                                        '${widget.bookingdetail.carPark?.first.currency ?? ''}${widget.bookingdetail.totalFee?.toStringAsFixed(2) ?? '-'}',
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
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            Material(
              elevation: 20,
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.appColorWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5),
                      child: CustomFilledButton(
                          height: 40,
                          text: "Extend Booking",
                          clickEvent: () {
                           
                            Get.to(ExtendBookingDurationScreen(
                              buildContext: context,
                              currency: widget.bookingdetail.carPark?.first.currency,
                              color: widget.bookingdetail.vehicle![0].color,
                              model: widget.bookingdetail.vehicle![0].model,
                              untilTime: widget.bookingdetail.bookingEnd,
                              carParkId: widget.bookingdetail.carPark![0].sId,
                              carParkName:
                                  widget.bookingdetail.carPark![0].carParkName,
                              carParkPin:
                                  widget.bookingdetail.carPark![0].carParkPIN,
                              city: widget.bookingdetail.carPark![0].city,
                              startTime: widget.bookingdetail.bookingStart,
                              bookingId: widget.bookingdetail.sId,
                              vrn: widget.bookingdetail.vehicle![0].vRN,
                              addressTwo: widget.bookingdetail.carPark?[0]
                                      .addressLineTwo ??
                                  '-',
                              addressOne: widget.bookingdetail.carPark?[0]
                                      .addressLineOne ??
                                  '-',
                              postCode:
                                  widget.bookingdetail.carPark?[0].postCode ??
                                      '-',
                            ));
                          }),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: BorderedButton(
                    //       text: "View receipt",
                    //       clickEvent: () {
                    //         Get.toNamed(Routes.PARK_NOW_RECIPT_SCREEN,
                    //             arguments: bookingdetail);
                    //       }),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
