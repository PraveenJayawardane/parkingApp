import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/widgets/molecules/containers/wallet_card_view.dart';

import '../../constants/app_colors.dart';
import '../../constants/constant.dart';
import '../../controllers/user_controller.dart';
import '../../services/local/shared_pref.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();
  @override
  void initState() {
    if (SharedPref.getTimeZone() == 'Asia/Colombo') {
      bookingController.baseUrl.value = Constant.slUrl;
    } else {
      bookingController.baseUrl.value = Constant.ukUrl;
    }
    print(Get.routing.previous);
    if (userController.curentRegion == false) {
      userController.getSingleRegionCardDetail(
          url: SharedPref.getTimeZone() == 'Asia/Colombo'
              ? Constant.ukUrl
              : Constant.slUrl);
      bookingController.baseUrl.value =
          SharedPref.getTimeZone() == 'Asia/Colombo'
              ? Constant.ukUrl
              : Constant.slUrl;
    } else {
      if (Get.routing.previous == '/DirectDashbord' ||
          Get.routing.previous == '/Dashboard') {
        userController.getSingleRegionCardDetail(
            url: SharedPref.getTimeZone() == 'Asia/Colombo'
                ? Constant.slUrl
                : Constant.ukUrl);
      } else {
        if (SharedPref.getCurerentParkCurrency() != null) {
          userController.getSingleRegionCardDetail(
              url: SharedPref.getCurerentParkCurrency() == 'LKR'
                  ? Constant.slUrl
                  : Constant.ukUrl);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(bookingController.baseUrl);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.appColorBlack,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: AppColors.appColorBlack, width: 0.5)),
        title: const Text(
          "My Wallet",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Payment Methods",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColors.appColorBlack01,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          Obx(
            () => userController.isWalletLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userController.cardList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: WalletCardView(
                              cardDetail: userController.cardList[index]),
                        );
                      },
                    ),
                  ),
          ),
          Visibility(
            // ignore: unrelated_type_equality_checks
            visible: bookingController.baseUrl == Constant.ukUrl ? true : false,
            child: Obx(
              () => Visibility(
                visible: userController.isWalletLoading.value ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.ADD_PAYMENT_METHOD_SCREEN,
                          arguments: ['', '', '']);
                    },
                    child: Row(
                      children: const [
                        Icon(FontAwesomeIcons.plus, size: 15),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Add Payment Method",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.appColorBlack01,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
