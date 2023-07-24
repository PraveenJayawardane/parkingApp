import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/tab_controllers/booking_tab_controller.dart';

import '../booking/booking_tabs/active_tab.dart';
import '../booking/booking_tabs/completed_tab.dart';
import '../booking/booking_tabs/upcoming_tab.dart';

class BookingsScreen extends StatefulWidget {
  BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with TickerProviderStateMixin {
  final BookingTabController bookingTabController =
      Get.put(BookingTabController());

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        title: const Text(
          "Bookings",
          style: TextStyle(color: AppColors.appColorBlack),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          color: AppColors.appColorLightGray.withOpacity(0.2),
          child: Column(
            children: [
              // Divider(thickness: 1,color: AppColors.appColorWhiteGray,),
              ColoredBox(
                color: AppColors.appColorWhite,
                child: TabBar(
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    indicatorColor: AppColors.appColorBlack,
                    controller: bookingTabController.tabController,
                    tabs: bookingTabController.bookingTabs),
              ),

              Expanded(
                child: TabBarView(
                    controller: bookingTabController.tabController,
                    children: [
                      ActiveTab(),
                      UpcomingTab(),
                      CompletedTab(),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
