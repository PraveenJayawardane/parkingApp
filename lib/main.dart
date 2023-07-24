import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parkfinda_mobile/constants/app_colors.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/user.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/auth_service.dart';
import 'package:parkfinda_mobile/constants/constant.dart';
import 'constants/routes.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  tz.initializeTimeZones();
  await GetStorage.init(Constant.userBox);
  await GetStorage.init(Constant.parkAgainDetail);
  WidgetsFlutterBinding.ensureInitialized();
  await getTimeZone();
  await checkVersion();
  Get.lazyPut<NetworkController>(() => NetworkController(), fenix: true);
  UserController userController = Get.put(UserController(), permanent: true);
  await getTimeZone();
  await validateUser();
  configLoading();
  runApp(const MyApp());
}

final _checker = InStoreAppVersionChecker();

Future checkVersion() async {
  var userBox = GetStorage(Constant.userBox);
  _checker.checkUpdate().then((value) {
    print(value.currentVersion);
    print(value.newVersion);
    if (value.canUpdate) {
      userBox.write(Constant.hasUpdate, true);
    } else {
      userBox.write(Constant.hasUpdate, false);
    }
  });
}

Future<void> getTimeZone() async {
  try {
    var timezone = await FlutterNativeTimezone.getLocalTimezone();
    SharedPref.setTimeZone(timezone);
    print('----> date time');
    print(SharedPref.getTimeZone());
  } catch (e) {
    debugPrint('$e');
  }
}

Future validateUser() async {
  UserController userController = Get.find<UserController>();
  var userBox = GetStorage(Constant.userBox);
  userBox.write(Constant.isValidToken, false);

  if (SharedPref.hasToken()) {
    try {
      var responce = await AuthService().validateToken(SharedPref.getToken()!);
      if (responce.statusCode == 200) {
        print(responce.data);
        if (responce.data['errorMessage'] == null) {
          userBox.write(Constant.isValidToken, true);
          userBox.write(
              Constant.otpVerified, responce.data['data']['otpVerified']);
          // userController.getVehicleData(
          //     url: SharedPref.getTimeZone() == 'Asia/Colombo'
          //         ? Constant.slUrl
          //         : Constant.ukUrl);
          userController.user.value =
              User.fromJson(responce.data['data'], SharedPref.getToken()!);
          userController.saveUserData();
        } else {
          userBox.write(Constant.isValidToken, false);
        }
      }
    } on DioError catch (e) {
      print(e);
    }
  } else {
    print('no Token');
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 8.0
    ..progressColor = AppColors.appColorWhite
    ..backgroundColor = AppColors.appColorBlack
    ..indicatorColor = AppColors.appColorWhite
    ..textColor = AppColors.appColorWhite
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print(SharedPref.getToken());
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: 'Parkfinda',
      initialRoute: Routes.DASHBOARD,
      getPages: Routes.getPageRoutes(),
      theme: ThemeData(
          primarySwatch: AppColors.appMaterialBlack, fontFamily: 'Poppins'),
    );
  }
}
