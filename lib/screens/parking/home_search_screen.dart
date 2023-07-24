import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/navigation_controllers/bottom_navigation_controller.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/location_info_tab_controller.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/custom_filled_button.dart';
import 'package:parkfinda_mobile/widgets/molecules/buttons/vehicle_type_group_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../controllers/tab_controllers/day_month_tab_controller.dart';


class HomeSearchScreen extends StatefulWidget {
  HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  final double _initFabHeight = 250.0;

  double _fabHeight = 0;

  double _panelHeightOpen = 0;

  double _panelHeightClosed = 50.0;

  PanelController defaultBottomSheetController = PanelController();
  final DayMonthTabController dayMonthTabController =
      Get.put(DayMonthTabController());

  final LocationInfoTabController locationInfoTabController =
  Get.put(LocationInfoTabController());

  BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  var showTopContainer = false.obs;
  var isPinAnimate = false.obs;
  var bottomSheetInit = false;
  var showBottomSheetDashBar = false;
  LatLng initialDestination = const LatLng(51.5072, 0.1276);
  var pickedStartTime = DateTime.now().obs;
  var pickedEndTime = DateTime.now().add(const Duration(hours: 1)).obs;
  var pickedLocationName = "Where are you parking?";

  var initLatLang = LatLng(6.9271,79.8583);
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    bottomSheetInit = true;
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .27;

    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            parallaxEnabled: false,
            parallaxOffset: .5,
            collapsed: const Icon(
              Icons.keyboard_arrow_up,
              size: 28,
            ),
            defaultPanelState: PanelState.OPEN,
            controller: defaultBottomSheetController,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            minHeight: _panelHeightClosed,
            maxHeight: _panelHeightOpen,
            onPanelOpened: () {
              showTopContainer.value = false;
              showBottomSheetDashBar = false;
            },
            onPanelClosed: () {
              showTopContainer.value = true;
              showBottomSheetDashBar = true;
            },
            onPanelSlide: (pos) {
              setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + 80;
              });
            },
            panel: defaultBottomSheetView(),

            body: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  //myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller){
                    mapController = controller;
                  },
                  onCameraMoveStarted: (){
                    showTopContainer.value = false;
                    isPinAnimate.value = false;
                  },
                  onCameraIdle: ()async{
                    showTopContainer.value = true;
                    isPinAnimate.value = true;

                    LatLngBounds bounds = await mapController!.getVisibleRegion();
                    final lon = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
                    final lat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                    print("lat ->$lat");
                    print("lon ->$lon");
                  },

                  initialCameraPosition: CameraPosition(target: initLatLang,zoom: 16),

                ),

                Center(child: _buildAnimatedLocationPin(),),

                Positioned(
                  top: 52.0,
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
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: AppColors.appColorBlack,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          showTopContainer.value = false;
                                        },
                                      ),
                                      InkWell(
                                        onTap: () {

                                          bottomNavigationController.activeIndex.value = 1;
                                        },
                                        child: AppLabel(
                                          text: pickedLocationName,
                                          fontSize: 14,
                                          textColor: AppColors.appColorLightGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: AppColors.appColorLightGray,
                                    height: 1,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showTimePickBottomSheet();
                                          },
                                          child: Obx(() {
                                            return AppLabel(
                                              text:
                                              "Today at ${pickedStartTime.value.hour}:${pickedStartTime.value.minute}",
                                              fontSize: 14,
                                              textColor: AppColors.appColorLightGray,
                                            );
                                          }),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                            color: AppColors.appColorBlack,
                                            size: 16,
                                          ),
                                          onPressed: () {},
                                        ),
                                        InkWell(
                                          onTap: (){
                                            showTimePickBottomSheet();
                                          },
                                          child: Obx(() {
                                            return AppLabel(
                                              text:
                                              "Today at ${pickedEndTime.value.hour}:${pickedEndTime.value.minute}",
                                              fontSize: 14,
                                              textColor: AppColors.appColorLightGray,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            VehicleTypeGroupButton()
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),

          ),
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              child: Icon(
                Icons.gps_fixed,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _currentLocation() async {

  }

  Widget _buildAnimatedLocationPin(){
    //return FaIcon(Icons.location_on,size: 60,);
    return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap : (){
                    showSingleLocationDetailsBottomSheet();
                  },
                  child: FaIcon(Icons.location_on,size: 50,),
                ),

                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );

  }

  Widget defaultBottomSheetView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: !showBottomSheetDashBar,
            child: Center(
              child: Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                    color: AppColors.appColorLightGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          AppLabel(
            text: "Good Morning!",
            fontSize: 12,
            textColor: AppColors.appColorGray,
          ),
          const SizedBox(
            height: 10,
          ),
          AppLabel(text: "Where would you like to park today?"),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.appColorLightGray.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_filled),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                text: "Park Later",
                                fontWeight: FontWeight.bold,
                              ),
                              AppLabel(
                                text: "Pay & park later",
                                textColor: AppColors.appColorGray,
                                fontSize: 11,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 6,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.appColorBlack,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLabel(
                                text: "Park Now",
                                fontWeight: FontWeight.bold,
                                textColor: AppColors.appColorWhite,
                              ),
                              AppLabel(
                                text: "Enter Location ID & Pay",
                                textColor: AppColors.appColorWhite,
                                fontSize: 11,
                              )
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.appColorWhite,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyTimeLapSelectingView() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                //  buildCupertinoDatePicker();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width * 0.44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.appColorLightGray)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppLabel(
                        text: "Parking from",
                        fontSize: 12,
                        textColor: AppColors.appColorGray,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(() {
                        return AppLabel(
                          text:
                              "${pickedStartTime.value.hour}:${pickedStartTime.value.minute} ${pickedStartTime.value.hour >= 12 && pickedStartTime.value.hour < 24 ? "PM" : "AM"}",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        );
                      }),
                      const SizedBox(
                        height: 3,
                      ),
                      AppLabel(
                        text: "Today",
                        fontSize: 12,
                        textColor: AppColors.appColorGray,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                //  buildCupertinoDatePicker(isStartTime: false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  width: MediaQuery.of(context).size.width * 0.44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.appColorLightGray)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppLabel(
                        text: "Parking until",
                        fontSize: 12,
                        textColor: AppColors.appColorGray,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(() {
                        return AppLabel(
                          text:
                              "${pickedEndTime.value.hour}:${pickedEndTime.value.minute} ${pickedEndTime.value.hour >= 12 && pickedEndTime.value.hour < 24 ? "PM" : "AM"}",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        );
                      }),
                      const SizedBox(
                        height: 3,
                      ),
                      AppLabel(
                        text: "Today",
                        fontSize: 12,
                        textColor: AppColors.appColorGray,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomFilledButton(text: "proceed to checkout", clickEvent: () {}),
        )
      ],
    );
  }



  void showTimePickBottomSheet(){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor:
      AppColors.appColorWhite,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context)
            .size
            .height *
            0.45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),
                color: AppColors
                    .appColorLightGray,
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
                indicatorPadding:
                const EdgeInsets.symmetric(
                    horizontal: 20),
                indicatorColor:
                AppColors.appColorBlack,
                controller:
                dayMonthTabController
                    .tabController,
                tabs: dayMonthTabController
                    .dayMonthTabs),
            Flexible(
              child: TabBarView(
                  controller:
                  dayMonthTabController
                      .tabController,
                  children: [
                    dailyTimeLapSelectingView(),
                    dailyTimeLapSelectingView(),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  void showSingleLocationDetailsBottomSheet(){
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
      ),
      context: context,
      backgroundColor:
      AppColors.appColorWhite,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: AppColors
                      .appColorLightGray,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: AppLabel(text: "Boston Central Car Park"),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(children: [
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        unratedColor: AppColors.appColorLightGray.withOpacity(0.2),
                        itemCount: 5,
                        itemSize: 18,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SizedBox(width: 8,),
                      AppLabel(text: "30 reviews",textColor: AppColors.appColorLightGray,fontSize: 14,),
                    ],),
                  ),
                    const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: AppLabel(text: "Reservable",fontSize: 14,textColor: AppColors.appColorGreen,),
                  )
                ],),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.appColorLightGray.withOpacity(0.2)
                        ),
                        child: const Center(child: Icon(Icons.location_on_outlined)),
                      ),
                      AppLabel(text: "Direction",fontSize: 10,textColor: AppColors.appColorLightGray,)
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            TabBar(
                indicatorPadding:
                const EdgeInsets.symmetric(
                    horizontal: 20),
                indicatorColor:
                AppColors.appColorBlack,
                controller:
                locationInfoTabController
                    .tabController,
                tabs: locationInfoTabController
                    .locationInfoTabs),
            Expanded(
              child: TabBarView(
                  controller:
                  locationInfoTabController
                      .tabController,
                  children: [
                    singleLocationInfoTab(),
                    singleLocationReviewTab(),
                    singleLocationHowItWorkTab(),
                  ]),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16,bottom: 16),
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.appColorLightGray.withOpacity(0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_filled),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLabel(
                                    text: "Park Later",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AppLabel(
                                    text: "Pay & park later",
                                    textColor: AppColors.appColorGray,
                                    fontSize: 11,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.appColorBlack,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLabel(
                                    text: "Park Now",
                                    fontWeight: FontWeight.bold,
                                    textColor: AppColors.appColorWhite,
                                  ),
                                  AppLabel(
                                    text: "Enter Location ID & Pay",
                                    textColor: AppColors.appColorWhite,
                                    fontSize: 11,
                                  )
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.appColorWhite,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleLocationInfoTab(){
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Column(children: [
                  Image.asset('assets/images/cctv.png'),
                  SizedBox(height: 6,),
                  AppLabel(text: "CCTV",fontSize: 12,textColor: AppColors.appColorLightGray,)
                ],),
                
                const SizedBox(width: 20,),
                Column(children: [
                  Image.asset('assets/images/security.png'),
                  SizedBox(height: 6,),
                  AppLabel(text: "Security",fontSize: 12,textColor: AppColors.appColorLightGray,)
                ],),
              ],
            ),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(
                fontSize: 12,
                textColor: AppColors.appColorLightGray,
                text: "When you arrive at Boston Logan, follow the signs for Central Parking or Terminal B Garage from the airport’s inbound roadway. We request that all vehicles park head-in at all Boston Logan parking facilities."),
          ),

        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(AppColors.appColorBlack),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: const BorderSide(color: AppColors.appColorBlack)))),
              onPressed: () {

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.access_time),
                  SizedBox(width: 8,),
                  Text(
                        "Street View",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )

                ],
              )),
        ),

        ],
      ),
    );
  }

  Widget singleLocationReviewTab(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(children: [
              AppLabel(text: "Mark Jakob",fontSize: 14,fontWeight: FontWeight.bold,),
              const SizedBox(width: 30,),
              AppLabel(text: "20 Aug, 2021",fontSize: 12, textColor: AppColors.appColorLightGray,)
            ],),
          ),

          const SizedBox(height: 8,),
          
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              unratedColor: AppColors.appColorLightGray.withOpacity(0.2),
              itemCount: 5,
              itemSize: 18,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AppLabel(
              fontSize: 13,
                textColor: AppColors.appColorLightGray,
                text: "Perfect place to park. Decent price and will be parking again definitely for our next trip."),
          )

        ],
      ),
    );
  }

  Widget singleLocationHowItWorkTab(){
    return SingleChildScrollView(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset("assets/images/car_park.png"),
              SizedBox(width: 10,),
              Expanded(child: AppLabel(
                  fontSize: 13,

                  text: "After the Payment is done, You will recieve directions to the parking space")),

            ],
          ),
        ),
        const SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset("assets/images/car_park.png"),
              SizedBox(width: 10,),
              Expanded(child: AppLabel(
                  fontSize: 13,

                  text: "The parking space owner will be notified regarding your booking")),

            ],
          ),
        ),
        const SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Image.asset("assets/images/car_park.png"),
              SizedBox(width: 10,),
              Expanded(child: AppLabel(
                  fontSize: 13,

                  text: "Just show up, park your car, and continue on with your day.")),

            ],
          ),
        )

      ],
    ));
  }

  // void buildCupertinoDatePicker({bool isStartTime = true}) async{
  //   DatePicker.showPicker(context, showTitleActions: true,
  //       onChanged: (date) {
  //         print('change $date in time zone ' +
  //             date.timeZoneOffset.inHours.toString());
  //       }, onConfirm: (date) {
  //         print('confirm $date');
  //       },
  //       pickerModel: CustomPicker(currentTime: DateTime.now()),
  //       locale: LocaleType.en);

  // }
}
