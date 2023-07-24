import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/CustomerReviews.dart';
import 'package:parkfinda_mobile/model/recent_search.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/parking_service.dart';

import 'package:parkfinda_mobile/utils/app_custom_toast.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import '../constants/routes.dart';
import '../model/ParkLaterSingleParkDetails.dart';
import '../model/fixed_duration_booking.dart';
import '../model/park_later_locations.dart';
import '../model/parkingfee.dart';
import '../services/remote/auth_service.dart';
import '../utils/app_bottom_sheets.dart';

class ParkingLaterController extends GetxController {
  NetworkController networkController = Get.find<NetworkController>();
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();
  var showParkingFrom = "".obs;
  var showParkingUntil = "".obs;
  var showHowLongParking = "".obs;
  var showTotalDuration = "".obs;
  var parkLaterPriceLoading = false.obs;
  var draftBookingId = ''.obs;

  DateTime? parkingFromTime;
  DateTime? parkingUntilTime;
  DateTime? parkingFromDay;
  DateTime? parkingFromDayName;
  DateTime? parkingUntilDay;
  DateTime? parkingUntilDayName;

  ParkingFee parkingFee = ParkingFee();
  var parkLaterLocations = ParkLaterLocations();
  var parkLaterLocationsInMonthly = ParkLaterLocations();
  ParkLaterSingleParkDetails parkLaterSingleCarParkDetails =
      ParkLaterSingleParkDetails();
  CustomerReviews? customerReviews = CustomerReviews();
  ParkLaterLocationData parkLaterLocationData = ParkLaterLocationData();
  var parkLaterBookingUsingPayHere = FixedDurationbooking();

  var isCarParkLoading = false.obs;
  var isPriceCalculation = false.obs;

