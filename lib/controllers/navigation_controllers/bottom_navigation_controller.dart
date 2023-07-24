import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/screens/parking/home_search_screen.dart';
import 'package:parkfinda_mobile/screens/dashboard/parking_search_screen.dart';
import '../../screens/dashboard/account_screen.dart';
import '../../screens/dashboard/bookings_screen.dart';
import '../../screens/dashboard/home_screen.dart';
import '../park_now_controller.dart';

class BottomNavigationController extends GetxController {
  var activeIndex = 0.obs;

  @override
  void onInit() {
    Get.put(BookingController(), permanent: true);

    Get.put(ParkingNowController());

    super.onInit();
  }

  final List<Map<String, dynamic>> navigationData = [
    {
      'navIcon': FontAwesomeIcons.house,
      'navTitle': 'Home',
      'navScreen': const HomeScreen(),
      'editable': false
    },
    {
      'navIcon': FontAwesomeIcons.magnifyingGlass,
      'navTitle': 'Find',
      'navScreen': const ParkingSearchScreen(
        isDashboard: true,
      ),
      'editable': false
    },
    {
      'navIcon': FontAwesomeIcons.list,
      'navTitle': 'Bookings',
      'navScreen': BookingsScreen(),
      'editable': true
    },
    {
      'navIcon': FontAwesomeIcons.solidUser,
      'navTitle': 'Account',
      'navScreen': const AccountScreen(),
      'editable': false
    },
  ];
}
