import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/auth_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:parkfinda_mobile/widgets/atoms/app_label.dart';
import '../../constants/app_colors.dart';
import '../../services/local/shared_pref.dart';
import '../../widgets/molecules/buttons/bordered_button.dart';
import '../../widgets/molecules/buttons/custom_filled_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  var userController = Get.put(UserController());
  var accountController = Get.put(AccountController());

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();
    print(SharedPref.getTimeZone());
  }

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
        backgroundColor: AppColors.appColorWhite,
        title: const Text(
          "Account",
          style: TextStyle(
              color: AppColors.appColorBlack, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _animation,
                  child: Column(
                    children: [
                      Visibility(
                        visible: !SharedPref.isGuestAccount(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() {
                              if (userController.user.value?.profilePicture ==
                                  null) {
                                return CircularProfileAvatar(
                                  "",
                                  cacheImage: true,
                                  borderColor: AppColors.appColorLightGray,
                                  borderWidth: 6,
                                  elevation: 2,
                                  radius: 60,
                                  child: Container(
                                      color: AppColors.appColorLightGray,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '',
                                        style: TextStyle(
                                            color: AppColors.appColorGray,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      )),
                                );
                              } else {
                                return CircularProfileAvatar(
                                  '',
                                  cacheImage: true,
                                  borderColor: AppColors.appColorLightGray,
                                  borderWidth: 6,
                                  elevation: 2,
                                  radius: 60,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: userController
                                        .user.value!.profilePicture!,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            color: AppColors.appColorGray,
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                );
                              }
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () => AppLabel(
                                text:
                                    userController.user.value?.firstName ?? '-',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Obx(
                              () => AppLabel(
                                text: userController.user.value?.email ?? '-',
                                fontSize: 14,
                                textColor: AppColors.appColorBlack,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            BorderedButton(
                                text: "Edit Account",
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 40,
                                clickEvent: () {
                                  Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                                }),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !SharedPref.isGuestAccount(),
                        child: const SizedBox(
                          height: 20,
                        ),
                      ),
                      Visibility(
                        visible: !SharedPref.isGuestAccount(),
                        child: Divider(
                          thickness: 10,
                          color: AppColors.appColorLightGray.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: InkWell(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        FaIcon(FontAwesomeIcons.car),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "My Vehicles",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                  onTap: () {
                                    if (SharedPref.isGuestAccount()) {
                                      Get.toNamed(Routes.SIGNUP);
                                    } else {
                                      Get.toNamed(Routes.MY_VEHICLES_SCREEN);
                                    }
                                  }),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const Divider(
                                thickness: 1,
                                color: AppColors.appColorLightGray,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: InkWell(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        FaIcon(FontAwesomeIcons.briefcase),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "My Wallet",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                  onTap: () {
                                    if (SharedPref.isGuestAccount()) {
                                      Get.toNamed(Routes.SIGNUP);
                                    } else {
                                      Get.toNamed(Routes.MY_WALLET_SCREEN);
                                    }
                                  }),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const Divider(
                                thickness: 1,
                                color: AppColors.appColorLightGray,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: InkWell(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        FaIcon(FontAwesomeIcons.bell),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Notifications",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                  onTap: () {
                                    if (SharedPref.isGuestAccount()) {
                                      Get.toNamed(Routes.SIGNUP);
                                    } else {
                                      Get.toNamed(Routes.NOTIFICATION_SCREEN);
                                    }
                                  }),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const Divider(
                                thickness: 1,
                                color: AppColors.appColorLightGray,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            InkWell(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      FaIcon(FontAwesomeIcons.noteSticky),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Terms & Conditions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                onTap: () {
                                  Get.toNamed(Routes.TERMS_OF_USE_SCREEN);
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      FaIcon(FontAwesomeIcons.shield),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Privacy Policy",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                onTap: () {
                                  Get.toNamed(Routes.PRIVACY_POLICY_SCREEN);
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      FaIcon(FontAwesomeIcons.circleQuestion),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Help",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                onTap: () {
                                  Get.toNamed(Routes.HELP_SCREEN);
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.appColorLightGray,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: InkWell(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        FaIcon(FontAwesomeIcons.gear),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Settings",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                  onTap: () {
                                    Get.toNamed(Routes.SELECT_COUNTRY_SCREEN);
                                  }),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const SizedBox(
                                height: 10,
                              ),
                            ),
                            Visibility(
                              visible:
                                  SharedPref.isGuestAccount() ? false : true,
                              child: const Divider(
                                thickness: 1,
                                color: AppColors.appColorLightGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !SharedPref.isGuestAccount(),
              child: Obx(
                () => Visibility(
                  visible: userController.isLoading.value,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5),
                          child: CustomFilledButton(
                              text: "Logout",
                              clickEvent: () {
                                userLogOutBottomSheet();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5),
                          child: BorderedButton(
                              text: "Delete My Account",
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              clickEvent: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const Text(
                                          'Delete Account?',
                                          textAlign: TextAlign.left,
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete account?',
                                          textAlign: TextAlign.left,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                              accountController.deleteUser(
                                                  context: context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: SharedPref.isGuestAccount(),
              child: Obx(
                () => Visibility(
                  visible: userController.isLoading.value,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: CustomFilledButton(
                          text: "LogIn or Signup",
                          clickEvent: () {
                            Get.toNamed(Routes.GET_STARTED_SCREEN);
                          }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void userLogOutBottomSheet() {
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
          AppLabel(text: "Are you sure you want to logout?"),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomFilledButton(
                text: "Logout",
                clickEvent: () async {
                  userController.isLoading.value = false;
                  AppOverlay.startOverlay(context);
                  AuthController().logOut(context);
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BorderedButton(
              text: "Cancel",
              clickEvent: () {},
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
