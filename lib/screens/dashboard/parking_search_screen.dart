import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/account_service.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import '../../constants/constant.dart';
import '../../constants/routes.dart';
import '../../controllers/park_later_controller.dart';
import '../../model/recent_search.dart';
import '../../utils/app_custom_toast.dart';
import '../../utils/app_overlay.dart';

class ParkingSearchScreen extends StatefulWidget {
  final bool? isDashboard;
  const ParkingSearchScreen({Key? key, this.isDashboard}) : super(key: key);

  @override
  State<ParkingSearchScreen> createState() => _ParkingSearchScreenState();
}

class _ParkingSearchScreenState extends State<ParkingSearchScreen> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  var isLocationLoading = false.obs;

  ParkingLaterController parkingLaterController =
      Get.put(ParkingLaterController());

  DetailsResult? detailsResult;
  BitmapDescriptor? icon;
  var isEmpty = true.obs;

  @override
  void initState() {
    googlePlace = GooglePlace(Constant.googleMapAPIkey);
    super.initState();
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future getLocationDetails(String placeId) async {
    var result = await googlePlace.details.get(placeId);

    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.appColorWhite,
        centerTitle: true,
        leading: widget.isDashboard == true
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.appColorBlack,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
        title: const Text(
          "Search",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    //labelText: "Search",
                    fillColor: AppColors.appColorWhiteGray,
                    filled: true,
                    hintText: "Where would you like to park?",
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: const Icon(Icons.search),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: AppColors.appColorLightGray,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: AppColors.appColorLightGray,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      isEmpty.value = false;
                      autoCompleteSearch(value);
                    } else {
                      isEmpty.value = true;
                      if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: isEmpty.value,
                child: const SizedBox(
                  height: 20,
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: isEmpty.value,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.ENTER_LOCATION_SCREEN);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(children: [
                      const Icon(FontAwesomeIcons.hashtag,
                          color: AppColors.appColorBlack),
                      const SizedBox(
                        width: 10,
                      ),
                      AppLabel(
                        text: 'Enter Location ID',
                        textColor: AppColors.appColorBlack,
                      )
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Visibility(
              visible: SharedPref.isGuestAccount() ? false : true,
              child: Obx(
                () => Visibility(
                  visible: isEmpty.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        AppLabel(
                            text: 'Recent Searches',
                            fontSize: 14,
                            textColor: AppColors.appColorGray),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: SharedPref.isGuestAccount() ? false : true,
              child: Obx(
                () => Visibility(
                  visible: isEmpty.value,
                  child: FutureBuilder(
                    future: parkingLaterController.getRecentSearch(),
                    builder:
                        (context, AsyncSnapshot<List<RecentSearch>> snapshot) {
                      if (snapshot.hasData) {
                        List<RecentSearch> recentSearch = snapshot.data!;
                        return ListView.builder(
                          itemCount: recentSearch.length,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  bookingController.baseUrl.value =
                                      recentSearch[index].baseURL!;
                                  print('base url-->');
                                  print(bookingController.baseUrl);

                                  AppOverlay.startOverlay(context);

                                  parkingLaterController.getAllCarPark(
                                      startTime:
                                          DateTime.now().millisecondsSinceEpoch,
                                      endTime: DateTime.now()
                                          .add(const Duration(hours: 1))
                                          .millisecondsSinceEpoch,
                                      lat: recentSearch[index]
                                          .carPark!
                                          .first
                                          .latitude!,
                                      lng: recentSearch[index]
                                          .carPark!
                                          .first
                                          .longitude!,
                                      context: context,
                                      address: recentSearch[index]
                                          .carPark!
                                          .first
                                          .carParkName!);
                                },
                                child: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.search,
                                        color: AppColors.appColorLightGray),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AppLabel(
                                            text: recentSearch[index]
                                                    .carPark
                                                    ?.first
                                                    .carParkName ??
                                                '',
                                            fontSize: 14),
                                        Row(
                                          children: [
                                            AppLabel(
                                                text: recentSearch[index]
                                                        .carPark
                                                        ?.first
                                                        .city ??
                                                    '',
                                                fontSize: 12,
                                                textColor: AppColors
                                                    .appColorLightGray),
                                            AppLabel(
                                                text: ",",
                                                fontSize: 12,
                                                textColor: AppColors
                                                    .appColorLightGray),
                                            AppLabel(
                                                text: recentSearch[index]
                                                        .carPark
                                                        ?.first
                                                        .country ??
                                                    '',
                                                fontSize: 12,
                                                textColor:
                                                    AppColors.appColorLightGray)
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.appColorLightGray),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: SharedPref.isGuestAccount() ? false : true,
              child: Obx(
                () => Visibility(
                  visible: !isEmpty.value,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        itemCount: predictions.length,
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              AppOverlay.startOverlay(context);

                              print(predictions[index].description);
                              await getLocationDetails(
                                  predictions[index].placeId!);

                              if (detailsResult?.geometry?.location?.lat !=
                                      null &&
                                  detailsResult?.geometry?.location?.lng !=
                                      null) {
                                if (detailsResult!.formattedAddress!
                                    .endsWith('UK')) {
                                  bookingController.baseUrl.value =
                                      Constant.ukUrl;
                                  // ignore: use_build_context_synchronously
                                  parkingLaterController.getAllCarPark(
                                      startTime:
                                          DateTime.now().millisecondsSinceEpoch,
                                      endTime: DateTime.now()
                                          .add(const Duration(hours: 1))
                                          .millisecondsSinceEpoch,
                                      lat: detailsResult!
                                          .geometry!.location!.lat!,
                                      lng: detailsResult!
                                          .geometry!.location!.lng!,
                                      context: context,
                                      address:
                                          predictions[index].description ?? "");
                                } else if (detailsResult!.formattedAddress!
                                    .endsWith('Sri Lanka')) {
                                  bookingController.baseUrl.value =
                                      Constant.slUrl;
                                  // ignore: use_build_context_synchronously
                                  parkingLaterController.getAllCarPark(
                                      startTime:
                                          DateTime.now().millisecondsSinceEpoch,
                                      endTime: DateTime.now()
                                          .add(const Duration(hours: 1))
                                          .millisecondsSinceEpoch,
                                      lat: detailsResult!
                                          .geometry!.location!.lat!,
                                      lng: detailsResult!
                                          .geometry!.location!.lng!,
                                      context: context,
                                      address:
                                          predictions[index].description ?? "");
                                } else {
                                  AppOverlay.hideOverlay();
                                  AppCustomToast.warningToast(
                                      "There are no Parkfinda spaces in this area yet.");
                                }
                              } else {
                                AppOverlay.hideOverlay();
                                AppCustomToast.warningToast(
                                    "Can't Connect to Network");
                              }
                            },
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.appColorBlack,
                                  size: 36,
                                ),
                              ),
                              title: Text(predictions[index].description!),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: SharedPref.isGuestAccount(),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                    itemCount: predictions.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          AppOverlay.startOverlay(context);
                          print(predictions[index].description);
                          await getLocationDetails(predictions[index].placeId!);

                          if (detailsResult?.geometry?.location?.lat != null &&
                              detailsResult?.geometry?.location?.lng != null) {
                            // ignore: use_build_context_synchronously
                            if (detailsResult!.formattedAddress!
                                .endsWith('UK')) {
                              bookingController.baseUrl.value = Constant.ukUrl;
                              // ignore: use_build_context_synchronously
                              parkingLaterController.getAllCarPark(
                                  startTime:
                                      DateTime.now().millisecondsSinceEpoch,
                                  endTime: DateTime.now()
                                      .add(const Duration(hours: 1))
                                      .millisecondsSinceEpoch,
                                  lat: detailsResult!.geometry!.location!.lat!,
                                  lng: detailsResult!.geometry!.location!.lng!,
                                  context: context,
                                  address:
                                      predictions[index].description ?? "");
                            } else if (detailsResult!.formattedAddress!
                                .endsWith('Sri Lanka')) {
                              bookingController.baseUrl.value = Constant.slUrl;
                              // ignore: use_build_context_synchronously
                              parkingLaterController.getAllCarPark(
                                  startTime:
                                      DateTime.now().millisecondsSinceEpoch,
                                  endTime: DateTime.now()
                                      .add(const Duration(hours: 1))
                                      .millisecondsSinceEpoch,
                                  lat: detailsResult!.geometry!.location!.lat!,
                                  lng: detailsResult!.geometry!.location!.lng!,
                                  context: context,
                                  address:
                                      predictions[index].description ?? "");
                            } else {
                              AppOverlay.hideOverlay();
                              AppCustomToast.warningToast(
                                  "There are no Parkfinda spaces in this area yet.");
                            }
                          } else {
                            AppOverlay.hideOverlay();
                            AppCustomToast.warningToast(
                                "Can't Connect to Network");
                          }
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.appColorBlack,
                              size: 36,
                            ),
                          ),
                          title: Text(predictions[index].description!),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
