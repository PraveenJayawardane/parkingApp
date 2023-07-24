import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';
import 'package:parkfinda_mobile/controllers/booking_controller.dart';

import '../local/shared_pref.dart';

BookingController parkingLaterController = Get.find<BookingController>();

class ParkingService {
  dios.Dio dio =
      dios.Dio(dios.BaseOptions(baseUrl: parkingLaterController.baseUrl.value));

  Future<dios.Response> getAllCarpark(
      {required String token,
      required double latitude,
      required int startTime,
      required int endTime,
      required double longitude}) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print('----------------base url ${parkingLaterController.baseUrl.value}');
    return dio.get(
        '/customers/carpark?longitude=$longitude&latitude=$latitude&bookingStart=$startTime=&bookingEnd=$endTime',
        options: dios.Options(headers: header));
  }

  Future<List<dios.Response>> getParkLaterSingleLocationsDetails(
      {required String token,
      required String carParkId,
      required String? vehicalId,
      required String parkingFrom,
      required String parkingUntil}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    var calculationData = {
      "parkingType": "parkLater",
      "carParkId": carParkId,
      "bookingStart": int.parse(parkingFrom),
      "bookingEnd": int.parse(parkingUntil),
      "vehicleId": vehicalId,
      "bookingModule": "mobile"
    };

    return await Future.wait([
      dio.post('/customers/bookings-calculate',
          data: calculationData, options: dios.Options(headers: header)),
      dio.get('/customers/carpark/$carParkId',
          options: dios.Options(headers: header)),
      dio.get('/customers/carpark/review/$carParkId',
          options: dios.Options(headers: header))
    ]);
  }

  Future<dios.Response> getSingleCarpark(String token, String parkId) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.get('/customers/carpark/$parkId',
        options: dios.Options(headers: header));
  }

  Future<dios.Response> calculateBill({
    required String token,
    required int bookingStart,
    required int bookingEnd,
    required String carParkId,
    required String? vehicleId,
    required String parkingType,
  }) {
    var data = {
      "parkingType": parkingType,
      "vehicleId": vehicleId,
      "carParkId": carParkId,
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      "bookingModule": "mobile"
    }; //64acddae0fa939f02e43d70b
    //64acddae0fa939f02e43d70b
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print('url data');
    print(dio.options.baseUrl);
    print(data);
    return dio.post('/customers/bookings-calculate',
        data: data, options: dios.Options(headers: header));
  }

  //calculateMonthlyBill

  Future<dios.Response> calculateMonthlyBill({
    required String token,
    required int bookingStart,
    required int bookingEnd,
    required String carParkId,
    required String? vehicleId,
    required String parkingType,
  }) {
    var data = {
      "parkingType": parkingType,
      "vehicleId": vehicleId,
      "carParkId": carParkId,
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      "bookingModule": "mobile"
    };
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print(data);

    return dio.post('/customers/booking-monthly-check',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> draftBooking(
      {required String token,
      required int bookingStart,
      required int bookingEnd,
      required String carParkId,
      required String parkingType,
      required String vehicleId,
      required bool smsFee,
      required int bookingDraft,
      required bool smsReminderFee}) {
    var data = {
      "parkingType": parkingType,
      "carParkId": carParkId,
      'bookingStartFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingStart).toString(),
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString(),
      'timeZone': SharedPref.getTimeZone(),
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      "vehicleId": vehicleId,
      "smsFee": smsFee,
      "smsReminderFee": smsReminderFee,
      "bookingDraft": bookingDraft,
      "bookingModule": "mobile"
    };

    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print(data);

    return dio.post('/customers/bookings-draft',
        data: data, options: dios.Options(headers: header));
  }

  //draftBookingMonthly
  Future<dios.Response> draftBookingMonthly(
      {required String token,
      required int bookingStart,
      required int bookingEnd,
      required String carParkId,
      required String parkingType,
      required String vehicleId,
      required int bookingDraft,
      required String bookingModule}) {
    var data = {
      "parkingType": parkingType,
      "carParkId": carParkId,
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      "vehicleId": vehicleId,
      "bookingDraft": bookingDraft,
      "bookingModule": bookingModule,
      'bookingStartFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingStart).toString(),
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString(),
      'timeZone': SharedPref.getTimeZone(),
    };

    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print(data);

    return dio.post('/customers/booking-monthly-draft',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> checkIdontKnowParkingBooking({
    required String token,
    required int bookingStart,
    required String carParkId,
    required String parkingType,
    required String vehicleId,
  }) {
    var data = {
      "parkingType": parkingType,
      "vehicleId": vehicleId,
      "carParkId": carParkId,
      "bookingStart": bookingStart
    };

    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.post('/customers/bookings-dontKnowParking-check',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> draftIDontKnowParkingBooking({
    required String token,
    required int bookingStart,
    required String carParkId,
    required String parkingType,
    required String vehicleId,
    required String bookingModule,
    required int bookingDraft,
  }) {
    var data = {
      "parkingType": parkingType,
      "vehicleId": vehicleId,
      "carParkId": carParkId,
      "bookingStart": bookingStart,
      "bookingModule": bookingModule,
      "bookingDraft": bookingDraft
    };
    print(data);
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.post('/customers/bookings-dontKnowParking-draft',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> confirmIDontKnowParkingBooking({
    required String parkingType,
    required String token,
    required String ccnumber,
    required String? ccexp,
    required String? cvv,
    required String? bookingId,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "parkingType": parkingType,
      "ccnumber": ccnumber,
      "ccexp": ccexp,
      "cvv": cvv,
      "bookingId": bookingId,
    };
    return dio.post('/customers/bookings-dontKnowParking-confirm',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> dontKnowParkingstop(
      {required int bookingEnd,
      required String token,
      required String bookingId}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {"bookingEnd": bookingEnd};
    print(body);
    print(bookingId);
    return dio.post('/customers/booking/stop/$bookingId',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> extendBookingChecking(
      {required String token,
      required String id,
      required int bookingEnd}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {"bookingEnd": bookingEnd};
    print(DateTime.fromMillisecondsSinceEpoch(bookingEnd));
    print(id);
    return dio.post('/customers/bookings-extend-check/$id',
        data: body, options: dios.Options(headers: header));
  } //64acdd835c003122454bb62c

  Future<dios.Response> draftExtendBooking(
      {required String token,
      required String id,
      required int bookingEnd,
      required int bookingDraft}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "bookingEnd": bookingEnd,
      "bookingDraft": bookingDraft,
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString(),
    };
    return dio.post('/customers/bookings-extend-draft/$id',
        data: body, options: dios.Options(headers: header));
  }

  Future<dios.Response> extendBookigWithoutPaymentGateway(
      {required String token,
      required String id,
      required int bookingEnd,
      required int bookingDraft}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "bookingEnd": bookingEnd,
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString()
    };
    return dio.post('/customers/bookings-extend-confirm-without-payment/$id',
        data: body, options: dios.Options(headers: header));
  }

  //extendBookigWithoutPaymentGateway

  Future<dios.Response> confirmExtendBooking({
    required String token,
    required String ccnumber,
    required String ccexp,
    required String cvv,
    required String bookingId,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "ccnumber": ccnumber,
      "ccexp": ccexp,
      "cvv": cvv,
    };
    return dio.post('/customers/bookings-extend-confirm/$bookingId',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> extendBookingPayment(
      {required String token,
      required String bookingId,
      required String billingId,
      required String cardType}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "bookingId": bookingId,
      "billingId": billingId,
      "cardType": cardType
    };
    return dio.post('/customers/bookings-extend-confirm-by-vault/$bookingId',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> getAllCarparksForMonthlyBooking({
    required String token,
    required double latitude,
    required double longtiude,
    required int bookingStart,
    required int bookingEnd,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    return dio.get(
        '/customers/carpark-monthly?longitude=$longtiude&latitude=$latitude&bookingStart=$bookingStart&bookingEnd=$bookingEnd',
        options: dios.Options(
          headers: header,
        ));
  }

  Future<List<dios.Response>> getParkLaterMonthleyLocationsDetails(
      {required String token,
      required String carParkId,
      required String? vehicalId,
      required String parkingFrom,
      required String parkingUntil}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    var calculationData = {
      "parkingType": "monthly",
      "carParkId": carParkId,
      "bookingModule": "mobile",
      "bookingStart": int.parse(parkingFrom),
      "bookingEnd": int.parse(parkingUntil),
      "vehicleId": vehicalId
    };
    print("$carParkId -------->");
    return await Future.wait([
      dio.post('/customers/booking-monthly-check',
          data: calculationData, options: dios.Options(headers: header)),
      dio.get('/customers/carpark/$carParkId',
          options: dios.Options(headers: header)),
      dio.get('/customers/carpark/review/$carParkId',
          options: dios.Options(headers: header))
    ]);
  }

  Future<dios.Response> changeVrn({
    required String token,
    required String vehicleId,
    required String bookingId,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {"vehicleId": vehicleId};

    return dio.put('/customers/booking/VRN/$bookingId',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> validateBooking(
      {required String token, required String bookingId}) {
    var data = {"bookingId": bookingId};
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.post('/customers/payhere/validate-booking',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> payHereHashCode(
      {required String token, required String bookingId}) {
    var data = {"bookingId": bookingId};
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print(data);

    return dio.post('/customers/payhere/hash-code',
        data: data, options: dios.Options(headers: header));
  }
}
