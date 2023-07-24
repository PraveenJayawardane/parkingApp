import 'dart:io';
import 'package:dio/dio.dart';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/controllers/park_later_controller.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Vehical.dart';
import 'package:parkfinda_mobile/services/remote/account_service.dart';
import 'package:parkfinda_mobile/services/remote/auth_service.dart';
import 'package:parkfinda_mobile/utils/app_back_button.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import '../constants/constant.dart';
import '../model/user.dart';
import '../permissions/location_permission.dart';
import '../screens/dashboard/dashboard_navigation.dart';
import '../services/local/shared_pref.dart';
import '../utils/app_custom_toast.dart';
import 'auth_controller.dart';
import 'booking_controller.dart';

class AccountController extends GetxController {
  UserController userController = Get.find<UserController>();
  NetworkController networkController = Get.find<NetworkController>();
  var profilePictureUpdateState = false.obs;
  var parkingController = Get.put(ParkingNowController());
  ParkingLaterController parkingLaterController =
      Get.put(ParkingLaterController());
  var bookingController = Get.put(BookingController());
  static GetStorage userBox = GetStorage(Constant.userBox);

  Future<void> editAccount(
      {required String email,
      required String firstNAme,
      required String lastName,
      required String countryCode,
      required String mobileNumber}) async {
    if (networkController.connectionStatus.value != -1) {
      try {
        var responce = await AuthService().editAccount(
            countryCode: countryCode,
            email: email,
            firstName: firstNAme,
            lastNAme: lastName,
            mobileNumber: mobileNumber,
            token: SharedPref.getToken()!);
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            userController.user.value =
                User.fromJson(responce.data['data'], SharedPref.getToken()!);
            userController.saveUserData();

            print(responce.statusCode);
            // AppCustomToast.successToast(responce.data['message']);
            AppOverlay.hideOverlay();
            userController.isLoading.value = true;
            Get.back();
          } else {
            print(responce.data['errorMessage']);
            AppCustomToast.errorToast(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            userController.isLoading.value = true;
          }
        } else {
          AppCustomToast.errorToast('something went wrong');
          AppOverlay.hideOverlay();
          userController.isLoading.value = true;
        }
      } on DioError catch (e) {
        print(e);
        AppOverlay.hideOverlay();
        userController.isLoading.value = true;
      }
    } else {
      AppCustomToast.warningToast('Please check your internet connection');
      AppOverlay.hideOverlay();
      userController.isLoading.value = true;
    }
  }

  Future<void> changePassword(String curentPassword, String newPassword) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService().changePassword(
            curentPassword, newPassword, SharedPref.getToken()!);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            AppOverlay.hideOverlay();
            userController.isLoading.value = true;
            print(responce.statusCode);
            //  AppCustomToast.successToast(responce.data['message']);
            Get.back();
          } else {
            print(responce.data['errorMessage']);
            AppCustomToast.errorToast(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            userController.isLoading.value = true;
          }
        } else {
          AppCustomToast.errorToast('something went wrong');
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

  Future<void> uploadImage(CroppedFile? image) async {
    String? url;
    try {
      if (networkController.connectionStatus.value != -1) {
        userController.photoLoading.value = true;

        url = await AwsS3.uploadFile(
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
            destDir: Constant.destDir,
            accessKey: Constant.secretKey,
            secretKey: Constant.secretId,
            file: File(image!.path),
            bucket: Constant.bucketName,
            region: Constant.region);
        if (url != null) {
          try {
            var result = await AuthService()
                .updateProfilePicture(SharedPref.getToken()!, url);
            print(result.data);
            if (result.data['errorMessage'] == null) {
              userController.user.value =
                  User.fromJson(result.data['data'], SharedPref.getToken()!);

              print('update sucsess');
              userController.photoLoading.value = false;
            }
          } catch (e) {
            userController.photoLoading.value = false;
            print(e);
          }
        } else {
          userController.photoLoading.value = false;
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } catch (e) {
      print(e);
    }
  }

  Future createVehicalGuest({
    required String numberPlate,
    required String routes,
    required String url,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print(bookingController.baseUrl);

        var responce = await AccountService().createVehicalGuest(
          numberPlate: numberPlate,
          token: SharedPref.getToken()!,
        );
        print(responce.data);

        if (responce.data['errorMessage'] == null) {
          if (!SharedPref.isGuestAccount()) {
            var newVehicle = Vehicle(
                id: responce.data['data']['id'],
                color: responce.data['data']['color'],
                isForeign: responce.data['data']['isForeign'],
                isDeleted: responce.data['data']['isDeleted'],
                name: responce.data['data']['name'],
                vRN: responce.data['data']['VRN'],
                customerId: responce.data['data']['customerId'],
                model: responce.data['data']['model'],
                fuelType: responce.data['data']['fuelType']);
            userController.selectedVehicle?.value = newVehicle;
            userController.vehicles!.value!.data!.add(newVehicle);

            userController.vehicles!.refresh();
            // userController.dropDownShowValue.value = responce.data['data']
            //         ['VRN'] +
            //     '-' +
            //     responce.data['data']['model'] +
            //     '(${responce.data['data']['color']})';
            // userController.dropDownValue.value = responce.data['data']['id'];
            print(userController.dropDownShowValue.value);
            // userController.dropDownValue.refresh();
            await userController.getVehicleData(
                url: bookingController.baseUrl.value);
            AppBackButton().getBack(routes: routes);
            // AppCustomToast.successToast(responce.data['message']);
          } else {
            userController.selectedVehicle?.value = Vehicle(
                color: responce.data['data']['color'],
                fuelType: responce.data['data']['fuelType'],
                vRN: responce.data['data']['VRN'],
                model: responce.data['data']['model']);
            Get.back();
            // AppCustomToast.successToast(responce.data['message']);
          }

          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        } else {
          AppCustomToast.warningToast(responce.data['errorMessage']);
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

    Future createVehical({
    required String numberPlate,
    required String routes,
    required String url,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print(url);

        var responce = await AccountService().createVehical(url: url,
          numberPlate: numberPlate,
          token: SharedPref.getToken()!,
        );
        print(responce.data);

        if (responce.data['errorMessage'] == null) {
          if (!SharedPref.isGuestAccount()) {
            var newVehicle = Vehicle(
                id: responce.data['data']['id'],
                color: responce.data['data']['color'],
                isForeign: responce.data['data']['isForeign'],
                isDeleted: responce.data['data']['isDeleted'],
                name: responce.data['data']['name'],
                vRN: responce.data['data']['VRN'],
                customerId: responce.data['data']['customerId'],
                model: responce.data['data']['model'],
                fuelType: responce.data['data']['fuelType']);
            userController.selectedVehicle?.value = newVehicle;
            userController.vehicles!.value!.data!.add(newVehicle);

            userController.vehicles!.refresh();
            // userController.dropDownShowValue.value = responce.data['data']
            //         ['VRN'] +
            //     '-' +
            //     responce.data['data']['model'] +
            //     '(${responce.data['data']['color']})';
            // userController.dropDownValue.value = responce.data['data']['id'];
            print(userController.dropDownShowValue.value);
            // userController.dropDownValue.refresh();
            await userController.getVehicleData(
                url: bookingController.baseUrl.value);
            AppBackButton().getBack(routes: routes);
            // AppCustomToast.successToast(responce.data['message']);
          } else {
            userController.selectedVehicle?.value = Vehicle(
                color: responce.data['data']['color'],
                fuelType: responce.data['data']['fuelType'],
                vRN: responce.data['data']['VRN'],
                model: responce.data['data']['model']);
            Get.back();
            // AppCustomToast.successToast(responce.data['message']);
          }

          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        } else {
          AppCustomToast.warningToast(responce.data['errorMessage']);
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

  Future createVehicleInGuest({
    required String numberPlate,
    required String routes,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print(numberPlate);

        var responce = await AccountService().createVehicalGuest(
          numberPlate: numberPlate,
          token: SharedPref.getToken()!,
        );
        print(responce.data);

        if (responce.data['errorMessage'] == null) {
          if (!SharedPref.isGuestAccount()) {
            var newVehicle = Vehicle(
                id: responce.data['data']['id'],
                color: responce.data['data']['color'],
                isForeign: responce.data['data']['isForeign'],
                isDeleted: responce.data['data']['isDeleted'],
                name: responce.data['data']['name'],
                vRN: responce.data['data']['VRN'],
                customerId: responce.data['data']['customerId'],
                model: responce.data['data']['model'],
                fuelType: responce.data['data']['fuelType']);
            userController.selectedVehicle?.value = newVehicle;
            userController.vehicles!.value!.data!.add(newVehicle);

            userController.vehicles!.refresh();
            // userController.dropDownShowValue.value = responce.data['data']
            //         ['VRN'] +
            //     '-' +
            //     responce.data['data']['model'] +
            //     '(${responce.data['data']['color']})';
            // userController.dropDownValue.value = responce.data['data']['id'];
            print(userController.dropDownShowValue.value);
            userController.dropDownValue.refresh();
            await userController.getVehicleData(
                url: SharedPref.getTimeZone() == 'Asia/Colombo'
                    ? Constant.slUrl
                    : Constant.ukUrl);
            AppBackButton().getBack(routes: routes);
            // AppCustomToast.successToast(responce.data['message']);
          } else {
            userController.selectedVehicle?.value = Vehicle(
                color: responce.data['data']['color'],
                fuelType: responce.data['data']['fuelType'],
                vRN: responce.data['data']['VRN'],
                model: responce.data['data']['model']);
            Get.back();
            //AppCustomToast.successToast(responce.data['message']);
          }

          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        } else if (responce.data['errorMessage'] ==
            'This vehicle is already added') {
          await userController.getVehicleData(
              url: SharedPref.getTimeZone() == 'Asia/Colombo'
                  ? Constant.slUrl
                  : Constant.ukUrl);
          userController.vehicles?.value?.data?.forEach((element) {
            if (element.vRN == numberPlate) {
              userController.selectedVehicle?.value = element;
            }
          });
          Get.back();
          AppCustomToast.warningToast(responce.data['errorMessage']);
          userController.isLoading.value = true;
          AppOverlay.hideOverlay();
        } else {
          AppCustomToast.warningToast(responce.data['errorMessage']);
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

  void getAllVehicle() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AuthService().getAllVehicle(
            token: SharedPref.getToken()!,
            url: SharedPref.getTimeZone() == 'Asia/Colombo'
                ? Constant.slUrl
                : Constant.ukUrl);
        if (responce.data['errorMessage'] == null) {
          print(responce.data['data']);
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void deleteVehicle(
      {required String token, required String id, required String url}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AccountService()
            .deteleVehical(token: token, id: id, url: url);
        if (responce.data['errorMessage'] == null) {
          AppOverlay.hideOverlay();
          AppCustomToast.successToast(responce.data['message']);
          userController.vehicles!.value!.data!
              .removeWhere((vehicle) => vehicle.id == id);
          userController.vehicles!.refresh();

          if (userController.vehicles!.value!.data!.isEmpty) {
            userController.dropDownValue.value = '';
            userController.dropDownValue.refresh();
          } else {
            userController.dropDownValue.value =
                userController.vehicles!.value!.data![0].vRN!;
          }
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

  Future createForeignVehicle(
      String numberPlate, String name, String model) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var responce = await AccountService().createForignVehical(
            numberPlate, SharedPref.getToken()!, name, model);
        print(responce.data);
        if (responce.data['errorMessage'] == null) {
          var newVehicle = Vehicle(
              id: responce.data['data']['id'],
              isForeign: responce.data['data']['isForeign'],
              isDeleted: responce.data['data']['isDeleted'],
              name: responce.data['data']['name'],
              vRN: responce.data['data']['VRN'],
              customerId: responce.data['data']['customerId'],
              model: responce.data['data']['model']);
          userController.vehicles!.value!.data!.add(newVehicle);

          userController.vehicles!.refresh();
          // AppCustomToast.successToast(responce.data['message']);
          AppOverlay.hideOverlay();
          userController.isLoading.value = false;
          Get.back();
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
        userController.isLoading.value = false;
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      userController.isLoading.value = false;
      print(e);
    }
  }

  void editVehicle(String id, String numberPlate) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print(id);
        print(numberPlate);
        var responce = await AccountService()
            .editVehical(SharedPref.getToken()!, id, numberPlate);
        print(responce.data);

        if (responce.data['errorMessage'] == null) {
          // AppCustomToast.successToast(responce.data['message']);
          AppOverlay.hideOverlay();
          userController.isLoading.value = true;

          for (int x = 0;
              x < userController.vehicles!.value!.data!.length;
              x++) {
            if (userController.vehicles!.value!.data![x].id == id) {
              userController.vehicles!.value!.data![x].vRN =
                  responce.data['data']['VRN'];
            }
          }
          userController.vehicles!.refresh();
          userController.dropDownValue.value =
              userController.vehicles!.value!.data![0].vRN!;

          Get.back();
          Get.back();
          Get.back();
        } else {
          AppCustomToast.errorToast(responce.data['errorMessage']);
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

  // Future saveCardDetailWithPayment(
  //     {required String paymentToken,
  //     required BuildContext context,
  //     required String parkingType,
  //     required String bookingType,
  //     required ParkingNowController controller}) async {
  //   try {
  //     if (networkController.connectionStatus.value != -1) {
  //       AppOverlay.startOverlay(context);
  //       var responce = await AccountService().saveCardDetail(
  //           paymentToken: paymentToken, token: SharedPref.getToken()!);
  //       AppOverlay.hideOverlay();

  //       print(responce.data);
  //       if (responce.statusCode == 200) {
  //         if (responce.data['errorMessage'] == null) {
  //           SharedPref().setCustomerVaultId(
  //               customerVaultId: responce.data['data']['customer_vault_id']);
  //           userController.getCardDetail();
  //           if (parkingType == "parkNow") {
  //             if (context.mounted) {
  //               // parkingController.draftBooking(
  //               //     ctrl: controller,
  //               //     context: context,
  //               //     parkingFromTime:
  //               //         controller.parkingFromTime!.millisecondsSinceEpoch,
  //               //     parkingUntilTime:
  //               //         controller.parkingUntilTime!.millisecondsSinceEpoch);
  //             }
  //           } else if (parkingType == 'parkLater') {
  //             if (bookingType == "Monthly") {
  //               // ignore: use_build_context_synchronously
  //               parkingLaterController.draftBookingMonthly(
  //                   parkingFromTime: parkingLaterController
  //                       .parkingFromTime!.millisecondsSinceEpoch,
  //                   parkingId: parkingLaterController.parkLaterLocationData.id!,
  //                   parkingUntilTime: parkingLaterController
  //                       .parkingUntilTime!.millisecondsSinceEpoch,
  //                   context: context);
  //             } else {
  //               print(parkingLaterController.parkLaterLocationData.id!);
  //               print(parkingLaterController.parkingFromTime);

  //               print(parkingLaterController.parkingUntilTime);

  //               // ignore: use_build_context_synchronously
  //               parkingLaterController.parkLaterDraftBooking(
  //                   parkingId: parkingLaterController.parkLaterLocationData.id!,
  //                   context: context,
  //                   parkingFromTime: parkingLaterController
  //                       .parkingFromTime!.millisecondsSinceEpoch,
  //                   parkingUntilTime: parkingLaterController
  //                       .parkingUntilTime!.millisecondsSinceEpoch);
  //             }
  //           }

  //           // AppCustomToast.successToast(responce.data['message']);
  //         } else {
  //           AppCustomToast.errorToast(responce.data['errorMessage']);
  //         }
  //       } else {
  //         AppCustomToast.errorToast(responce.data['errorMessage']);
  //       }
  //     } else {
  //       AppCustomToast.warningToast('Please check your internet connection');
  //       AppOverlay.hideOverlay();
  //     }
  //   } on DioError {
  //     AppOverlay.hideOverlay();
  //   }
  // }

  Future saveCardDetail(
      {required String paymentToken,
      required String url,
      required BuildContext context,
      required ParkingNowController controller}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var responce = await AccountService().saveCardDetail(url: url,
            paymentToken: paymentToken, token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();

        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            SharedPref().setCustomerVaultId(
                customerVaultId: responce.data['data']['customer_vault_id']);
            await userController.getCardDetail();
            Get.toNamed(Routes.PAYMENT_OPTION_SCREEN, arguments: ['', '', '']);
            // Get.back();
            // Get.back();

            // AppCustomToast.successToast(responce.data['message']);
          } else {
            userController.getCardDetail();
            Get.back();
            Get.back();
            // AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast(responce.data['errorMessage']);
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } on DioError {
      AppOverlay.hideOverlay();
    }
  }

  Future deleteCard({
    required String billingId,
    required BuildContext context,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var responce = await AccountService()
            .deleteCard(billingId: billingId, token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();

        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            userController.getCardDetail();
            Get.back();
            Get.back();

            AppCustomToast.successToast(responce.data['message']);
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast(responce.data['errorMessage']);
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } on DioError {
      AppOverlay.hideOverlay();
    }
  }

  Future deleteUser({
    required BuildContext context,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var responce =
            await AuthService().deleteUser(token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();

        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
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
              // ignore: use_build_context_synchronously
              AuthController().guestUserLogin(context);
            }
            Get.offAll(DashboardNavigation());
            userBox.write(Constant.guest, true);
            Get.back();
            Get.back();

            AppCustomToast.successToast(responce.data['message']);
          } else {
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast(responce.data['errorMessage']);
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } on DioError {
      AppOverlay.hideOverlay();
    }
  }

  void sendMessagetoMail({
    required String message,
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var responce = await AccountService().sendMessagetoMail(
            email: email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            message: message,
            token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();

        print(responce.data);
        if (responce.statusCode == 200) {
          // AppCustomToast.successToast(responce.data['message']);
        } else {
          AppCustomToast.errorToast(responce.data['errorMessage']);
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
        AppOverlay.hideOverlay();
      }
    } on DioError {
      AppOverlay.hideOverlay();
    }
  }
}
