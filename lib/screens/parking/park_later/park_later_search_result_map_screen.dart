import 'dart:async';
import 'dart:io';
import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as loc;
import 'package:location/location.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/constants/constant.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/park_later_controller.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/location_info_tab_controller.dart';
import 'package:parkfinda_mobile/model/park_later_locations.dart';
import 'package:parkfinda_mobile/screens/accounts/help_screen.dart';
import 'package:parkfinda_mobile/screens/parking/park_later/park_later_set_duration_screen.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/location_code_view.dart';
import '../../../constants/routes.dart';
import '../../../controllers/user_controller.dart';
import '../../../model/CustomerReviews.dart';
import '../../../services/local/shared_pref.dart';
import '../../../utils/app_custom_toast.dart';
import '../../../utils/google_map_style.dart';
import '../../../widgets/atoms/app_heading.dart';
import '../../../widgets/molecules/buttons/ghost_button.dart';
import 'package:label_marker/label_marker.dart';

import 'package:html/parser.dart';

class ParkLaterSearchResultMapScreen extends StatefulWidget {
  const ParkLaterSearchResultMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ParkLaterSearchResultMapScreen> createState() =>
      _ParkLaterSearchResultMapScreenState();
}

class _ParkLaterSearchResultMapScreenState
    extends State<ParkLaterSearchResultMapScreen> {
  var showTopContainer = false.obs;
  var isPinAnimate = false.obs;
  var bottomSheetInit = false;
  var showBottomSheetDashBar = false;
  var pickedLocationName = "Where are you parking?".obs;
  var showParkingFrom = "".obs;
  var showParkingUntil = "".obs;
  var isEVVehicle = false.obs;
  var isRVVehicle = true.obs;
  var hours = 0.obs;
  var minutes = 0.obs;
  var difference = 0.obs;

  GoogleMapController? mapController;
  LatLng? curentMapLocation;

  var lat = Get.arguments[0];
  var lng = Get.arguments[1];
  var address = Get.arguments[2];
  var initLatLang = LatLng(Get.arguments[0], Get.arguments[1]);
  loc.DetailsResult? detailsResult;

  RxSet<Marker>? allMarkers = <Marker>{}.obs;
  RxSet<Marker>? evMarkersType1 = <Marker>{}.obs;
  RxSet<Marker>? evMarkersType2 = <Marker>{}.obs;
  RxSet<Marker>? evMarkersType3 = <Marker>{}.obs;
  RxSet<Marker>? rvMarkers = <Marker>{}.obs;
  late Location _location;

  late final _locationPosition = const LatLng(0, 0).obs;

  ParkingLaterController parkingLaterController =
      Get.find<ParkingLaterController>();

  final LocationInfoTabController locationInfoTabController =
      Get.put(LocationInfoTabController());

  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();

  RxSet<Circle> circles = <Circle>{}.obs;

  @override
  void initState() {
    _location = Location();
    loadLocations();
    getCurrentLocation();
    getTime();
    print(address);
    super.initState();
    bottomSheetInit = true;
  }

  void getCordination(LatLng latLag) async {
    Dio dio = Dio();
    var responce = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLag.latitude},${latLag.longitude}&key=${Constant.googleMapAPIkey}');
    if (responce.statusCode == 200) {
      // pickedLocationName.value =
      //     responce.data['results'][0]['formatted_address'];
      pickedLocationName.value = 'Current location';
    }
  }

  getTime() {
    var defaultFromTime = DateTime.now().add(const Duration(minutes: 15));
    parkingLaterController.parkingFromTime = defaultFromTime;

    //DEFAULT UNTIL TIME
    var defaultUntilTime = DateTime.now().add(const Duration(minutes: 30));
    parkingLaterController.parkingUntilTime = defaultUntilTime;

    showParkingFrom.value =
        "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultFromTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultFromTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";

    showParkingUntil.value =
        "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultUntilTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultUntilTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
    difference = parkingLaterController.parkingUntilTime!
        .difference(parkingLaterController.parkingFromTime!)
        .inMinutes
        .obs;

    hours.value = difference.value ~/ 60;
    minutes.value = difference.value % 60;
  }

  String dropdownValue = 'Hourly';

  var items = ['Hourly', 'Monthly'];
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    pickedLocationName.value = address;
    //DEFAULT FROM TIME
    // var defaultFromTime = DateTime.now().add(const Duration(minutes: 15));
    // parkingLaterController.parkingFromTime = defaultFromTime;

    // //DEFAULT UNTIL TIME
    // var defaultUntilTime = DateTime.now().add(const Duration(minutes: 30));
    // parkingLaterController.parkingUntilTime = defaultUntilTime;

    // showParkingFrom.value =
    //     "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultFromTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultFromTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";

    // showParkingUntil.value =
    //     "${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(defaultFromTime) != 'Today' ? parkingLaterController.getMonth(defaultUntilTime.month) : ''} ${parkingLaterController.getFormattedDay(defaultUntilTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Obx(
              () => GoogleMap(
                myLocationEnabled: true,
                markers: allMarkers?.value ?? {},
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                padding: const EdgeInsets.only(bottom: 110.0, right: 10),
                onMapCreated: (controller) {
                  mapController = controller;
                  mapController?.setMapStyle(GoogleMapStyle.googleMapStyle);
                },
                onCameraMoveStarted: () {
                  showTopContainer.value = false;
                  isPinAnimate.value = false;
                },
                onCameraIdle: () async {
                  showTopContainer.value = true;
                  isPinAnimate.value = true;

                  LatLngBounds bounds = await mapController!.getVisibleRegion();
                  final lon = (bounds.northeast.longitude +
                          bounds.southwest.longitude) /
                      2;
                  final lat =
                      (bounds.northeast.latitude + bounds.southwest.latitude) /
                          2;

                  print(curentMapLocation);
                  // circles.add(Circle(
                  //   strokeWidth: 2,
                  //   circleId: const CircleId('id'),
                  //   center: LatLng(curentMapLocation!.latitude,
                  //       curentMapLocation!.longitude),
                  //   radius: 4000,
                  // ));
                },
                //circles: circles,
                initialCameraPosition:
                    CameraPosition(target: initLatLang, zoom: 14.6),
                onCameraMove: (position) {
                  curentMapLocation = position.target;
                },
                circles: circles,
              ),
            ),
            Positioned(
                bottom: 60,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: (() async {
                    getCurrentMapCamera(_locationPosition.value);
                    getCordination(_locationPosition.value);
                  }),
                  child: const Icon(Icons.my_location, color: Colors.black),
                )),
            Positioned(
              top: Platform.isAndroid ? 10.0 : 20,
              child: Obx(() {
                return TranslationAnimatedWidget.tween(
                  duration: const Duration(milliseconds: 300),
                  enabled: showTopContainer.value,
                  translationDisabled: const Offset(-200, 0),
                  translationEnabled: const Offset(0, 0),
                  child: OpacityAnimatedWidget.tween(
                    duration: const Duration(milliseconds: 300),
                    opacityEnabled: 1,
                    //define start value
                    opacityDisabled: 0,
                    enabled: showTopContainer.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .25),
                                  blurRadius: 16.0)
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: AppColors.appColorBlack,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          Get.back();
                                          showTopContainer.value = false;
                                        },
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.PARKING_SEARCH_SCREEN);
                                          },
                                          child: Obx(() {
                                            return Text(
                                              pickedLocationName.value,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.appColorBlack,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.appColorWhite,
                                            border: Border.all(
                                                color: AppColors.appColorBlack),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            dropdownColor:
                                                AppColors.appColorWhite,
                                            value: dropdownValue,
                                            elevation: 0,
                                            alignment: Alignment.bottomCenter,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: AppColors.appColorBlack,
                                              size: 18,
                                            ),
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: AppLabel(
                                                  text: items,
                                                  fontSize: 10,
                                                  textColor:
                                                      AppColors.appColorBlack,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (String? newValue) async {
                                              if (newValue == 'Monthly') {
                                                parkingLaterController
                                                        .parkingUntilTime =
                                                    DateTime.now().add(
                                                        const Duration(
                                                            days: 30));
                                                print(parkingLaterController
                                                    .parkingUntilTime);
                                                showParkingUntil.value =
                                                    "${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.getMonth(DateTime.now().add(const Duration(days: 30)).month) : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30)))} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
                                                print(showParkingUntil.value);

                                                allMarkers?.clear();
                                                await parkingLaterController
                                                    .getAllCarparksForMonthlyBooking(
                                                        context: context,
                                                        lat: lat,
                                                        lng: lng,
                                                        bookingEnd: DateTime
                                                                .now()
                                                            .add(const Duration(
                                                                days: 30))
                                                            .millisecondsSinceEpoch,
                                                        bookingStart: DateTime
                                                                .now()
                                                            .millisecondsSinceEpoch);

                                                parkingLaterController
                                                    .parkLaterLocationsInMonthly
                                                    .parkLaterLocation
                                                    ?.all
                                                    ?.forEach(
                                                  (element) {
                                                    LatLng latlng;
                                                    latlng = LatLng(
                                                      element.latitude!,
                                                      element.longitude!,
                                                    );

                                                    allMarkers?.addLabelMarker(
                                                        LabelMarker(
                                                      alpha: 0.8,
                                                      label: element
                                                                  .priceStartingFrom !=
                                                              'Full'
                                                          ? '${element.currency} ${element.priceStartingFrom}'
                                                          : '${element.priceStartingFrom}',
                                                      icon: BitmapDescriptor
                                                          .defaultMarker,
                                                      textStyle:
                                                          const TextStyle(
                                                        color: AppColors
                                                            .appColorWhite,
                                                        fontSize: 25,
                                                      ),
                                                      backgroundColor: AppColors
                                                          .appColorBlack,
                                                      markerId:
                                                          MarkerId(element.id!),
                                                      position: latlng,
                                                      onTap: () {
                                                        showSingleLocationDetailsBottomSheet(
                                                            parkLaterLocation:
                                                                element);
                                                      },
                                                    ));
                                                  },
                                                );
                                              } else {
                                                getTime();
                                                allMarkers?.clear();
                                                loadLocations();
                                              }
                                              setState(() {
                                                dropdownValue = newValue!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: AppColors.appColorLightGray,
                                height: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      width: 140,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.appColorBlack,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          if (dropdownValue == "Monthly") {
                                            setMonthlyCustomDurationParkLaterFrom();
                                          } else {
                                            setCustomDurationParkLaterFrom();
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AppLabel(
                                              text: showParkingFrom.value,
                                              textOverflow: TextOverflow.fade,
                                              fontSize: 10,
                                              textColor:
                                                  AppColors.appColorWhite,
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.expand_more,
                                              size: 18,
                                              color: AppColors.appColorWhite,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.appColorBlack,
                                        size: 16,
                                      ),
                                      onPressed: () {},
                                    ),
                                    Obx(() {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        width: 140,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.appColorBlack,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (dropdownValue != "Monthly") {
                                              setCustomDurationParkLaterUntil();
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              AppLabel(
                                                text: showParkingUntil.value,
                                                textOverflow: TextOverflow.fade,
                                                fontSize: 10,
                                                textColor:
                                                    AppColors.appColorWhite,
                                              ),
                                              const Spacer(),
                                              const Icon(
                                                Icons.expand_more,
                                                size: 18,
                                                color: AppColors.appColorWhite,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     MultiSelectContainer(
                        //         maxSelectableCount: 1,
                        //         singleSelectedItem: true,
                        //         items: [
                        //           MultiSelectCard(
                        //             value: 'ev',
                        //             label: 'EV',
                        //             prefix: MultiSelectPrefix(
                        //               enabledPrefix: const Padding(
                        //                 padding: EdgeInsets.only(right: 5),
                        //                 child: Icon(
                        //                   Icons.power,
                        //                   color: Colors.black,
                        //                   size: 14,
                        //                 ),
                        //               ),
                        //               selectedPrefix: const Padding(
                        //                 padding: EdgeInsets.only(right: 5),
                        //                 child: Icon(
                        //                   Icons.power,
                        //                   color: Colors.white,
                        //                   size: 14,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           MultiSelectCard(
                        //             value: 'rv',
                        //             label: 'RV',
                        //             prefix: MultiSelectPrefix(
                        //               enabledPrefix: const Padding(
                        //                 padding: EdgeInsets.only(right: 5),
                        //                 child: Icon(
                        //                   Icons.fire_truck,
                        //                   color: Colors.black,
                        //                   size: 14,
                        //                 ),
                        //               ),
                        //               selectedPrefix: const Padding(
                        //                 padding: EdgeInsets.only(right: 5),
                        //                 child: Icon(
                        //                   Icons.fire_truck,
                        //                   color: Colors.white,
                        //                   size: 14,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //         onChange: (allSelectedItems, selectedItem) {
                        //           if (selectedItem == 'rv') {
                        //             setState(() {
                        //               allMarkers = rvMarkers;
                        //             });
                        //           } else {
                        //             showEVPinTypeBottomSheet(context);
                        //           }
                        //         })
                        //   ],
                        // )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void setCustomDurationParkLaterFrom() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park From",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Next",
                  clickEvent: () {
                    //TODO
                    // ignore: deprecated_member_use

                    Get.back();
                    setCustomDurationParkLaterUntil();
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now(),
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime: parkingLaterController.parkingFromTime,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          parkingLaterController.parkingFromTime =
                              pickedDateTime;
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime.add(const Duration(minutes: 15));
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? pickedDateTime.add(const Duration(minutes: 15)).day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.add(const Duration(minutes: 15)).month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15)))} at ${pickedDateTime.add(const Duration(minutes: 15)).hour < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).hour}" : pickedDateTime.add(const Duration(minutes: 15)).hour} : ${pickedDateTime.add(const Duration(minutes: 15)).minute < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).minute}" : pickedDateTime.add(const Duration(minutes: 15)).minute}";
                          showParkingFrom.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setMonthlyCustomDurationParkLaterFrom() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Select Start Date",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Done",
                  clickEvent: () {
                    //TODO
                    // ignore: deprecated_member_use
                    // parkingLaterController.parkingUntilTime =
                    //     DateTime.now().add(const Duration(days: 30));
                    // print(parkingLaterController.parkingUntilTime);
                    // showParkingUntil.value =
                    //     "${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.getMonth(DateTime.now().add(const Duration(days: 30)).month) : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30)))} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
                    // print(showParkingUntil.value);
                    Get.back();
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: parkingLaterController.parkingFromTime,
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime: parkingLaterController.parkingFromTime,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime.add(const Duration(days: 30));
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30))) != 'Today' ? parkingLaterController.getMonth(DateTime.now().add(const Duration(days: 30)).month) : ''} ${parkingLaterController.getFormattedDay(DateTime.now().add(const Duration(days: 30)))} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
                          showParkingFrom.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? pickedDateTime.day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime)} at ${pickedDateTime.hour < 10 ? "0${pickedDateTime.hour}" : pickedDateTime.hour} : ${pickedDateTime.minute < 10 ? "0${pickedDateTime.minute}" : pickedDateTime.minute}";
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setCustomDurationParkLaterFromWithId(String? id) {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park From",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Next",
                  clickEvent: () {
                    Get.back();
                    setCustomDurationParkLaterUntil(id: id);

                    // ignore: deprecated_member_use
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now(),
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime: parkingLaterController.parkingFromTime,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          parkingLaterController.parkingFromTime =
                              pickedDateTime;
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime.add(const Duration(minutes: 15));
                          showParkingFrom.value =
                              "${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!) != 'Today' ? parkingLaterController.parkingFromTime!.day : ''} ${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!) != 'Today' ? parkingLaterController.getMonth(parkingLaterController.parkingFromTime!.month) : ''} ${parkingLaterController.getFormattedDay(parkingLaterController.parkingFromTime!)} at ${parkingLaterController.parkingFromTime!.hour < 10 ? "0${parkingLaterController.parkingFromTime!.hour}" : parkingLaterController.parkingFromTime!.hour} : ${parkingLaterController.parkingFromTime!.minute < 10 ? "0${parkingLaterController.parkingFromTime!.minute}" : parkingLaterController.parkingFromTime!.minute}";
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? pickedDateTime.add(const Duration(minutes: 15)).day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15))) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.add(const Duration(minutes: 15)).month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime.add(const Duration(minutes: 15)))} at ${pickedDateTime.add(const Duration(minutes: 15)).hour < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).hour}" : pickedDateTime.add(const Duration(minutes: 15)).hour} : ${pickedDateTime.add(const Duration(minutes: 15)).minute < 10 ? "0${pickedDateTime.add(const Duration(minutes: 15)).minute}" : pickedDateTime.add(const Duration(minutes: 15)).minute}";
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setCustomDurationParkLaterUntil({String? id}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GhostButton(
                  text: "Cancel",
                  clickEvent: () {
                    Get.back();
                  },
                  color: AppColors.appColorGray,
                ),
                AppLabel(
                  text: "Park Until",
                  fontWeight: FontWeight.w500,
                ),
                GhostButton(
                  text: "Done",
                  clickEvent: () async {
                    difference = parkingLaterController.parkingUntilTime!
                        .difference(parkingLaterController.parkingFromTime!)
                        .inMinutes
                        .obs;

                    hours.value = difference.value ~/ 60;
                    minutes.value = difference.value % 60;
                    Get.back();
                    if (id == null) {
                      await parkingLaterController.getAllCarPark(
                          context: context,
                          lat: lat,
                          lng: lng,
                          startTime: parkingLaterController
                              .parkingFromTime!.millisecondsSinceEpoch,
                          endTime: parkingLaterController
                              .parkingUntilTime!.millisecondsSinceEpoch,
                          address: address);
                      loadLocations();
                    } else {
                      parkingLaterController.getParkLaterSingleLocationsDetails(
                          parkingId: id);
                    }
                  },
                  color: AppColors.appColorLightBlue,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppColors.appColorWhite,
                height: 200,
                width: 300,
                child: SizedBox(
                  height: 75,
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                        color: Color(0xffB59CCF),
                        fontSize: 18,
                      )),
                    ),
                    child: CupertinoDatePicker(
                        minimumDate: parkingLaterController.parkingFromTime!,
                        maximumDate: parkingLaterController.parkingFromTime!
                            .add(const Duration(days: 30)),
                        initialDateTime:
                            parkingLaterController.parkingUntilTime,
                        use24hFormat: true,
                        onDateTimeChanged: ((pickedDateTime) {
                          parkingLaterController.parkingUntilTime =
                              pickedDateTime;
                          showParkingUntil.value =
                              "${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.parkingUntilTime!.day : ''} ${parkingLaterController.getFormattedDay(pickedDateTime) != 'Today' ? parkingLaterController.getMonth(pickedDateTime.month) : ''} ${parkingLaterController.getFormattedDay(pickedDateTime)} at ${parkingLaterController.parkingUntilTime!.hour < 10 ? "0${parkingLaterController.parkingUntilTime!.hour}" : parkingLaterController.parkingUntilTime!.hour} : ${parkingLaterController.parkingUntilTime!.minute < 10 ? "0${parkingLaterController.parkingUntilTime!.minute}" : parkingLaterController.parkingUntilTime!.minute}";
                          difference = parkingLaterController.parkingUntilTime!
                              .difference(
                                  parkingLaterController.parkingFromTime!)
                              .inMinutes
                              .obs;

                          hours.value = difference.value ~/ 60;
                          minutes.value = difference.value % 60;
                          print(hours);
                          print(minutes);
                        })),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSingleLocationDetailsBottomSheet(
      {required ParkLaterLocationData parkLaterLocation}) {
    if (dropdownValue == "Monthly") {
      parkingLaterController.getParkLaterMonthleyLocationsDetails(
          parkingId: parkLaterLocation.id!);
    } else {
      parkingLaterController.getParkLaterSingleLocationsDetails(
          parkingId: parkLaterLocation.id!);
    }

    SharedPref.setCurerentParkCurrency(parkLaterLocation.currency);
    difference = parkingLaterController.parkingUntilTime!
        .difference(parkingLaterController.parkingFromTime!)
        .inMinutes
        .obs;
    parkingLaterController.setRecentSearch(
        url: bookingController.baseUrl.value,
        context: context,
        carparkId: parkLaterLocation.id!);
    hours.value = difference.value ~/ 60;
    minutes.value = difference.value % 60;

    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        backgroundColor: AppColors.appColorWhite,
        builder: (context) {
          print("State changed------------------->");
          print(parkingLaterController.isCarParkLoading.value);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.appColorLightGray,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LocationCodeView(
                    postCode: parkLaterLocation.postCode ?? "",
                    parkName: parkLaterLocation.carParkName ?? "",
                    addressOne: parkLaterLocation.addressLineOne ?? "",
                    parkingId: "${parkLaterLocation.carParkPIN}" ?? "",
                    addressTow: parkLaterLocation.addressLineTwo ?? "",
                    city: "${parkLaterLocation.city}" ?? ""),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        // getTime();
                        setCustomDurationParkLaterFromWithId(
                            parkLaterLocation.id);
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: AppColors.appColorLightGray)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            AppLabel(
                              text: "Park From",
                              fontSize: 14,
                              textColor: AppColors.appColorLightGray,
                            ),
                            Obx(
                              () => AppLabel(
                                text: showParkingFrom.value.split('at')[1],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(
                              () => AppLabel(
                                text: showParkingFrom.value.split('at')[0],
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () => setCustomDurationParkLaterUntil(
                          id: parkLaterLocation.id),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: AppColors.appColorLightGray)),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            AppLabel(
                              text: "Park Until",
                              fontSize: 14,
                              textColor: AppColors.appColorLightGray,
                            ),
                            Obx(
                              () => AppLabel(
                                text: showParkingUntil.value.split('at')[1],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(
                              () => AppLabel(
                                text: showParkingUntil.value.split('at')[0],
                                fontSize: 14,
                                textColor: AppColors.appColorLightGray,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Obx(() {
                    if (parkingLaterController.isCarParkLoading.value) {
                      return Container();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4)),
                                  border: Border.all(
                                      color: AppColors.appColorLightGray)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppLabel(
                                    text: "Total Duration",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  Obx(
                                    () => AppLabel(
                                      text:
                                          "${hours.value > 0 ? "${hours.value} Hours" : ""} ${minutes.value > 0 ? "${minutes.value} Min" : ""}",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4)),
                                  border: Border.all(
                                      color: AppColors.appColorLightGray)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AppLabel(
                                    text: "Parking Fee",
                                    fontSize: 14,
                                    textColor: AppColors.appColorLightGray,
                                  ),
                                  AppLabel(
                                    text:
                                        "${parkingLaterController.parkingFee.data?.carpark?.currency ?? ''}${parkingLaterController.parkingFee.data?.price?.total?.toStringAsFixed(2) ?? "0.00"}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      );
                    }
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    if (parkingLaterController.isCarParkLoading.value) {
                      return Container();
                    } else {
                      return TabBar(
                          indicatorPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          indicatorColor: AppColors.appColorBlack,
                          controller: locationInfoTabController.tabController,
                          tabs: locationInfoTabController.locationInfoTabs);
                    }
                  }),
                  Obx(() {
                    if (parkingLaterController.isCarParkLoading.value) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else {
                      return Expanded(
                        child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            controller: locationInfoTabController.tabController,
                            children: [
                              singleLocationInfoTab(parkLaterLocation.id),
                              singleLocationReviewTab(),
                            ]),
                      );
                    }
                  }),
                ]),
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
                      Visibility(
                        visible: defaultTargetPlatform == TargetPlatform.android
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  side: const BorderSide(
                                      color: AppColors.appColorBlack),
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  disabledForegroundColor: Colors.grey,
                                  elevation: 25),
                              onPressed: () {
                                Get.toNamed(Routes.STREET_VIEW_SCREEN,
                                    arguments: [
                                      parkLaterLocation.latitude,
                                      parkLaterLocation.longitude
                                    ]);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  ImageIcon(
                                    AssetImage("assets/images/street_view.png"),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Street View",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appColorBlack),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16),
                        child: Obx(
                          () => CustomFilledButton(
                              btnController:
                                  // ignore: prefer_is_empty
                                  parkingLaterController
                                          .isPriceCalculation.value ||
                                      // ignore: prefer_is_empty
                                      userController
                                              .vehicles?.value?.data?.length ==
                                          null,
                              text: "Next",
                              clickEvent: () {
                                parkingLaterController.parkLaterLocationData =
                                    parkLaterLocation;
                                Get.back();
                                Get.to(
                                    arguments: dropdownValue,
                                    () => ParkLaterSetDurationScreen());
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget singleLocationInfoTab(String? id) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: parkingLaterController
                        .parkLaterSingleCarParkDetails.isCongestion ==
                    null
                ? false
                : parkingLaterController
                    .parkLaterSingleCarParkDetails.isCongestion!,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/images/infoIcon.png')),
                  const SizedBox(
                    width: 10,
                  ),
                  AppLabel(
                    text: 'Inside Congestion Charge Zone.',
                    fontSize: 12,
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                    child: AppLabel(
                        fontSize: 12,
                        textColor: AppColors.appColorLightGray,
                        text: _parseHtmlString(parkingLaterController
                                .parkLaterSingleCarParkDetails
                                .carParkInformation ??
                            "")))
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppLabel(
              text: "Features",
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isCCTV ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isCCTV!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/cctv.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "CCTV",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isSecurity ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isSecurity!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/security.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Security",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isShelter ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isShelter!,
                      replacement: const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/shelter.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Shelter",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails
                                  .isDisableAcsess ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isDisableAcsess!,
                      replacement: const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/disableAccess.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Disable \naccsess",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isOverNight ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isOverNight!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/overNight.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Overnight",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isWide ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isWide!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/wide.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Wide",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isHigh ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isHigh!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/high.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "High",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isStaff ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isStaff!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/staff.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Staff",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: parkingLaterController
                                  .parkLaterSingleCarParkDetails.isLift ==
                              null
                          ? false
                          : parkingLaterController
                              .parkLaterSingleCarParkDetails.isLift!,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/lift.png',
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          AppLabel(
                            text: "Lift",
                            fontSize: 10,
                            textColor: AppColors.appColorLightGray,
                          )
                        ],
                      ),
                    ),
                  ])),

          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(
              text: 'Reviews',
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: FutureBuilder(
              future: BookingController().getReview(carParkId: id!),
              builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                if (snapshot.hasData) {
                  List<Review> data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                AppLabel(
                                  text:
                                      "${data[index].customer?.first.firstName ?? ''} ${data[index].customer?.first.lastName ?? ''}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                AppLabel(
                                  text: "${data[index].createDate}",
                                  fontSize: 10,
                                  textColor: AppColors.appColorLightGray,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: RatingBar.builder(
                              initialRating: data[index].rating!.toDouble(),
                              direction: Axis.horizontal,
                              ignoreGestures: true,
                              allowHalfRating: false,
                              unratedColor:
                                  AppColors.appColorLightGray.withOpacity(0.2),
                              itemCount: 5,
                              itemSize: 18,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: AppLabel(
                                fontSize: 10,
                                textColor: AppColors.appColorLightGray,
                                text: data[index].review ?? ''),
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('No reviews'),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          // parkingLaterController.customerReviews == null
          //     ? const Center(child: Text('No reviews'))
          //     : SingleChildScrollView(
          //         child: ListView.builder(
          //             physics: BouncingScrollPhysics(),
          //             shrinkWrap: true,
          //             itemCount: parkingLaterController
          //                 .customerReviews?.review?.length,
          //             itemBuilder: (ctx, index) {
          //               return Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   const SizedBox(
          //                     height: 20,
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 16.0),
          //                     child: Row(
          //                       children: [
          //                         AppLabel(
          //                           text:
          //                               "${parkingLaterController.customerReviews!.review![index].customer![0].firstName!} ${parkingLaterController.customerReviews!.review![index].customer![0].lastName}",
          //                           fontSize: 12,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                         const SizedBox(
          //                           width: 30,
          //                         ),
          //                         AppLabel(
          //                           text:
          //                               "${parkingLaterController.customerReviews!.review![index].createDate}",
          //                           fontSize: 10,
          //                           textColor: AppColors.appColorLightGray,
          //                         )
          //                       ],
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 8,
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(left: 14.0),
          //                     child: RatingBar.builder(
          //                       initialRating: parkingLaterController
          //                           .customerReviews!.review![index].rating!
          //                           .toDouble(),
          //                       direction: Axis.horizontal,
          //                       ignoreGestures: true,
          //                       allowHalfRating: false,
          //                       unratedColor: AppColors.appColorLightGray
          //                           .withOpacity(0.2),
          //                       itemCount: 5,
          //                       itemSize: 18,
          //                       itemPadding:
          //                           const EdgeInsets.symmetric(horizontal: 1.0),
          //                       itemBuilder: (context, _) => const Icon(
          //                         Icons.star,
          //                         color: Colors.amber,
          //                       ),
          //                       onRatingUpdate: (rating) {
          //                         print(rating);
          //                       },
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 8,
          //                   ),
          //                   Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 16.0),
          //                     child: AppLabel(
          //                         fontSize: 10,
          //                         textColor: AppColors.appColorLightGray,
          //                         text: parkingLaterController.customerReviews!
          //                                 .review![index].review ??
          //                             ''),
          //                   )
          //                 ],
          //               );
          //             }),
          //       ),
          const SizedBox(
            height: 6,
          ),
          parkingLaterController.parkLaterSingleCarParkDetails.photo == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      height: 100.0,
                      child: ListView.builder(
                        itemCount: parkingLaterController
                            .parkLaterSingleCarParkDetails.photo?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 120.0,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                      parkingLaterController
                                          .parkLaterSingleCarParkDetails
                                          .photo![index],
                                      fit: BoxFit.cover)),
                            ),
                          );
                        },
                      )),
                ),
        ],
      ),
    );
  }

  Widget singleLocationReviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.appColorLightGray,
                  minRadius: 25,
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/images/park.png')),
                ),
                const SizedBox(
                  width: 15,
                ),
                AppLabel(
                    fontSize: 12,
                    textAlign: TextAlign.justify,
                    text:
                        'Once booking and payment is done,you \nwill receive instant confirmation and\n parking instructions.')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CircleAvatar(
                  minRadius: 25,
                  backgroundColor: AppColors.appColorLightGray,
                  child: Image.asset('assets/images/notification.png'),
                ),
                const SizedBox(
                  width: 15,
                ),
                AppLabel(
                    fontSize: 12,
                    textAlign: TextAlign.justify,
                    text:
                        'We will notify the space owner or car park \ninstantly regarding your booking.')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.appColorLightGray,
                  minRadius: 25,
                  child: Image.asset('assets/images/freepik.png'),
                ),
                const SizedBox(
                  width: 15,
                ),
                AppLabel(
                    fontSize: 12,
                    textAlign: TextAlign.justify,
                    text: 'Just drive in... enjoy hassle free parking.')
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLabel(text: 'Need more  ', fontSize: 12),
                InkWell(
                  onTap: () {
                    Get.to(const HelpScreen());
                  },
                  child: AppLabel(
                    text: 'Help?',
                    fontSize: 15,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool serviseEnabled;
    PermissionStatus permissionGranted;

    try {
      serviseEnabled = await _location.serviceEnabled();
      if (!serviseEnabled) {
        serviseEnabled = await _location.requestService();
        if (!serviseEnabled) {
          return;
        }
      }
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _location.onLocationChanged.listen((LocationData currentLocation) {
        _locationPosition.value =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    } on MissingPluginException catch (e) {
      print(e);
    }
  }

  Future<void> getCurrentMapCamera(LatLng latLng) async {
    try {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 17),
      ));
      mapController!.dispose();
    } on MissingPluginException catch (e) {
      print(e);
    }
  }

  loadLocations() {
    //TODO FILTER THE EV, RV LOCATION FROM SAME API
    if (parkingLaterController
            .parkLaterLocations.parkLaterLocation?.all?.isEmpty ??
        true) {
      Future.delayed(const Duration(seconds: 3), () {
        AppCustomToast.warningToast('Move the map and search again.');
      });
    } else {
      parkingLaterController.parkLaterLocations.parkLaterLocation?.all
          ?.forEach((element) {
        LatLng latlng;
        latlng = LatLng(
          element.latitude!,
          element.longitude!,
        );

        allMarkers?.addLabelMarker(LabelMarker(
          alpha: 0.8,
          label: element.priceStartingFrom != 'Full'
              ? '${element.currency} ${element.priceStartingFrom}'
              : '${element.priceStartingFrom}',
          icon: BitmapDescriptor.defaultMarker,
          textStyle: const TextStyle(
            color: AppColors.appColorWhite,
            fontSize: 25,
          ),
          backgroundColor: AppColors.appColorBlack,
          markerId: MarkerId(element.id!),
          position: latlng,
          onTap: () {
            showSingleLocationDetailsBottomSheet(parkLaterLocation: element);
          },
        ));
      });

      parkingLaterController.parkLaterLocations.parkLaterLocation?.rV
          ?.forEach((element) {
        LatLng latlng;
        latlng = LatLng(
          element.latitude!,
          element.longitude!,
        );

        rvMarkers?.addLabelMarker(LabelMarker(
          alpha: 0.8,
          label: '${element.currency}${element.priceStartingFrom}',
          icon: BitmapDescriptor.defaultMarker,
          textStyle: const TextStyle(
            color: AppColors.appColorWhite,
            fontSize: 25,
          ),
          backgroundColor: AppColors.appColorBlack,
          markerId: MarkerId(element.id!),
          position: latlng,
          onTap: () {
            showSingleLocationDetailsBottomSheet(parkLaterLocation: element);
          },
        ));
      });

      parkingLaterController.parkLaterLocations.parkLaterLocation?.eVtype1
          ?.forEach((element) {
        LatLng latlng;
        latlng = LatLng(
          element.latitude!,
          element.longitude!,
        );

        evMarkersType1?.addLabelMarker(LabelMarker(
          alpha: 0.8,
          label: '${element.currency}${element.priceStartingFrom}',
          icon: BitmapDescriptor.defaultMarker,
          textStyle: const TextStyle(
            color: AppColors.appColorWhite,
            fontSize: 25,
          ),
          backgroundColor: AppColors.appColorBlack,
          markerId: MarkerId(element.id!),
          position: latlng,
          onTap: () {
            showSingleLocationDetailsBottomSheet(parkLaterLocation: element);
          },
        ));
      });

      parkingLaterController.parkLaterLocations.parkLaterLocation?.eVtype2
          ?.forEach((element) {
        LatLng latlng;
        latlng = LatLng(
          element.latitude!,
          element.longitude!,
        );

        evMarkersType2?.addLabelMarker(LabelMarker(
          alpha: 0.8,
          label: '${element.currency}${element.priceStartingFrom}',
          icon: BitmapDescriptor.defaultMarker,
          textStyle: const TextStyle(
            color: AppColors.appColorWhite,
            fontSize: 25,
          ),
          backgroundColor: AppColors.appColorBlack,
          markerId: MarkerId(element.id!),
          position: latlng,
          onTap: () {
            showSingleLocationDetailsBottomSheet(parkLaterLocation: element);
          },
        ));
      });

      parkingLaterController.parkLaterLocations.parkLaterLocation?.eVtype3
          ?.forEach((element) {
        LatLng latlng;
        latlng = LatLng(
          element.latitude!,
          element.longitude!,
        );

        evMarkersType3?.addLabelMarker(LabelMarker(
          alpha: 0.8,
          label: '${element.currency}${element.priceStartingFrom}',
          icon: BitmapDescriptor.defaultMarker,
          textStyle: const TextStyle(
            color: AppColors.appColorWhite,
            fontSize: 25,
          ),
          backgroundColor: AppColors.appColorBlack,
          markerId: MarkerId(element.id!),
          position: latlng,
          onTap: () {
            showSingleLocationDetailsBottomSheet(parkLaterLocation: element);
          },
        ));
      });
    }
  }

  _customMarker(String? price) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
              color: AppColors.appColorWhite,
              border: Border.all(color: AppColors.appColorBlack, width: 0.2),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            "\$${price ?? "0.00"}",
            style: const TextStyle(fontSize: 6),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        const FaIcon(
          FontAwesomeIcons.locationDot,
          color: AppColors.appColorBlack,
          size: 16,
        )
      ],
    );
  }

  void showEVPinTypeBottomSheet(BuildContext context) {
    var isSelectedType = 1.obs;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 1;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 1
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-1.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "Type 1",
                      fontSize: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 2;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 2
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-3.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "Type 2",
                      fontSize: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        isSelectedType.value = 3;
                      },
                      child: Obx(() {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: isSelectedType.value == 3
                                  ? AppColors.appColorLightGray.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Image.asset(
                            "assets/images/charging-type-2.png",
                            width: 50,
                            height: 50,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppHeading(
                      text: "3 Pin",
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomFilledButton(
                  text: "Show me EV parking spaces",
                  clickEvent: () {
                    if (isSelectedType.value == 1) {
                      Get.back();
                      setState(() {
                        allMarkers = evMarkersType1;
                      });
                    } else if (isSelectedType.value == 2) {
                      Get.back();
                      setState(() {
                        allMarkers = evMarkersType2;
                      });
                    } else if (isSelectedType.value == 3) {
                      Get.back();
                      setState(() {
                        allMarkers = evMarkersType3;
                      });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
