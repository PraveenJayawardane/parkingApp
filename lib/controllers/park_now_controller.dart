import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/Bookingdetail.dart';
import 'package:parkfinda_mobile/model/fixed_duration_booking.dart';
import 'package:parkfinda_mobile/model/Parking.dart';
import 'package:parkfinda_mobile/model/parkingfee.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/parking_service.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../constants/routes.dart';
import '../model/dont_know_parking_result.dart';
import '../screens/parking/park_now/park_now_dont_Know_parking_register_booked_details_screen.dart';
import '../services/remote/auth_service.dart';
import '../utils/app_bottom_sheets.dart';
import '../utils/app_custom_toast.dart';
import 'package:intl/intl.dart';

import 'navigation_controllers/bottom_navigation_controller.dart';

class ParkingNowController extends GetxController {
  var networkController = Get.find<NetworkController>();
  var userController = Get.find<UserController>();
  var bookingController = Get.find<BookingController>();

  var isFixedDuration = true;
  int? fixedHours;
  var showHowLongParking = "".obs;
  var showParkingFrom =
      "Today at ${DateFormat('HH:mm').format(DateTime.now())}".obs;
  var showParkingUntil =
      "Today at ${DateFormat('HH:mm').format(DateTime.now().add(const Duration(minutes: 15)))}"
          .obs;
  var showTotalDuration = "".obs;
  DateTime? parkingFromTime;
  DateTime? parkingUntilTime;
  String? customTime;
  var parkingFee = ParkingFee().obs;
  var parkingDetails = Parking().obs;
  var isPinCompleted = false.obs;
  var isIDontKnowParkingTime = false.obs;
  var activeSMSReminder = false.obs;
  var activeSMSReceipt = false.obs;
  var bookingId = ''.obs;
  var iDontKnowParkingId = ''.obs;
  var dontKnowParkingDetails = FixedDurationbooking();
  var dontKnowParkingResult = DontKnowParkingResult();
  var rateState = false.obs;
  var extendBoookingParkingCharge = ''.obs;
  var extendBoookingServiceFee = ''.obs;
  var extendBoookingTotal = ''.obs;
  String? extendBookingId;
  var isAvalabilityOfTimeSlot = false.obs;
  var isAvalabilityOfTimeSlotParkAgain = false.obs;
  var bookAgainParkingDetail = BookingDetail().obs;
  var bookAgainLoading = false.obs;
  var noSearchResultFound = false.obs;
  String? bookAgainId;
  var parkNowBookingUsingPayHere = FixedDurationbooking();

