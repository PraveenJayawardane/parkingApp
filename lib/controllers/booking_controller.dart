import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkfinda_mobile/constants/routes.dart';
import 'package:parkfinda_mobile/controllers/navigation_controllers/bottom_navigation_controller.dart';
import 'package:parkfinda_mobile/controllers/network_controller.dart';
import 'package:parkfinda_mobile/controllers/park_now_controller.dart';
import 'package:parkfinda_mobile/controllers/user_controller.dart';
import 'package:parkfinda_mobile/model/CustomerReviews.dart';
import 'package:parkfinda_mobile/model/booking.dart' as bk;
import 'package:parkfinda_mobile/model/notification.dart' as notify;
import 'package:parkfinda_mobile/model/park_again.dart';
import 'package:parkfinda_mobile/services/local/shared_pref.dart';
import 'package:parkfinda_mobile/services/remote/booking_service.dart';
import 'package:parkfinda_mobile/utils/app_overlay.dart';
import '../model/Bookingdetail.dart';

import '../model/amend_bookig_fee.dart';
import '../model/extend_booking_calculation.dart';
import '../model/fixed_duration_booking.dart';
import '../model/parkingfee.dart';
import '../screens/parking/park_later/park_later_booked_details_screen.dart';
import '../screens/parking/park_now/park_now_fixed_duration_booked_details_screen.dart';
import '../services/remote/auth_service.dart';
import '../services/remote/parking_service.dart';
import '../utils/app_custom_toast.dart';

class BookingController extends GetxController {
  NetworkController networkController = Get.find<NetworkController>();
  var userController = Get.find<UserController>();

  var booking = RxList<BookingDetail>();
  var activeBooking = RxList<BookingDetail>();
  var upcomingBooking = RxList<BookingDetail>();
  var completedBooking = RxList<BookingDetail>();
  var notificationCount = 0.obs;
  var dontKnowParkBooking = bk.Booking();
  var parkNowBooking = FixedDurationbooking();
  var parkLaterBooking = FixedDurationbooking();
  var parkAgain = ParkAgain();
  var extendParkingFee = ExtendbookingCalculation();
  var allNotification = RxList<notify.Notification>();
  var singleNotification = Rx(notify.Notification());
  var extendBookingPriceLoading = false.obs;
  var extendBookingHasPrice = false.obs;
  var amendBookingFee = Rxn<Amendbookigfee>();
  var amendBookingLoading = false.obs;
  var baseUrl=''.obs;

  @override
  void onInit() {
    if (SharedPref.hasToken()) {
      getAllBooking();
      // userController.getVehicleData();
    }

    super.onInit();
  }

  Future<void> getAllBooking() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var response =
            await AuthService().getAllBooking(token: SharedPref.getToken()!);
        print(response.data);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            booking.value = [];
            activeBooking.value = [];
            upcomingBooking.value = [];
            completedBooking.value = [];
            notificationCount.value = 0;
            List data = response.data['data'];

            booking.value = data.map((e) => BookingDetail.fromJson(e)).toList();

            for (BookingDetail element in booking) {
              if (element.status == 'Active') {
                activeBooking.add(element);
                activeBooking.refresh();
              } else if (element.status == 'Completed' ||
                  element.status == 'Canceled') {
                completedBooking.add(element);
                completedBooking.refresh();
              } else if (element.status == 'Upcoming') {
                upcomingBooking.add(element);
                upcomingBooking.refresh();
              }
              notificationCount.value = activeBooking.length;
            }
            if (activeBooking.isNotEmpty) {
              if (activeBooking.first.bookingModule == 'ivr') {
                if (activeBooking.first.startStopOption == true) {
                  SharedPref.setIvrFirstBooking(true);
                } else {
                  SharedPref.setIvrFirstBooking(false);
                }
              } else {
                SharedPref.setIvrFirstBooking(false);
              }
            }

