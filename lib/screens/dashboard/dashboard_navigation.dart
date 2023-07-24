import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/navigation_controllers/bottom_navigation_controller.dart';
import '../../constants/app_colors.dart';
import '../../widgets/atoms/app_label.dart';

class DashboardNavigation extends StatelessWidget {
  final autoSizeGroup = AutoSizeGroup();
  BottomNavigationController bottomNavigationController =
      Get.put(BottomNavigationController());
  BookingController bookingController =
      Get.put(BookingController(), permanent: true);

  DashboardNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: NavigationScreen(
          bottomNavigationController
                  .navigationData[bottomNavigationController.activeIndex.value]
              ['navScreen'],
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: bottomNavigationController.navigationData.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive
                ? AppColors.appColorBlack
                : AppColors.appColorLightGray;
            return !bottomNavigationController.navigationData[index]['editable']
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        bottomNavigationController.navigationData[index]
                            ['navIcon'],
                        size: 20,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          bottomNavigationController.navigationData[index]
                              ['navTitle'],
                          maxLines: 1,
                          style: TextStyle(color: color),
                          group: autoSizeGroup,
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          FaIcon(
                            bottomNavigationController.navigationData[index]
                                ['navIcon'],
                            size: 20,
                            color: color,
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Obx(() {
                              return Container(
                                height: 17,
                                width: 17,
                                decoration: BoxDecoration(
                                    color: bookingController
                                            .notificationCount.value
                                            .isLowerThan(1)
                                        ? Colors.transparent
                                        : AppColors.appColorGoogleRed,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: AppLabel(
                                    text: bookingController
                                            .notificationCount.value
                                            .isGreaterThan(9)
                                        ? '9+'
                                        : bookingController
                                            .notificationCount.value
                                            .toString(),
                                    fontSize: 12,
                                    textColor: bookingController
                                            .notificationCount.value
                                            .isLowerThan(1)
                                        ? Colors.transparent
                                        : AppColors.appColorWhite,
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          bottomNavigationController.navigationData[index]
                              ['navTitle'],
                          maxLines: 1,
                          style: TextStyle(color: color),
                          group: autoSizeGroup,
                        ),
                      ),
                    ],
                  );
          },
          backgroundColor: AppColors.appColorWhite,
          activeIndex: bottomNavigationController.activeIndex.value,
          splashSpeedInMilliseconds: 0,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.none,
          leftCornerRadius: 0,
          rightCornerRadius: 0,
          height: 56,
          onTap: (index) {
            bottomNavigationController.activeIndex.value = index;
          },
        ),
      );
    });
  }
}

class NavigationScreen extends StatefulWidget {
  final Widget screen;

  const NavigationScreen(this.screen, {super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.screen;
  }
}