  //Time up Counter
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  @override
  void onInit() {
    super.onInit();

    _stopWatchTimer.minuteTime.listen((value) {
      //print('minuteTime $value');
    });
    _stopWatchTimer.secondTime.listen((value) {
      //print('secondTime $value');
    });
    _stopWatchTimer.records.listen((value) {
      //print('records $value');
    });
    _stopWatchTimer.fetchStopped.listen((value) {
      //print('stopped from stream');
    });
    _stopWatchTimer.fetchEnded.listen((value) {
      //print('ended from stream');
    });

    /// Can be set preset time. This case is "00:01.23".
    DateTime startedTime = DateTime.now().add(const Duration(minutes: 20));
    DateTime currentTime = DateTime.now();
    Duration diff = startedTime.difference(currentTime);

    _stopWatchTimer.setPresetTime(mSec: diff.inMilliseconds);
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
      return 'Tomorrow';
    } else {
      return "";
    }
  }

  String? getDuration(int miliSeconds) {
    var minutes = Duration(milliseconds: miliSeconds.abs()).inMinutes;

    if ((minutes / 60) >= 1) {
      var hours = minutes ~/ 60;
      var minute = minutes % 60;

      if (minute == 0) {
        return " $hours Hour(s)";
      } else {
        return " $hours Hour(s) $minute Minute(s)";
      }
    } else {
      return ' $minutes Minute(s)';
    }
  }

  Future<void> setParkNow(
      {required String token,
      required String id,
      required BuildContext context,
      required ParkingNowController contrl}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        noSearchResultFound.value = false;
        var responce = await AuthService().getCarparkPin(token, id);
        print(responce.data);

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            bookingController.baseUrl.value = responce.data['data']['baseURL'];
            print('Url');
            print(bookingController.baseUrl);
            SharedPref.setCurerentParkCurrency(
                responce.data['data']['currency']);
            await userController.getVehicleData(
                url: bookingController.baseUrl.value);
            await userController.getSingleRegionCardDetail(
                url: bookingController.baseUrl.value);
            AppOverlay.hideOverlay();
            // ignore: use_build_context_synchronously
            FocusScope.of(context).unfocus();
            contrl.isPinCompleted.value = true;

            contrl.parkingDetails.value =
                Parking.fromJson(responce.data['data']);

            print(parkingDetails.value.id);
            contrl.parkingDetails.refresh();
          } else {
            contrl.isPinCompleted.value = false;
            AppOverlay.hideOverlay();
            if (responce.data['errorMessage'] == 'Car park not found') {
              contrl.noSearchResultFound.value = true;
            }
            // AppCustomToast.errorToast(responce.data['errorMessage']);
          }
        } else {
          contrl.isPinCompleted.value = false;
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast('Something went wrong');
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      contrl.isPinCompleted.value = false;
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> calculateBill(String? id,
      {required ParkingNowController ctrl,
      required BuildContext context,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        ctrl.isAvalabilityOfTimeSlot.value = false;
        bookAgainId = id;
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: id ?? ctrl.parkingDetails.value.id!,
          parkingType: 'parkNow',
          vehicleId: userController.selectedVehicle?.value?.id == ''
              ? null
              : userController.selectedVehicle?.value?.id,
        );
        id = null;
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            ctrl.parkingFee.value = ParkingFee.fromJson(responce.data);
            ctrl.parkingFee.refresh();
            ctrl.isAvalabilityOfTimeSlot.value = true;
            print(ctrl.parkingFee.value.data?.price?.serviceFee);
          } else {
            print(responce.data);
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

  Future<void> parkAgainCalculateBill(
      {required ParkingNowController ctrl,
      required BuildContext context,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      AppOverlay.startOverlay(context);
      print(ctrl.bookAgainParkingDetail.value.carPark?[0].sId);
      if (networkController.connectionStatus.value != -1) {
        ctrl.bookAgainLoading.value = true;
        ctrl.isAvalabilityOfTimeSlotParkAgain.value = false;
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: ctrl.bookAgainParkingDetail.value.carPark![0].sId!,
          parkingType: 'parkNow',
          vehicleId: userController.dropDownValue.value,
        );
        ctrl.bookAgainLoading.value = false;
        AppOverlay.hideOverlay();
        print(SharedPref.getId());
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            ctrl.parkingFee.value = ParkingFee.fromJson(responce.data);
            ctrl.parkingFee.refresh();
            ctrl.isAvalabilityOfTimeSlotParkAgain.value = true;
            print(ctrl.parkingFee.value.data?.price?.serviceFee);
          } else {
            // print(responce.data);
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
      ctrl.bookAgainLoading.value = false;
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> getSmsReciptFee(
      {required ParkingNowController ctrl,
      required BuildContext context,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: ctrl.parkingDetails.value.id!,
          parkingType: 'parkNow',
          vehicleId: userController.dropDownValue.value,
        );
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            ctrl.parkingFee.value = ParkingFee.fromJson(responce.data);
            ctrl.parkingFee.refresh();
            print(ctrl.parkingFee.value.data?.price?.serviceFee);
          } else {
            // print(responce.data);
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

  Future<void> getsmsReminderFee({
    required ParkingNowController ctrl,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
    required bool smsFee,
    required bool smsReminderFee,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: ctrl.parkingDetails.value.id!,
          parkingType: 'parkNow',
          vehicleId: userController.dropDownValue.value,
        );
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print(responce.data);
            ctrl.parkingFee.value = ParkingFee.fromJson(responce.data);
            ctrl.parkingFee.refresh();
            print(ctrl.parkingFee.value.data?.price?.serviceFee);
          } else {
            // print(responce.data);
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

  Future<void> draftBooking({
    required ParkingNowController ctrl,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
    //required String bookingId,
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
            carParkId: ctrl.parkingDetails.value.id ?? bookAgainId!,
            parkingType: 'parkNow',
            smsFee: false,
            smsReminderFee: false,
            vehicleId: userController.selectedVehicle!.value!.id!);
        print('Draft data------------>');
        print(responce.data);

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            //get bookingId
            bookingId.value = responce.data['data']['id'];

            // ignore: use_build_context_synchronously
            bookingController.parkNowBookingUsingVolet(
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
                parkingType: "parkNow",
                bookingId: bookingId.value);
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

  Future<void> payHereDraftBooking({
    required ParkingNowController ctrl,
    required BuildContext context,
    required int parkingFromTime,
    required int parkingUntilTime,
    //required String bookingId,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBooking(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: ctrl.parkingDetails.value.id ?? bookAgainId!,
            parkingType: 'parkNow',
            smsFee: false,
            smsReminderFee: false,
            vehicleId: userController.selectedVehicle!.value!.id!);
        // AppOverlay.hideOverlay();
        print('Draft data------------>');
        print(responce.data);

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            //get bookingId
            bookingId.value = responce.data['data']['id'];
            print(bookingId.value);
            // ignore: use_build_context_synchronously
            validateBooking(context: context, bookingId: bookingId.value);
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

  Future<void> parkAgainDraftBooking(
      {required ParkingNowController ctrl,
      required BuildContext context,
      required int parkingFromTime,
      required String? currency,
      required int parkingUntilTime}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().draftBooking(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            bookingEnd: parkingUntilTime,
            carParkId: ctrl.bookAgainParkingDetail.value.carParkId!,
            parkingType: 'parkNow',
            smsFee: false,
            smsReminderFee: false,
            vehicleId: userController.selectedVehicle!.value!.id!);

        if (responce.statusCode == 200) {
          print(responce.data['data']);
          if (responce.data['errorMessage'] == null) {
            //get bookingId
            bookingId.value = responce.data['data']['id'];
            if (currency == 'LKR') {
              // ignore: use_build_context_synchronously
              bookingController.makeFixedDurationBooking(
                  billingId: userController.selectedCard.value!.id!,
                  cardType: 'payhere',
                  cavv: null,
                  directoryServerId: null,
                  eci: null,
                  firstName: null,
                  lastName: null,
                  paymentToken: null,
                  threeDsVersion: null,
                  context: context,
                  parkingType: "parkNow",
                  bookingId: bookingId.value);
            } else {
              // ignore: use_build_context_synchronously
              bookingController.makeFixedDurationBooking(
                  billingId: userController.selectedCard.value!.id!,
                  cardType: 'existing',
                  cavv: null,
                  directoryServerId: null,
                  eci: null,
                  firstName: null,
                  lastName: null,
                  paymentToken: null,
                  threeDsVersion: null,
                  context: context,
                  parkingType: "parkNow",
                  bookingId: bookingId.value);
            }
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

  Future<void> checkIdontKnowParkingBooking({
    required ParkingNowController ctrl,
    required BuildContext context,
    required int parkingFromTime,
  }) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().checkIdontKnowParkingBooking(
            token: SharedPref.getToken()!,
            bookingStart: parkingFromTime,
            carParkId: ctrl.parkingDetails.value.id!,
            parkingType: 'dontKnowParking',
            vehicleId: userController.dropDownValue.value);
        AppOverlay.hideOverlay();

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            //do task
            print('IdontKnowParkingPaymentScreen');
            print(responce.data);
            // ignore: use_build_context_synchronously
            draftIDontKnowParkingBooking(
                bookingDraft: DateTime.now().millisecondsSinceEpoch,
                bookingStart: DateTime.now().millisecondsSinceEpoch,
                carParkId: ctrl.parkingDetails.value.id!,
                context: context,
                parkingType: 'dontKnowParking',
                vehicleId: userController.dropDownValue.value);
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

  Future<void> draftIDontKnowParkingBooking({
    required BuildContext context,
    required String parkingType,
    required int bookingDraft,
    required int bookingStart,
    required String carParkId,
    required String vehicleId,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().draftIDontKnowParkingBooking(
            bookingDraft: bookingDraft,
            bookingModule: 'mobile',
            bookingStart: bookingStart,
            carParkId: carParkId,
            vehicleId: vehicleId,
            parkingType: parkingType,
            token: SharedPref.getToken()!);
        print(bookingDraft);
        print(bookingStart);
        print(carParkId);
        print(vehicleId);
        print(parkingType);

        print('draft');
        print(response.data);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            //do task
            //parknow

            iDontKnowParkingId.value = response.data['data']['id'];
            print('draftIDontKnowParkingBooking id');
            print(iDontKnowParkingId);

            Get.toNamed(Routes.DONT_KNOW_PARKING_PAYMENT_SCREEN);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> confirmIDontKnowParkingBooking({
    required BuildContext context,
    required String parkingType,
    required String bookingId,
    required String ccnumber,
    required String ccexp,
    required String cvv,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().confirmIDontKnowParkingBooking(
            bookingId: bookingId,
            parkingType: parkingType,
            ccnumber: ccnumber,
            ccexp: ccexp,
            cvv: cvv,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            print('confirmIDontKnowParkingBooking');
            //do task
            dontKnowParkingDetails =
                FixedDurationbooking.fromJson(response.data['data']);
            Get.to(ParkNowDontKnowParkingRegisterBookedDetailsScreen(
                    dontknowparkingbooking: dontKnowParkingDetails)
                // Routes.PARK_NOWPARKING_REGISTRATION_BOOKED_DETAILS_SCREEN,
                // arguments: dontKnowParkingDetails
                // 6417f8974f8e5158b5e8b1e5
                );

            // Get.offUntil(
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             ParkNowDontKnowParkingRegisterBookedDetailsScreen(
            //               dontknowparkingbooking: dontKnowParkingDetails,
            //             )), (route) {
            //   var currentRoute = route.settings.name;
            //   if (currentRoute == Routes.DIRECT_DASHBOARD) {
            //     return true;
            //   } else if (currentRoute == Routes.DASHBOARD) {
            //     return true;
            //   } else {
            //     return false;
            //   }
            // });
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }
  //dontKnowParkingstop

  Future<void> dontKnowParkingstop({
    required BuildContext context,
    required int bookingEnd,
    required String bookingId,
  }) async {
    print('booking id ----------------> ');
    print(bookingId);
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().dontKnowParkingstop(
            bookingId: bookingId,
            bookingEnd: bookingEnd,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            //do task
            AppCustomToast.errorToast(response.data['message']);
            bookingController.getAllBooking();
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            // dontKnowParkingResult =
            //     DontKnowParkingResult.fromJson(response.data['data']);
            // print(dontKnowParkingResult.booking?.accountId);

            // Get.toNamed(Routes.PARKING_SUMMERY_SCREEN,
            //     arguments: dontKnowParkingResult);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> extendBookingChecking(
      {required BuildContext context,
      required String id,
      required ParkingNowController controller,
      required int bookingEnd}) async {
    print('booking id ----------------> ');
    print(id);
    print(bookingEnd);
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().extendBookingChecking(
            id: id, token: SharedPref.getToken()!, bookingEnd: bookingEnd);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            //do task
            controller.extendBoookingParkingCharge.value =
                response.data['data']['parkingCharges'].toString();
            controller.extendBoookingServiceFee.value =
                response.data['data']['serviceFee'].toString();
            controller.extendBoookingTotal.value =
                response.data['data']['total'].toString();
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> draftExtendBooking(
      {required BuildContext context,
      required String id,
      required String cardType,
      required int bookingEnd}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().draftExtendBooking(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            id: id,
            token: SharedPref.getToken()!,
            bookingEnd: bookingEnd);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            extendBookingId = response.data['data']['id'];

            //  Get.to(ExtendBookingPaymentScreen(bookingId: extendBookingId));
            // ignore: use_build_context_synchronously
            extendBookingPayment(
                cardType: cardType == 'LKR' ? 'payhere' : 'existing',
                bookingId: extendBookingId!,
                context: context,
                vaultId: userController.selectedCard.value!.id!);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> extendBookigWithoutPaymentGateway(
      {required BuildContext context,
      required String id,
      required int bookingEnd}) async {
    print('booking id ----------------> ');
    print(id);
    print(bookingEnd);
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().extendBookigWithoutPaymentGateway(
            bookingDraft: DateTime.now().millisecondsSinceEpoch,
            id: id,
            token: SharedPref.getToken()!,
            bookingEnd: bookingEnd);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            bookingController.getAllBooking();
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            Get.toNamed(Routes.DIRECT_DASHBOARD);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> confirmExtendBooking({
    required BuildContext context,
    required String id,
    required String ccNumber,
    required String ccExp,
    required String cvv,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().confirmExtendBooking(
            bookingId: id,
            ccexp: ccExp,
            ccnumber: ccNumber,
            cvv: cvv,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          print(id);
          if (response.data['errorMessage'] == null) {
            //AppCustomToast.successToast(response.data['message']);
            Get.to(Routes.DIRECT_DASHBOARD);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      AppOverlay.hideOverlay();
      print(e);
    }
  }

  Future<void> extendBookingPayment({
    required BuildContext context,
    required String bookingId,
    required String vaultId,
    required String cardType,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await ParkingService().extendBookingPayment(
            cardType: cardType,
            bookingId: bookingId,
            billingId: vaultId,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);

          if (response.data['errorMessage'] == null) {
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            AppCustomToast.successToast(response.data['message']);
            bookingController.getAllBooking();
            //Get.back();
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
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
        print('Id');
        print(bookingId);
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            parkNowBookingUsingPayHere =
                FixedDurationbooking.fromJson(responce.data['data']['data']);
            print(parkNowBookingUsingPayHere.vehicle?.vRN);
            // ignore: use_build_context_synchronously
            AppBottomSheet().payHerePayment(
                amount: parkNowBookingUsingPayHere.booking!.totalFee!,
                id: parkNowBookingUsingPayHere.booking!.id!,
                booking: parkNowBookingUsingPayHere,
                context: context);

            //  payHereHashCode(context: context, bookingId: bookingId);
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
        AppOverlay.hideOverlay();
        print(responce.data);
        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            print('Payment');
            print(parkNowBookingUsingPayHere);
            // ignore: use_build_context_synchronously
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
}