  Future<void> calculateBill(
      {required String parkingId,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        parkLaterPriceLoading.value = true;
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: parkingId,
          parkingType: 'parkLater',
          vehicleId: userController.selectedVehicle!.value!.id,
        );
        parkLaterPriceLoading.value = false;
        AppOverlay.hideOverlay();
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            parkingFee = ParkingFee.fromJson(responce.data);
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> calculateMonthlyBill(
      {required String parkingId,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        parkLaterPriceLoading.value = true;
        var responce = await ParkingService().calculateMonthlyBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: parkingId,
          parkingType: 'parkLater',
          vehicleId: userController.selectedVehicle!.value!.id,
        );
        parkLaterPriceLoading.value = false;
        AppOverlay.hideOverlay();
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            parkingFee = ParkingFee.fromJson(responce.data);
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError {
      AppOverlay.hideOverlay();
    }
  }

  Future<void> parkLaterDraftBooking({
    required String parkingId,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
    required String? billingId,
    required String? paymentToken,
    required String? cavv,
    required String? eci,
    required String? directoryServerId,
    required String? threeDsVersion,
    required String? cardType,
    required String? firstName,
    required String? lastName,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBooking(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: parkingId,
            parkingType: 'parkLater',
            smsFee: false,
            smsReminderFee: false,
            vehicleId: userController.selectedVehicle!.value!.id!);
        // AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            //get bookingId
            draftBookingId.value = responce.data['data']['id'];
            // ignore: use_build_context_synchronously
            bookingController.makeParkLaterBooking(
                billingId: billingId,
                cardType: cardType,
                cavv: cavv,
                directoryServerId: directoryServerId,
                eci: eci,
                firstName: firstName,
                lastName: lastName,
                paymentToken: paymentToken,
                threeDsVersion: threeDsVersion,
                context: context,
                parkingType: "parkLater",
                bookingId: draftBookingId.value);
            // Get.to(() => ParkLaterPaymentScreen());

            print(draftBookingId);
          } else {
            print(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> validateBooking({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      // AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().validateBooking(
          token: SharedPref.getToken()!,
          bookingId: bookingId,
        );
        //AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            // ignore: use_build_context_synchronously
            bookingController.parkLaterBooking =
                FixedDurationbooking.fromJson(responce.data['data']['data']);
            // ignore: use_build_context_synchronously
            AppBottomSheet().payHerePayment(
                amount: bookingController.parkLaterBooking.booking!.totalFee!,
                id: bookingController.parkLaterBooking.booking!.id!,
                booking: bookingController.parkLaterBooking,
                context: context);
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> payHereHashCode({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      // AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().payHereHashCode(
          token: SharedPref.getToken()!,
          bookingId: bookingId,
        );

        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            AppOverlay.hideOverlay();
            parkLaterBookingUsingPayHere =
                FixedDurationbooking.fromJson(responce.data['data']['data']);
            // ignore: use_build_context_synchronously
            AppBottomSheet().payHerePayment(
              amount: parkLaterBookingUsingPayHere.booking!.totalFee!,
              id: parkLaterBookingUsingPayHere.booking!.id!,
              booking: parkLaterBookingUsingPayHere,
              context: context,
            );
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> payHereHourleyParkLaterDraftBooking({
    required String parkingId,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBooking(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: parkingId,
            parkingType: 'parkLater',
            smsFee: false,
            smsReminderFee: false,
            vehicleId: userController.selectedVehicle!.value!.id!);
        // AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            //get bookingId
            draftBookingId.value = responce.data['data']['id'];
            // ignore: use_build_context_synchronously
            validateBooking(context: context, bookingId: draftBookingId.value);
            // ignore: use_build_context_synchronously
            // bookingController.makeParkLaterBooking(
            //     billingId: billingId,
            //     cardType: cardType,
            //     cavv: cavv,
            //     directoryServerId: directoryServerId,
            //     eci: eci,
            //     firstName: firstName,
            //     lastName: lastName,
            //     paymentToken: paymentToken,
            //     threeDsVersion: threeDsVersion,
            //     context: context,
            //     parkingType: "parkLater",
            //     bookingId: draftBookingId.value);

            print(draftBookingId);
          } else {
            print(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> draftBookingMonthly({
    required String parkingId,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
    required String? billingId,
    required String? paymentToken,
    required String? cavv,
    required String? eci,
    required String? directoryServerId,
    required String? threeDsVersion,
    required String? cardType,
    required String? firstName,
    required String? lastName,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBookingMonthly(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: parkingId,
            parkingType: 'monthly',
            bookingModule: 'mobile',
            vehicleId: userController.selectedVehicle!.value!.id!);
        // AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            //get bookingId
            draftBookingId.value = responce.data['data']['id'];
            // ignore: use_build_context_synchronously
            bookingController.makeMonthlyBooking(
                billingId: billingId,
                cardType: cardType,
                cavv: cavv,
                directoryServerId: directoryServerId,
                eci: eci,
                firstName: firstName,
                lastName: lastName,
                paymentToken: paymentToken,
                threeDsVersion: threeDsVersion,
                context: context,
                parkingType: "monthly",
                bookingId: draftBookingId.value);
            // Get.to(() => ParkLaterPaymentScreen());

            print(draftBookingId);
          } else {
            print(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> payHereDraftBookingMonthly({
    required String parkingId,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBookingMonthly(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: parkingId,
            parkingType: 'monthly',
            bookingModule: 'mobile',
            vehicleId: userController.selectedVehicle!.value!.id!);
        // AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            //get bookingId
            draftBookingId.value = responce.data['data']['id'];
            // ignore: use_build_context_synchronously
            validateBooking(context: context, bookingId: draftBookingId.value);
            // ignore: use_build_context_synchronously
            // bookingController.makeMonthlyBooking(
            //     billingId: billingId,
            //     cardType: cardType,
            //     cavv: cavv,
            //     directoryServerId: directoryServerId,
            //     eci: eci,
            //     firstName: firstName,
            //     lastName: lastName,
            //     paymentToken: paymentToken,
            //     threeDsVersion: threeDsVersion,
            //     context: context,
            //     parkingType: "monthly",
            //     bookingId: draftBookingId.value);

            print(draftBookingId);
          } else {
            print(responce.data['errorMessage']);
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
          //print(responce.data);
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future getAllCarPark(
      {required BuildContext context,
      required double lat,
      required double lng,
      required int startTime,
      required int endTime,
      required String address}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print('----------------base url ${bookingController.baseUrl}');
        AppOverlay.startOverlay(context);
        var response = await ParkingService().getAllCarpark(
            startTime: startTime,
            latitude: lat,
            endTime: endTime,
            longitude: lng,
            token: SharedPref.getToken()!);

        print("-------------->parklater");
        print(response.data);
        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            //bookingController.baseUrl = response.data['data']['baseURL'];
            print(response.data['data']['baseURL']);
            await userController.getSingleRegionCardDetail(
                url: bookingController.baseUrl.value);
            await userController.getVehicleData(
                url: bookingController.baseUrl.value);
            AppOverlay.hideOverlay();
            Get.toNamed(Routes.SEARCH_RESULT_MAP_SCREEN,
                arguments: [lat, lng, address]);
            parkLaterLocations = ParkLaterLocations.fromJson(response.data);
            // ignore: prefer_is_empty
            if (parkLaterLocations.parkLaterLocation?.all == []) {
              AppCustomToast.errorToast(
                  'Sorry there is no parking spaces available in this selected location.');
            }
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future setRecentSearch(
      {required BuildContext context,
      required String carparkId,
      required String url}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var response = await AuthService().setRecentSearch(
            url: url, carparkId: carparkId, token: SharedPref.getToken()!);

        print(response.data);
        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            print('----------------------->search');
            print(response.data);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<List<RecentSearch>> getRecentSearch() async {
    try {
      var response =
          await AuthService().getRecentSearch(token: SharedPref.getToken()!);

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data['errorMessage'] == null) {
          List data = response.data['data'];

          List<RecentSearch> recentSearch = data.map((e) {
            return RecentSearch.fromJson(e);
          }).toList();

          return recentSearch;
        } else {
          throw Exception(response.data['errorMessage']);
        }
      } else {
        throw Exception('Invalid Response');
      }
    } on DioError catch (e) {
      throw Exception(e);
    }
  }

  void getParkLaterSingleLocationsDetails({
    required String parkingId,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print('vehicle id');
        print(userController.selectedVehicle?.value?.id);
        isCarParkLoading.value = true;
        var response = await ParkingService()
            //TODO
            .getParkLaterSingleLocationsDetails(
                // ignore: unnecessary_null_in_if_null_operators
                vehicalId: SharedPref.isGuestAccount()
                    ? null
                    : userController.selectedVehicle?.value?.id,
                token: SharedPref.getToken()!,
                carParkId: parkingId,
                parkingFrom: "${parkingFromTime?.millisecondsSinceEpoch}",
                parkingUntil: "${parkingUntilTime?.millisecondsSinceEpoch}");
        isCarParkLoading.value = false;
        print('---------> late data');

        print(parkingFromTime?.millisecondsSinceEpoch);
        print(parkingId);
        print(parkingUntilTime?.millisecondsSinceEpoch);
        var parkingFeeResponse = response[0];
        var carParkDetailResponse = response[1];
        var reviewResponse = response[2];

        if (parkingFeeResponse.statusCode == 200) {
          if (parkingFeeResponse.data['errorMessage'] == null) {
            isPriceCalculation.value = true;
            parkingFee = ParkingFee.fromJson(parkingFeeResponse.data);
            print("------------> fee data");
            print(parkingFeeResponse.data);
          } else {
            // print("------------> fee data");
            AppCustomToast.errorToast(parkingFeeResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }

        if (carParkDetailResponse.statusCode == 200) {
          if (carParkDetailResponse.data['errorMessage'] == null) {
            parkLaterSingleCarParkDetails = ParkLaterSingleParkDetails.fromJson(
                carParkDetailResponse.data["data"]);
            print("------------> parkDetails data");
            print(carParkDetailResponse.data);
          } else {
            AppCustomToast.errorToast(
                carParkDetailResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }

        if (reviewResponse.statusCode == 200) {
          if (reviewResponse.data['errorMessage'] == null) {
            print("------------> review data");
            print(reviewResponse.data);
            customerReviews = CustomerReviews.fromJson(reviewResponse.data);
          } else {
            customerReviews = null;
            //AppCustomToast.buildToast(reviewResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void getParkLaterMonthleyLocationsDetails({
    required String parkingId,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        print('vehicle id');
        print(userController.selectedVehicle?.value?.id);
        isCarParkLoading.value = true;
        var response = await ParkingService()
            .getParkLaterMonthleyLocationsDetails(
                // ignore: unnecessary_null_in_if_null_operators
                vehicalId: SharedPref.isGuestAccount()
                    ? null
                    : userController.selectedVehicle?.value?.id,
                token: SharedPref.getToken()!,
                carParkId: parkingId,
                parkingFrom:
                    "${parkingFromTime?.add(const Duration(minutes: 1)).millisecondsSinceEpoch}",
                parkingUntil: "${parkingUntilTime?.millisecondsSinceEpoch}");
        isCarParkLoading.value = false;
        print('---------> late data');

        var parkingFeeResponse = response[0];
        var carParkDetailResponse = response[1];
        var reviewResponse = response[2];

        if (parkingFeeResponse.statusCode == 200) {
          if (parkingFeeResponse.data['errorMessage'] == null) {
            isPriceCalculation.value = true;
            print(parkingFeeResponse.data);
            parkingFee = ParkingFee.fromJson(parkingFeeResponse.data);
            print("------------> fee data");
            print(parkingFeeResponse.data);
          } else {
            // print("------------> fee data");
            AppCustomToast.errorToast(parkingFeeResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }

        if (carParkDetailResponse.statusCode == 200) {
          if (carParkDetailResponse.data['errorMessage'] == null) {
            parkLaterSingleCarParkDetails = ParkLaterSingleParkDetails.fromJson(
                carParkDetailResponse.data["data"]);
            print("------------> parkDetails data");
            print(carParkDetailResponse.data);
          } else {
            AppCustomToast.errorToast(
                carParkDetailResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }

        if (reviewResponse.statusCode == 200) {
          if (reviewResponse.data['errorMessage'] == null) {
            print("------------> review data");
            print(reviewResponse.data);
            customerReviews = CustomerReviews.fromJson(reviewResponse.data);
          } else {
            customerReviews = null;
            //AppCustomToast.buildToast(reviewResponse.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  String getMonth(int monthNo) {
    String pickedMon = "";
    var months = {
      1: "Jan",
      2: "Feb",
      3: "Mar",
      4: "Apr",
      5: "May",
      6: "Jun",
      7: "Jul",
      8: "Agu",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec",
    };

    months.forEach((key, value) {
      if (key == monthNo) {
        pickedMon = value;
      }
    });

    return pickedMon;
  }

  String? getFormattedDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final parkingDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final parkingDayName = DateTime(dateTime.month, dateTime.day);
    if (parkingDay == today) {
      return 'Today';
    } else if (parkingDay == tomorrow) {
      return '';
    } else {
      return "";
    }
  }

  Future getAllCarparksForMonthlyBooking({
    required BuildContext context,
    required double lat,
    required double lng,
    required int bookingEnd,
    required int bookingStart,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().getAllCarparksForMonthlyBooking(
            bookingEnd: bookingEnd,
            bookingStart: bookingStart,
            latitude: lat,
            longtiude: lng,
            token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();
        print("-------------->parklater");
        print(response.data);
        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            parkLaterLocationsInMonthly =
                ParkLaterLocations.fromJson(response.data);
            print('location result');
            print(
                parkLaterLocationsInMonthly.parkLaterLocation?.all?.first.city);
            // ignore: prefer_is_empty
            if (parkLaterLocationsInMonthly.parkLaterLocation?.all == []) {
              print('object');
              AppCustomToast.errorToast(
                  'Sorry there is no parking spaces available in this selected location.');
            }
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future changeVrn({
    required BuildContext context,
    required String vehicleId,
    required String bookingId,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().changeVrn(
            vehicleId: vehicleId,
            bookingId: bookingId,
            token: SharedPref.getToken()!);
        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            print(response.data);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast('Invalid Response');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }
}
