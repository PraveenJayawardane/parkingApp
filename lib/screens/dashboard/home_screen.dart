import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/active_card_view.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/park_again_card_view.dart';
import '../../constants/routes.dart';
import '../../controllers/booking_controller.dart';
import '../../permissions/location_permission.dart';
import '../../services/local/shared_pref.dart';
import '../../widgets/molecules/containers/upcoming_card_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var bookingController = Get.put(BookingController());
  var userController = Get.find<UserController>();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.slowMiddle,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double getBottomHeight(double deviceHeight) {
    if (deviceHeight > 700) {
      if (bookingController.activeBooking.isNotEmpty ||
          SharedPref.hasParkAgain() ||
          bookingController.upcomingBooking.isNotEmpty) {
        return MediaQuery.of(context).size.height * 0.45;
      } else {
        return MediaQuery.of(context).size.height * 0.36;
      }
    } else {
      if (bookingController.activeBooking.isNotEmpty ||
          SharedPref.hasParkAgain()) {
        return MediaQuery.of(context).size.height * 0.58;
      } else {
        return MediaQuery.of(context).size.height * 0.42;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      AppColors.appColorWhite,
                      AppColors.appColorBlack
                    ],
                        stops: [
                      0.0,
                      0.6
                    ])),
                child: Obx(
                  () => Column(
                    children: [
                      Image.asset(
                        "assets/images/splash_logo.png",
                        width: MediaQuery.of(context).size.height < 700 &&
                                bookingController.activeBooking.isNotEmpty
                            ? 200
                            : 300,
                        height: MediaQuery.of(context).size.height < 700 &&
                                bookingController.activeBooking.isNotEmpty
                            ? 100
                            : 300,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height:
                            getBottomHeight(MediaQuery.of(context).size.height),
                        decoration: const BoxDecoration(
                          color: AppColors.appColorWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: AppLabel(
                                text:
                                    '${greeting()} ${SharedPref().getUser().firstName ?? ''}',
                                fontSize: 16,
                                textColor: AppColors.appColorBlack,
                                fontWeight: FontWeight.w500,
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
                                  Expanded(
                                      flex: 5,
                                      child: GestureDetector(
                                        onTap: () async {
                                          var status =
                                              await LocationPermission()
                                                  .getLocationPermission();
                                          print("location permission");
                                          print(status);

                                          Get.toNamed(
                                              Routes.PARKING_SEARCH_SCREEN);
                                        },
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColors.appColorLightGray
                                                .withOpacity(0.3),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.access_time_filled),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppLabel(
                                                      text: "Park Later",
                                                    ),
                                                    AppLabel(
                                                      text: "Pay & Park Later",
                                                      textColor: AppColors
                                                          .appColorGray,
                                                      fontSize: 11,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              Routes.ENTER_LOCATION_SCREEN);
                                        },
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppColors.appColorBlack,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppLabel(
                                                      text: "Park Now",
                                                      textColor: AppColors
                                                          .appColorWhite,
                                                    ),
                                                    AppLabel(
                                                      text:
                                                          "Enter Location ID & Pay",
                                                      textColor: AppColors
                                                          .appColorWhite,
                                                      fontSize: 11,
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      AppColors.appColorWhite,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: AppLabel(
                                  text: "Where would you like to park?"),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SizedBox(
                                height: 40,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.PARKING_SEARCH_SCREEN);
                                  },
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: AppColors.appColorWhiteGray,
                                      filled: true,
                                      enabled: false,
                                      hintText: "Search for a parking location",
                                      contentPadding: EdgeInsets.zero,
                                      prefixIcon: const Icon(Icons.search),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: AppColors.appColorLightGray,
                                          width: 1.0,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
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
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (bookingController
                                        .activeBooking[0].bookingModule ==
                                    'ivr') {
                                  if (bookingController
                                          .activeBooking[0].startStopOption ==
                                      true) {
                                    Get.toNamed(
                                        Routes
                                            .PARK_NOW_DONT_KNOW_PARKING_DETAILS_SCREEN,
                                        arguments:
                                            bookingController.activeBooking[0]);
                                  } else {
                                    Get.toNamed(
                                        Routes
                                            .BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
                                        arguments:
                                            bookingController.activeBooking[0]);
                                  }
                                } else {
                                  Get.toNamed(
                                      Routes
                                          .BOOKING_FIXED_DURATION_DETAILS_TAB_SCREEN,
                                      arguments:
                                          bookingController.activeBooking[0]);
                                }
                              },
                              child: Visibility(
                                  visible: bookingController
                                      .activeBooking.isNotEmpty,
                                  child: ActiveCardView()),
                            ),
                            Visibility(
                                visible: bookingController
                                        .activeBooking.isEmpty &&
                                    bookingController.upcomingBooking.isEmpty &&
                                    SharedPref.carParkPin() != null &&
                                    bookingController
                                        .completedBooking.isNotEmpty,
                                child: const ParkAgainCardView()),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.SINGLE_BOOK_SCREEN,
                                    arguments:
                                        bookingController.upcomingBooking[0]);
                              },
                              child: Visibility(
                                  visible:
                                      bookingController.activeBooking.isEmpty &&
                                          bookingController
                                              .upcomingBooking.isNotEmpty,
                                  child: UpcomingCardView()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

  void showTimePickBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor: AppColors.appColorWhite,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.appColorLightGray,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
