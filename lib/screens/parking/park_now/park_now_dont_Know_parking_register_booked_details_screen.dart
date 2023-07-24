import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/park_now_dont_know_parking_tab_controller.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../booking/booking_fixed_duration_access_tab.dart';
import '../parking_tabs/dont_know_parking_register_details_tab.dart';
import '../parking_tabs/dont_know_parking_register_status_tab.dart';

class ParkNowDontKnowParkingRegisterBookedDetailsScreen extends StatefulWidget {
  final FixedDurationbooking dontknowparkingbooking;
  const ParkNowDontKnowParkingRegisterBookedDetailsScreen(
      {Key? key, required this.dontknowparkingbooking})
      : super(key: key);

  //FixedDurationbooking dontknowparkingbooking = Get.arguments;

  @override
  State<ParkNowDontKnowParkingRegisterBookedDetailsScreen> createState() =>
      _ParkNowDontKnowParkingBookedDetailsScreenState();
}

class _ParkNowDontKnowParkingBookedDetailsScreenState
    extends State<ParkNowDontKnowParkingRegisterBookedDetailsScreen> {
  var time;

  ParkNowDontKnowParkingTabController parkingTabController =
      Get.put(ParkNowDontKnowParkingTabController());

  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  @override
  void initState() {
    time = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(
            widget.dontknowparkingbooking.booking?.bookingStart ?? 0))
        .inSeconds;

    super.initState();
    stopWatchTimer.minuteTime.listen((value) {
      print('minuteTime $value');
    });
    stopWatchTimer.secondTime.listen((value) {
      print('secondTime $value');
    });
    stopWatchTimer.records.listen((value) {
      print('records $value');
    });
    stopWatchTimer.fetchStopped.listen((value) {});
    stopWatchTimer.fetchEnded.listen((value) {
      print('ended from stream');
    });

    /// Can be set preset time. This case is "00:01.23".
    DateTime startedTime = DateTime.now().add(const Duration(minutes: 0));
    DateTime currentTime = DateTime.now();
    Duration diff = startedTime.difference(currentTime);

    stopWatchTimer.setPresetTime(mSec: diff.inMilliseconds);
  }

  @override
  Widget build(BuildContext context) {
    print(time);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
            color: AppColors.appColorLightGray,
          ),
          TabBar(
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: AppColors.appColorBlack,
              controller: parkingTabController.dontKnowtabController,
              tabs: parkingTabController.dontKnowbookingTabs),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: TabBarView(
                controller: parkingTabController.dontKnowtabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DontKnowParkingRegisterStatusTab(
                        stopWatchTimer: stopWatchTimer,
                        dontknowparkingbooking: widget.dontknowparkingbooking),
                  ),
                   BookingFixedDurationAccessTab(acsessInformation:widget.dontknowparkingbooking.carPark?.accessInformation ),
                  DontKnowParkingRegisterDetailsTab(
                      dontknowparkingbooking: widget.dontknowparkingbooking),
                ]),
          ),
        ],
      ),
    );
  }
}