            // ignore: prefer_is_empty
            if (activeBooking.length != 0) {
              SharedPref().setParkAgainDetails(
                  parkAgain: ParkAgain(
                      carParkName: activeBooking[0].carPark?[0].carParkName,
                      carParkPin: activeBooking[0].carPark?[0].carParkPIN,
                      timeZone: activeBooking.first.timeZone,
                      city: activeBooking[0].carPark?[0].city,
                      dontKnowParking: false,
                      endTime: activeBooking[0].bookingStart,
                      startTime: activeBooking[0].bookingEnd,
                      id: activeBooking[0].sId));
            }
          }
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> extendBookingCalculateBill(
      {required String parkingId,
      required BuildContext context,
      required int parkingFromTime,
      required int parkingUntilTime}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        extendBookingPriceLoading.value = true;
        AppOverlay.startOverlay(context);
        var responce = await ParkingService().extendBookingChecking(
          id: parkingId,
          token: SharedPref.getToken()!,
          bookingEnd: parkingUntilTime,
        );
        extendBookingPriceLoading.value = false;
        AppOverlay.hideOverlay();

        print(responce.data);

        if (responce.statusCode == 200) {
          if (responce.data['errorMessage'] == null) {
            extendBookingHasPrice.value = true;
            extendParkingFee =
                ExtendbookingCalculation.fromJson(responce.data['data']);
            print(extendParkingFee.total);
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

  Future<void> makeFixedDurationBooking({
    required BuildContext context,
    required String parkingType,
    required String bookingId,
    required String billingId,
    required String? paymentToken,
    required String? cavv,
    required String? eci,
    required String? directoryServerId,
    required String? threeDsVersion,
    required String? cardType,
    required String? firstName,
    required String? lastName,
  }) async {
    var parkNowController = Get.find<ParkingNowController>();
    try {
      if (networkController.connectionStatus.value != -1) {
        //  AppOverlay.startOverlay(context);
        var response = await BookingService().makeFixedDurationBooking(
            billingId: billingId,
            cardType: cardType,
            cavv: cavv,
            directoryServerId: directoryServerId,
            eci: eci,
            firstName: firstName,
            lastName: lastName,
            paymentToken: paymentToken,
            threeDsVersion: threeDsVersion,
            parkingType: parkingType,
            bookingId: bookingId,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            print(response.data['data']);
            parkNowBooking =
                FixedDurationbooking.fromJson(response.data['data']);
            print(parkNowBooking.booking!.carParkId);

            parkAgain = ParkAgain(
                dontKnowParking: false,
                carParkPin: parkNowBooking.carPark!.carParkPIN,
                carParkName: parkNowBooking.carPark!.carParkName,
                city: parkNowBooking.carPark!.city,
                timeZone: parkNowBooking.booking!.timeZone,
                endTime: parkNowBooking.booking!.bookingStart,
                startTime: parkNowBooking.booking!.bookingEnd,
                id: parkNowBooking.booking!.carParkId);
            SharedPref().setParkAgainDetails(parkAgain: parkAgain);

            print('-------------> parking details');

            // vehicle = Vehicle.fromJson(response.data['data']['vehicle']);
            // carPark = Carpark.fromJson(response.data['data']['carPark']);
            print('-------------> booking time');

            /*Get.toNamed(Routes.PARK_NOW_FIXED_DURATION_DETAILS_SCREEN,
                arguments: [parkNowBooking]);*/
            await getAllBooking();

            Get.offUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        ParkNowFixedDurationBookedDetailsScreen(
                          booking: parkNowBooking,
                        )), (route) {
              var currentRoute = route.settings.name;
              if (currentRoute == Routes.DIRECT_DASHBOARD) {
                return true;
              } else if (currentRoute == Routes.DASHBOARD) {
                return true;
              } else {
                return false;
              }
            });

            // AppCustomToast.successToast(response.data['message']);
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

  Future<void> makeParkLaterBooking({
    required BuildContext context,
    required String parkingType,
    required String bookingId,
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
      if (networkController.connectionStatus.value != -1) {
        // AppOverlay.startOverlay(context);
        var response = await BookingService().makeFixedDurationBooking(
            billingId: billingId,
            cardType: cardType,
            cavv: cavv,
            directoryServerId: directoryServerId,
            eci: eci,
            firstName: firstName,
            lastName: lastName,
            paymentToken: paymentToken,
            threeDsVersion: threeDsVersion,
            parkingType: parkingType,
            bookingId: bookingId,
            token: SharedPref.getToken()!);

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            print(response.data['data']);
            parkLaterBooking =
                FixedDurationbooking.fromJson(response.data['data']);
            parkAgain = ParkAgain(
                carParkPin: parkLaterBooking.carPark!.carParkPIN,
                timeZone: parkLaterBooking.booking!.timeZone,
                carParkName: parkLaterBooking.carPark!.carParkName,
                id: parkLaterBooking.carPark!.id,
                endTime: parkLaterBooking.booking!.bookingStart,
                startTime: parkLaterBooking.booking!.bookingEnd,
                city: parkLaterBooking.carPark!.city);
            SharedPref().setParkAgainDetails(parkAgain: parkAgain);
            await getAllBooking();
            AppOverlay.hideOverlay();

            //Get.offAll(()=>ParkLaterBookedDetailsScreen());
            Get.offUntil(
                MaterialPageRoute(
                    builder: (context) => ParkLaterBookedDetailsScreen()),
                (route) {
              var currentRoute = route.settings.name;
              if (currentRoute == Routes.DIRECT_DASHBOARD) {
                return true;
              } else if (currentRoute == Routes.DASHBOARD) {
                return true;
              } else {
                return false;
              }
            });

            // AppCustomToast.successToast(response.data['message']);
          } else {
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            AppOverlay.hideOverlay();
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast("Something went wrong");
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

  Future<void> makeMonthlyBooking({
    required BuildContext context,
    required String parkingType,
    required String bookingId,
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
      if (networkController.connectionStatus.value != -1) {
        // AppOverlay.startOverlay(context);
        var response = await BookingService().makeMonthlyBooking(
            billingId: billingId,
            cardType: cardType,
            cavv: cavv,
            directoryServerId: directoryServerId,
            eci: eci,
            firstName: firstName,
            lastName: lastName,
            paymentToken: paymentToken,
            threeDsVersion: threeDsVersion,
            parkingType: parkingType,
            bookingId: bookingId,
            token: SharedPref.getToken()!);

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            print(response.data['data']);
            parkLaterBooking =
                FixedDurationbooking.fromJson(response.data['data']);
            parkAgain = ParkAgain(
                carParkPin: parkLaterBooking.carPark!.carParkPIN,
                carParkName: parkLaterBooking.carPark!.carParkName,
                id: parkLaterBooking.carPark!.id,
                timeZone: parkLaterBooking.booking!.timeZone,
                endTime: parkLaterBooking.booking!.bookingStart,
                startTime: parkLaterBooking.booking!.bookingEnd,
                city: parkLaterBooking.carPark!.city);
            SharedPref().setParkAgainDetails(parkAgain: parkAgain);
            await getAllBooking();
            AppOverlay.hideOverlay();

            //Get.offAll(()=>ParkLaterBookedDetailsScreen());
            Get.offUntil(
                MaterialPageRoute(
                    builder: (context) => ParkLaterBookedDetailsScreen()),
                (route) {
              var currentRoute = route.settings.name;
              if (currentRoute == Routes.DIRECT_DASHBOARD) {
                return true;
              } else if (currentRoute == Routes.DASHBOARD) {
                return true;
              } else {
                return false;
              }
            });

            // AppCustomToast.successToast(response.data['message']);
          } else {
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            AppOverlay.hideOverlay();
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast("Something went wrong");
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

  Future<void> makeDontKnowDurationBooking({
    required BuildContext context,
    required String parkingType,
    required String vehicleNumberPate,
    required String carParkId,
    required String? bookingStartTime,
  }) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        AppOverlay.startOverlay(context);
        var response = await BookingService().makeUnFixedDurationBooking(
            parkingType: parkingType,
            vehicleNumberPate: vehicleNumberPate,
            carParkId: carParkId,
            bookingStartTime: bookingStartTime,
            token: SharedPref.getToken()!);

        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            dontKnowParkBooking =
                bk.Booking.fromJson(response.data['data']['Booking']);
            parkAgain = ParkAgain(
                dontKnowParking: true,
                timeZone: dontKnowParkBooking.timeZone,
                endTime: int.parse(dontKnowParkBooking.bookingEnd!),
                carParkPin: dontKnowParkBooking.carpark?.carParkPIN,
                carParkName: dontKnowParkBooking.carpark?.carParkName,
                id: dontKnowParkBooking.id,
                startTime: int.parse(dontKnowParkBooking.bookingStart!),
                city: dontKnowParkBooking.carpark?.city);
            SharedPref().setParkAgainDetails(parkAgain: parkAgain);

            Get.toNamed(Routes.PARK_NOW_DONT_KNOW_PARKING_DETAILS_SCREEN,
                arguments: dontKnowParkBooking);

            // AppCustomToast.successToast(response.data['message']);
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

  Future<void> getNotification() async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService()
            .getNotification(token: SharedPref.getToken()!);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            print(' notifications------------->');

            List list = response.data['data'];

            allNotification.value =
                list.map((e) => notify.Notification.fromJson(e)).toList();
          } else {
            //AppCustomToast.buildToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> getSingleNotification({required String id}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService()
            .getSingleNotification(token: SharedPref.getToken()!, id: id);
        AppOverlay.hideOverlay();

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            print(' notifications------------->');

            singleNotification.value =
                notify.Notification.fromJson(response.data['data']);
          } else {
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppCustomToast.errorToast("Something went wrong");
        }
      } else {
        AppOverlay.hideOverlay();
        AppCustomToast.warningToast('Please check your internet connection');
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<void> calculateExtendBooking(
      {required ParkingNowController ctrl,
      required BuildContext context,
      required int parkingFromTime,
      required String id,
      required String vehicalNumber,
      required int parkingUntilTime}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var responce = await ParkingService().calculateBill(
          token: SharedPref.getToken()!,
          bookingStart: parkingFromTime,
          bookingEnd: parkingUntilTime,
          carParkId: id,
          parkingType: 'parkNow',
          vehicleId: vehicalNumber,
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

  Future<void> createReview(
      {required String carParkId,
      required int date,
      required int rating,
      required String? review}) async {
    try {
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService().createReview(
            token: SharedPref.getToken()!,
            carParkId: carParkId,
            date: date,
            rating: rating,
            review: review);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
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
      print(e);
    }
  }

  Future<List<Review>> getReview({
    required String carParkId,
  }) async {
    try {
      var response = await BookingService()
          .getReview(token: SharedPref.getToken()!, carParkId: carParkId);
      print(response.data);

      if (response.statusCode == 200) {
        if (response.data['errorMessage'] == null) {
          List allReview = response.data['data'];
          List<Review> reviews =
              allReview.map((e) => Review.fromJson(e)).toList();

          return reviews;
        } else {
          throw Exception('err');
        }
      } else {
        throw Exception('err');
      }
    } on DioError catch (e) {
      print(e);
      throw Exception('err');
    }
  }

  Future<void> cancelBooking(
      {required String id,
      required BuildContext context,
      required String reason}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService().cancelBooking(
          reason: reason,
          id: id,
          token: SharedPref.getToken()!,
        );

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            await getAllBooking();
            AppOverlay.hideOverlay();
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            AppCustomToast.successToast(response.data['message']);
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(response.data['errorMessage']);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast("Something went wrong");
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

  Future<void> checkAmendBooking(
      {required String bookingId,
      required BuildContext context,
      required int bookingEnd,
      required int bookingStart}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        amendBookingLoading.value = true;
        var response = await BookingService().checkAmendBooking(
          bookingEnd: bookingEnd,
          bookingStart: bookingStart,
          id: bookingId,
          token: SharedPref.getToken()!,
        );
        AppOverlay.hideOverlay();
        amendBookingLoading.value = false;
        print(response.data);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            amendBookingFee.value =
                Amendbookigfee.fromJson(response.data['data']);
          } else {
            Get.back();
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

  Future<void> draftAmendBooking(
      {required String bookingId,
      required BuildContext context,
      required int bookingEnd,
      required int bookingStart}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService().draftAmendBooking(
          bookingEnd: bookingEnd,
          bookingStart: bookingStart,
          id: bookingId,
          token: SharedPref.getToken()!,
        );
        AppOverlay.hideOverlay();
        print(bookingStart);
        print(bookingEnd);
        print(bookingId);

        print(response.data);
        print('------------------>with payment');
        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            var id = response.data['data']['id'];
            // ignore: use_build_context_synchronously
            confirmAmendBooking(
                bookingId: id,
                context: context,
                bookingEnd: bookingEnd,
                bookingStart: bookingStart);
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
  //TODO

  Future<void> confirmAmendBooking(
      {required String bookingId,
      required BuildContext context,
      required int bookingEnd,
      required int bookingStart}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService().confirmAmendBooking(
          billingId: userController.cardList.value.first.id!,
          bookingId: bookingId,
          id: bookingId,
          token: SharedPref.getToken()!,
        );
        AppOverlay.hideOverlay();

        print(response.data);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            await getAllBooking();
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            Get.toNamed(Routes.DIRECT_DASHBOARD);
            // Get.back();
            // AppCustomToast.errorToast(response.data['message']);
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

  Future<void> amendBookingWihoutPaymentGateway(
      {required String bookingId,
      required BuildContext context,
      required int bookingEnd,
      required int bookingStart}) async {
    try {
      AppOverlay.startOverlay(context);
      if (networkController.connectionStatus.value != -1) {
        var response = await BookingService().amendBookingWihoutPaymentGateway(
          bookingEnd: bookingEnd,
          bookingStart: bookingStart,
          id: bookingId,
          token: SharedPref.getToken()!,
        );
        AppOverlay.hideOverlay();
        print('------------------>without payment');
        print(response.data);

        if (response.statusCode == 200) {
          if (response.data['errorMessage'] == null) {
            // AppCustomToast.errorToast(response.data['message']);
            await getAllBooking();
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

  Future<void> parkNowBookingUsingVolet({
    required BuildContext context,
    required String parkingType,
    required String bookingId,
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
      if (networkController.connectionStatus.value != -1) {
        // AppOverlay.startOverlay(context);
        var response = await BookingService().parkNowBookingUsingVolet(
            billingId: billingId,
            cardType: cardType,
            cavv: cavv,
            directoryServerId: directoryServerId,
            eci: eci,
            firstName: firstName,
            lastName: lastName,
            paymentToken: paymentToken,
            threeDsVersion: threeDsVersion,
            parkingType: parkingType,
            bookingId: bookingId,
            token: SharedPref.getToken()!);

        if (response.statusCode == 200) {
          print(response.data);
          if (response.data['errorMessage'] == null) {
            print(response.data['data']);
            parkNowBooking =
                FixedDurationbooking.fromJson(response.data['data']);
            print(parkNowBooking.booking!.carParkId);

            parkAgain = ParkAgain(
                dontKnowParking: false,
                timeZone: parkNowBooking.booking!.timeZone,
                carParkPin: parkNowBooking.carPark!.carParkPIN,
                carParkName: parkNowBooking.carPark!.carParkName,
                endTime: parkNowBooking.booking!.bookingStart,
                startTime: parkNowBooking.booking!.bookingEnd,
                id: parkNowBooking.booking!.carParkId);
            SharedPref().setParkAgainDetails(parkAgain: parkAgain);
            userController.getCardDetail();
            AppOverlay.hideOverlay();

            print('-------------> parking details');

            // vehicle = Vehicle.fromJson(response.data['data']['vehicle']);
            // carPark = Carpark.fromJson(response.data['data']['carPark']);
            print('-------------> booking time');

            /*Get.toNamed(Routes.PARK_NOW_FIXED_DURATION_DETAILS_SCREEN,
                arguments: [parkNowBooking]);*/
            await getAllBooking();

            Get.offUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        ParkNowFixedDurationBookedDetailsScreen(
                          booking: parkNowBooking,
                        )), (route) {
              var currentRoute = route.settings.name;
              if (currentRoute == Routes.DIRECT_DASHBOARD) {
                return true;
              } else if (currentRoute == Routes.DASHBOARD) {
                return true;
              } else {
                return false;
              }
            });

            // AppCustomToast.successToast(response.data['message']);
          } else {
            AppOverlay.hideOverlay();
            AppCustomToast.errorToast(response.data['errorMessage']);
            var bottomNavigation = Get.find<BottomNavigationController>();
            bottomNavigation.activeIndex.value = 0;
            Get.toNamed(Routes.DIRECT_DASHBOARD);
          }
        } else {
          AppOverlay.hideOverlay();
          AppCustomToast.errorToast("Something went wrong");
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
