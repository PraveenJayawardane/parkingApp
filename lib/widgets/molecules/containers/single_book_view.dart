import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../constants/routes.dart';
import '../../../controllers/park_now_controller.dart';
import '../../../model/Bookingdetail.dart';
import '../../../utils/app_bottom_sheets.dart';
import '../../../utils/app_timeZone.dart';
import '../../atoms/app_label.dart';
import '../buttons/bordered_button.dart';
import '../buttons/custom_filled_button.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SingleBookView extends StatefulWidget {
  final BookingDetail? booking;
  const SingleBookView({
    Key? key,
    required this.booking,
  }) : super(key: key);

  @override
  State<SingleBookView> createState() => _SingleBookViewState();
}

class _SingleBookViewState extends State<SingleBookView> {
  var isRated = false.obs;

  var userController = Get.find<UserController>();

  var bookingController = Get.find<BookingController>();

  var parkNowController = Get.find<ParkingNowController>();

  int _current = 0;
  final CarouselController _controller = CarouselController();

  getTime() {
    parkNowController.showParkingFrom =
        "${DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingStart!).day == DateTime.now().day ? 'Today' : DateFormat('dd MMM').format(DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingStart!))} at ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingStart!))}"
            .obs;
    parkNowController.showParkingUntil =
        "${DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingEnd!).day == DateTime.now().day ? 'Today' : DateFormat('dd MMM').format(DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingEnd!))}  at ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingEnd!))}"
            .obs;
    parkNowController.parkingFromTime =
        DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingStart!);
    parkNowController.parkingUntilTime =
        DateTime.fromMillisecondsSinceEpoch(widget.booking!.bookingEnd!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.booking!.carPark!.first.images!
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LocationCodeView(
                        addressOne:
                            widget.booking?.carPark?[0].addressLineOne ?? '',
                        addressTow:
                            widget.booking?.carPark?[0].addressLineTwo ?? '',
                        postCode: widget.booking?.carPark?[0].postCode ?? '',
                        parkingId:
                            '${widget.booking?.carPark?[0].carParkPIN ?? ''}',
                        parkName: widget.booking?.carPark?[0].carParkName ?? '',
                        city: widget.booking?.carPark?[0].city ?? '',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: widget.booking!.carPark!.first.images!.isEmpty
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
                                      .booking!.carPark!.first.images!
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
                                            color:
                                                (Theme.of(context).brightness ==
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
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        margin: EdgeInsets.zero,
                        child: Column(
                          children: [
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
                                    text: "Booking ID",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    text: widget.booking?.bookingId ?? '',
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
                                        color: widget.booking?.status ==
                                                "Active"
                                            ? AppColors.appColorGreen
                                                .withOpacity(0.2)
                                            : widget.booking?.status ==
                                                    "Upcoming"
                                                ? Colors.amber.withOpacity(0.2)
                                                : widget.booking?.status ==
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
                                      child: widget.booking?.status == "Active"
                                          ? const Text(
                                              "Active",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.appColorGreen),
                                            )
                                          : widget.booking?.status == "Upcoming"
                                              ? const Text(
                                                  "Upcoming",
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                )
                                              : widget.booking?.status ==
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
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Vehicle Number",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: widget.booking?.status == "Upcoming"
                                        ? () {
                                            Get.toNamed(
                                                Routes.CHANGE_VEHICAL_SCREEN,
                                                arguments: widget.booking!.sId);
                                          }
                                        : null,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => AppLabel(
                                            text: userController
                                                        .selectedVehicleInUpcomeingBooking
                                                        ?.value
                                                        ?.vRN ==
                                                    null
                                                ? widget.booking?.vehicle![0]
                                                        .vRN ??
                                                    ''
                                                : userController
                                                        .selectedVehicleInUpcomeingBooking
                                                        ?.value
                                                        ?.vRN ??
                                                    '',
                                            fontSize: 14,
                                            textColor: AppColors.appColorBlack,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Visibility(
                                          visible: widget.booking?.status ==
                                              "Upcoming",
                                          child: const Icon(
                                            FontAwesomeIcons.penToSquare,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                                    text: widget.booking?.bookingDate ?? '',
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
                                    text: widget.booking?.bookingStart != null
                                        ? DateFormat('yyyy MMM dd HH:mm')
                                            .format(AppTimeZone.getTimeZone(
                                                timeZoneName:
                                                    widget.booking!.timeZone!,
                                                milliseconds: widget
                                                    .booking!.bookingStart!))
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLabel(
                                    text: "Parking Until",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    text: widget.booking!.bookingEnd != null
                                        ? DateFormat('yyyy MMM dd HH:mm')
                                            .format(AppTimeZone.getTimeZone(
                                                timeZoneName:
                                                    widget.booking!.timeZone!,
                                                milliseconds: widget
                                                    .booking!.bookingEnd!))
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
                                        '${ParkingNowController().getDuration(widget.booking!.duration!)}',
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
                                        '${widget.booking?.carPark?.first.currency ?? ''}${widget.booking?.totalFee?.toStringAsFixed(2) ?? ''}',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: widget.booking?.status == 'Completed',
                      child: isRated.value
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Column(
                                      children: [
                                        AppLabel(
                                          text: "You rated",
                                          fontSize: 16,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          unratedColor: AppColors
                                              .appColorLightGray
                                              .withOpacity(0.2),
                                          itemCount: 5,
                                          itemSize: 30,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.WRITE_REVIEW_SCREEN,
                                      arguments: widget.booking?.carParkId);
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppLabel(
                                            text: "How was your parking?",
                                            fontSize: 16,
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              itemBuilder: (context, index) {
                                                return const Icon(
                                                  Icons.star,
                                                  shadows: [
                                                    BoxShadow(
                                                        blurRadius: 5,
                                                        color: AppColors
                                                            .appColorBlack)
                                                  ],
                                                  color:
                                                      AppColors.appColorWhite,
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
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
                child: Column(children: [
                  Visibility(
                    visible: widget.booking?.status == 'Completed' ||
                        widget.booking?.status == 'Canceled',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: CustomFilledButton(
                          height: 40,
                          text: 'Book Again',
                          clickEvent: () {
                            Get.toNamed(Routes.BOOK_AGAIN_SET_DURATION_SCREEN,
                                arguments: widget.booking);
                            parkNowController.bookAgainParkingDetail.value =
                                widget.booking!;
                          }),
                    ),
                  ),
                  // Visibility(
                  //   visible: booking?.status == 'Completed',
                  //   child: Padding(
                  //     padding:
                  //         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  //     child: CustomFilledButton(text: "Book Again", clickEvent: () {}),
                  //   ),
                  // ),
                  Visibility(
                    visible: widget.booking?.status == 'Completed',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BorderedButton(
                          height: 40,
                          text: "View Receipt",
                          clickEvent: () {
                            print(widget.booking?.invoiceURL);
                            Get.toNamed(Routes.PARK_NOW_RECIPT_SCREEN,
                                arguments: widget.booking);
                          }),
                    ),
                  ),
                  Visibility(
                    visible: widget.booking?.status == 'Upcoming',
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: SizedBox(
                            height: 35,
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    side: const BorderSide(
                                        color: AppColors.appColorBlack)),
                                child: const Text('Direction'),
                                onPressed: () {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Scaffold(
                                        body: SafeArea(
                                          child: WebView(
                                              javascriptMode:
                                                  JavascriptMode.unrestricted,
                                              initialUrl:
                                                  'https://www.google.com/maps/dir/?api=1&destination=${widget.booking?.carPark![0].latitude}%2C${widget.booking?.carPark![0].longitude}'),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible:
                                  widget.booking?.carPark?.first.currency ==
                                          'LKR'
                                      ? false
                                      : true,
                              child: Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 5, 0),
                                  child: CustomFilledButton(
                                      height: 40,
                                      text: 'Amend Booking',
                                      clickEvent: () {
                                        parkNowController
                                            .showHowLongParking.value = '';
                                        parkNowController
                                            .showTotalDuration.value = '';

                                        showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Obx(
                                                () => SizedBox(
                                                  height: parkNowController
                                                              .showTotalDuration
                                                              .value !=
                                                          ""
                                                      ? MediaQuery.of(context)
                                                          .size
                                                          .height
                                                      : 250,
                                                  child: Card(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Obx(
                                                          () => Visibility(
                                                            visible:
                                                                !parkNowController
                                                                    .isIDontKnowParkingTime
                                                                    .value,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (parkNowController
                                                                        .isIDontKnowParkingTime
                                                                        .value ==
                                                                    false) {
                                                                  if (parkNowController
                                                                          .isIDontKnowParkingTime
                                                                          .value ==
                                                                      false) {
                                                                    AppBottomSheet().amendBookingselectHoursBottomSheet(
                                                                        context:
                                                                            context,
                                                                        controller:
                                                                            parkNowController);
                                                                  }
                                                                }
                                                              },
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              8.0),
                                                                      child:
                                                                          AppLabel(
                                                                        text:
                                                                            "How long are you parking for?",
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Obx(() {
                                                          return Visibility(
                                                            visible:
                                                                parkNowController
                                                                        .showHowLongParking
                                                                        .value
                                                                        .isEmpty
                                                                    ? true
                                                                    : true,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          InkWell(
                                                                    onTap: () {
                                                                      print(parkNowController
                                                                          .parkingFromTime);
                                                                      AppBottomSheet().amendBookingselectHoursFromBottomSheet(
                                                                          bookingId: widget
                                                                              .booking!
                                                                              .sId,
                                                                          context:
                                                                              context,
                                                                          controller:
                                                                              parkNowController);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              6),
                                                                          border:
                                                                              Border.all(color: AppColors.appColorWhiteGray02)),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          AppLabel(
                                                                            text:
                                                                                "Park From",
                                                                            fontSize:
                                                                                14,
                                                                            textColor:
                                                                                AppColors.appColorGray,
                                                                          ),
                                                                          Obx(() {
                                                                            return AppLabel(
                                                                              text: parkNowController.showParkingFrom.value.split('at')[1],
                                                                              fontWeight: FontWeight.bold,
                                                                            );
                                                                          }),
                                                                          Obx(() {
                                                                            return AppLabel(
                                                                              text: parkNowController.showParkingFrom.value.split('at')[0],
                                                                              textColor: AppColors.appColorGray,
                                                                            );
                                                                          }),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                                  const SizedBox(
                                                                    width: 16,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          InkWell(
                                                                    onTap: () {
                                                                      AppBottomSheet().amendBookingselectHoursBottomSheet(
                                                                          bookingId: widget
                                                                              .booking!
                                                                              .sId,
                                                                          context:
                                                                              context,
                                                                          controller:
                                                                              parkNowController);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              6),
                                                                          border:
                                                                              Border.all(color: AppColors.appColorWhiteGray02)),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          AppLabel(
                                                                            text:
                                                                                "Park Until",
                                                                            fontSize:
                                                                                14,
                                                                            textColor:
                                                                                AppColors.appColorGray,
                                                                          ),
                                                                          Obx(() {
                                                                            return AppLabel(
                                                                              text: parkNowController.showParkingUntil.value.split('at')[1],
                                                                              fontWeight: FontWeight.bold,
                                                                            );
                                                                          }),
                                                                          Obx(() {
                                                                            return AppLabel(
                                                                              text: parkNowController.showParkingUntil.value.split('at')[0],
                                                                              textColor: AppColors.appColorGray,
                                                                            );
                                                                          }),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ))
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                        Obx(
                                                          () => Visibility(
                                                            visible: parkNowController
                                                                        .showTotalDuration
                                                                        .value !=
                                                                    ""
                                                                ? true
                                                                : false,
                                                            child: Container(
                                                              color: AppColors
                                                                  .appColorLightGray
                                                                  .withOpacity(
                                                                      0.2),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child: Column(
                                                                children: [
                                                                  Obx(() {
                                                                    return AppLabel(
                                                                        text: parkNowController.showTotalDuration.value.isEmpty
                                                                            ? " "
                                                                            : parkNowController.showTotalDuration.value);
                                                                  }),
                                                                  AppLabel(
                                                                    text:
                                                                        "Total duration",
                                                                    fontSize:
                                                                        14,
                                                                    textColor:
                                                                        AppColors
                                                                            .appColorLightGray,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Obx(
                                                          () => Visibility(
                                                            visible: parkNowController
                                                                        .showTotalDuration
                                                                        .value !=
                                                                    ""
                                                                ? true
                                                                : false,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      AppLabel(
                                                                        text:
                                                                            "Parking Fee Paid",
                                                                        textColor:
                                                                            AppColors.appColorLightGray,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      Obx(
                                                                        () =>
                                                                            AppLabel(
                                                                          text:
                                                                              '£${bookingController.amendBookingFee.value?.oldParkingPrice?.toStringAsFixed(2) ?? ''}',
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          AppLabel(
                                                                            text:
                                                                                "New Parking Fee",
                                                                            textColor:
                                                                                AppColors.appColorLightGray,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                infoBottomSheet(context, "Service fee", "Service fees is cost of running the platform and providing customer support on your booking.");
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.info,
                                                                                size: 18,
                                                                                color: AppColors.appColorLightGray,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                      Obx(
                                                                        () =>
                                                                            AppLabel(
                                                                          text:
                                                                              '£${bookingController.amendBookingFee.value?.newparkingPrice?.toStringAsFixed(2) ?? ''}',
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      AppLabel(
                                                                        text:
                                                                            "Balance Due",
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                      Obx(
                                                                        () =>
                                                                            AppLabel(
                                                                          text:
                                                                              '£${bookingController.amendBookingFee.value?.extraParkingFee?.toStringAsFixed(2) ?? ''}',
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 16,
                                                                ),
                                                                const Divider(
                                                                  thickness: 1,
                                                                  endIndent: 10,
                                                                  indent: 10,
                                                                  color: AppColors
                                                                      .appColorLightGray,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 5),
                                                          child: Obx(
                                                            () =>
                                                                CustomFilledButton(
                                                                    btnController: parkNowController.showTotalDuration.value !=
                                                                                "" &&
                                                                            !bookingController
                                                                                .amendBookingLoading.value
                                                                        ? true
                                                                        : false,
                                                                    text:
                                                                        'Amend Booking',
                                                                    clickEvent:
                                                                        () {
                                                                      if (bookingController
                                                                              .amendBookingFee
                                                                              .value!
                                                                              .redirectToPaymentGateway ==
                                                                          true) {
                                                                        bookingController.draftAmendBooking(
                                                                            bookingId: widget
                                                                                .booking!.sId!,
                                                                            context:
                                                                                context,
                                                                            bookingEnd:
                                                                                parkNowController.parkingUntilTime!.millisecondsSinceEpoch,
                                                                            bookingStart: parkNowController.parkingFromTime!.millisecondsSinceEpoch);
                                                                      } else if (bookingController
                                                                              .amendBookingFee
                                                                              .value!
                                                                              .redirectToPaymentGateway ==
                                                                          false) {
                                                                        bookingController.amendBookingWihoutPaymentGateway(
                                                                            bookingId: widget
                                                                                .booking!.sId!,
                                                                            context:
                                                                                context,
                                                                            bookingEnd:
                                                                                parkNowController.parkingUntilTime!.millisecondsSinceEpoch,
                                                                            bookingStart: parkNowController.parkingFromTime!.millisecondsSinceEpoch);
                                                                      }
                                                                    }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 16, 0),
                                child: CustomFilledButton(
                                    btnController: AppTimeZone.getTimeZone(
                                                    timeZoneName: widget
                                                        .booking!.timeZone!,
                                                    milliseconds: widget
                                                        .booking!.bookingStart!)
                                                .difference(AppTimeZone.getTimeZone(
                                                    timeZoneName: widget
                                                        .booking!.timeZone!,
                                                    milliseconds: DateTime.now()
                                                        .millisecondsSinceEpoch))
                                                .inHours >=
                                            24
                                        ? true
                                        : false,
                                    height: 40,
                                    text: 'Cancel Booking',
                                    clickEvent: () {
                                      AppBottomSheet()
                                          .bookingCancelingReasonsBottomSheet(
                                              context: context,
                                              bookingId: widget.booking!.sId!);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void infoBottomSheet(
      BuildContext context, bottomSheetTitle, bottomSheetBodyText) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.clear))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(text: bottomSheetTitle),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppLabel(
              text: bottomSheetBodyText,
              textAlign: TextAlign.justify,
              fontSize: 12,
              textColor: AppColors.appColorGray,
            ),
          ),
          const SizedBox(
            height: 60,
          )
        ],
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
      return '';
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
