import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/account_controller.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/user.dart';
import 'package:parkfinda_mobile/screens/dashboard/dashboard_navigation.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/auth_service.dart';
import 'package:parkfinda_mobile/utils/app_alert.dart';
import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';

import '../constants/constant.dart';
import '../permissions/location_permission.dart';

class AuthController extends GetxController {
  UserController userController = Get.find<UserController>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? account;
  NetworkController networkController = Get.find<NetworkController>();
  var bookingController = Get.put(BookingController());
  var accountController = Get.put(AccountController());
  static GetStorage userBox = GetStorage(Constant.userBox);

//facebook signin
  void facebookSigning() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        final LoginResult result = await FacebookAuth.instance.login();
        AppOverlay.hideOverlay();
        if (result.status == LoginStatus.success) {
          print('acsess token is--------------->${result.accessToken!.token}');

          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          AppCustomToast.errorToast('Login fail');
          AppOverlay.hideOverlay();
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  void appleSigning() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.parkfinda.customer.auth',
            redirectUri: Uri.parse(
              'https://festive-troubled-cardamom.glitch.me/callbacks/sign_in_with_apple',
            ),
          ),
        );
        AppOverlay.hideOverlay();

        print(credential);
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

//google signin
  void googleSigning() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        account = await _googleSignIn.signIn();

        if (account != null) {
          account!.authentication.then(
            (value) async {
              print(value.accessToken);
              var responce =
                  await AuthService().googleSignIn(value.accessToken!);
              if (responce.statusCode == 200) {
                AppOverlay.hideOverlay();
                print("-------------->google token");
                print(responce.data);
              }
            },
          );
          Get.offAllNamed(Routes.DASHBOARD);
          print(account!.email);
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Login fail');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      print("-------------->google token hit4");
      AppOverlay.hideOverlay();
      print(e);
    }
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

  //login email and phone number
  void emailSignIn(
      {required String email,
      required String password,
      required String page}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce =
            await AuthService().emailSignIn(email: email, password: password);
        print(responce.data);

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            await getTimeZone();
            userController.user.value = User.fromJson(
                responce.data['data']['customer'],
                responce.data['data']['tokens']);

            userController.saveUserData();

            // await userController.getCardDetail();

            if (Get.previousRoute == '/ParkNowSetDurationScreen' ||
                Get.previousRoute == '/ParkLaterSetDurationScreen') {
              await accountController.createVehicleInGuest(
                  numberPlate: userController.selectedVehicle!.value!.vRN!,
                  routes: Get.previousRoute);
            } else if (page == '/BottomSheet') {
              await accountController.createVehicleInGuest(
                  numberPlate: userController.selectedVehicle!.value!.vRN!,
                  routes: '/BottomSheet');
            } else {
              await bookingController.getAllBooking();
              await userController.getVehicleData(
                  url: SharedPref.getTimeZone() == 'Asia/Colombo'
                      ? Constant.slUrl
                      : Constant.ukUrl);
              Get.offAllNamed(Routes.DIRECT_DASHBOARD);
              userController.isLoading.value = true;
            }
            AppOverlay.hideOverlay();

            ///ParkNowSetDurationScreen
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
            userController.isLoading.value = true;
            AppOverlay.hideOverlay();
          }
        } else {
          AppCustomToast.errorToast('something went wrong');
          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        userController.isLoading.value = true;
        AppOverlay.hideOverlay();
      }
    } on DioError catch (e) {
      userController.isLoading.value = true;
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  //signin account
  void emailSignUp(
      {required String firstName,
      required String lastName,
      required String countryCode,
      required String email,
      required String page,
      required BuildContext context,
      required String password,
      required String phone}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService().emailSignUp(
            countryCode: countryCode,
            firstname: firstName,
            lastname: lastName,
            email: email,
            password: password,
            phone: phone);
        print("----------->xxx ${responce.data}");
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            await getTimeZone();
            print('data->${responce.data['data']['customer']}');
            print(' token ->${responce.data['data']['tokens']}');
            userController.user.value = User.fromJson(
                responce.data['data']['customer'],
                responce.data['data']['tokens']);

            userController.saveUserData();

            await userController.getCardDetail();
            print('---------------->previous');

            print(Get.previousRoute);

            if (Get.previousRoute == '/ParkNowSetDurationScreen' ||
                Get.previousRoute == '/ParkLaterSetDurationScreen') {
              print('------------previous route');
              // await userController.getVehicleData();
              // await accountController.createVehicle(
              //     numberPlate: userController.selectedVehicle!.value!.vRN!,
              //     routes: Get.previousRoute);

              await accountController.createVehicleInGuest(
                  numberPlate: userController.selectedVehicle!.value!.vRN!,
                  routes: Get.previousRoute);
            } else if (page == '/BottomSheet') {
              await accountController.createVehicleInGuest(
                  numberPlate: userController.selectedVehicle!.value!.vRN!,
                  routes: '/BottomSheet');
            } else {
              await bookingController.getAllBooking();
              await userController.getVehicleData(
                  url: SharedPref.getTimeZone() == 'Asia/Colombo'
                      ? Constant.slUrl
                      : Constant.ukUrl);
              Get.offAllNamed(Routes.DIRECT_DASHBOARD);
              userController.isLoading.value = true;
            }
            AppOverlay.hideOverlay();
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
            userController.isLoading.value = true;
            AppOverlay.hideOverlay();
          }
        } else {
          AppCustomToast.errorToast('something went wrong');
          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        userController.isLoading.value = true;
        AppOverlay.hideOverlay();
      }
    } on DioError catch (e) {
      userController.isLoading.value = true;
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  void guestUserLogin(BuildContext context) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService().guestUserLogin();
        AppOverlay.hideOverlay();
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print("guest user login data----------->");
            print('data->${responce.data['data']['customer']}');
            print(' token ->${responce.data['data']['tokens']}');
            userController.user.value = User.fromJson(
                responce.data['data']['customer'],
                responce.data['data']['tokens']);

            userController.saveUserData();
            Get.offAll(DashboardNavigation());
            print(SharedPref.isGuestAccount());
          } else {}
        } else {
          AppCustomToast.errorToast('something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

//forgot email password
  void forgetPassword(
      {required String email, required BuildContext context}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService().forgetPassword(email: email);
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            Get.toNamed(Routes.LOGIN);

            AppAlert().showAlertDialog(context);

            // AppCustomToast.successToast(
            //     "Email Sent. Please reset your passowrd");
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future logOut(BuildContext context) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        Get.back();
        Get.back();

        var responce = await AuthService().logOut(SharedPref.getToken()!);

        if (responce.data['errorMessage'] == null) {
          AppOverlay.hideOverlay();
          userController.isLoading.value = true;
          AppCustomToast.successToast(responce.data['message']);
          SharedPref.userBox.erase();
          SharedPref.parkAgainDetail.erase();
          userController.user = Rxn<User>();
          // Get.delete<UserController>();
          bookingController.activeBooking.value = [];
          bookingController.upcomingBooking.value = [];
          bookingController.completedBooking.value = [];
          bookingController.notificationCount.value = 0;
          userController.selectedVehicle?.value = null;
          userController.cardList.value = [];

          Get.delete<BookingController>();
          //  Get.deleteAll();
          bool status = await LocationPermission().getLocationPermission();
          if (status) {
            AuthController().guestUserLogin(context);
          }
          Get.offAll(DashboardNavigation());
          userBox.write(Constant.guest, true);
        } else {
          AppCustomToast.errorToast(responce.data['message'].toString());
          AppOverlay.hideOverlay();
          userController.isLoading.value = true;
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
        userController.isLoading.value = true;
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      userController.isLoading.value = true;
      print(e);
    }
  }

  void verifyForgetPassword(
      {required String otp,
      required BuildContext context,
      required String userId}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce =
            await AuthService().verifyForgetPassword(otp: otp, userId: userId);
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            // AppCustomToast.successToast(responce.data['message']);
            //data

            Get.toNamed(Routes.FORGET_PASSWORD_RESET_SCREEN, arguments: userId);
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void updatePassword(
      {required String password,
      required BuildContext context,
      required String userId}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService()
            .updatePassword(password: password, userId: userId);
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            // AppCustomToast.successToast(responce.data['message']);
            //data
            Get.toNamed(Routes.LOGIN);
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('something went wrong');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }
}
