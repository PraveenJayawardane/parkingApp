import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';

import '../../controllers/booking_controller.dart';
import '../local/shared_pref.dart';

BookingController bookingController = Get.find<BookingController>();

class BookingService {
  dios.Dio dio =
      dios.Dio(dios.BaseOptions(baseUrl: bookingController.baseUrl.value!));

  Future<dios.Response> getSingleBooking(
      {required String id, required String token}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.get('/customers/bookings/$id',
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> makeFixedDurationBooking({
    required String parkingType,
    required String token,
    required String? bookingId,
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
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "billingId": billingId,
      "bookingId": bookingId,
      "payment_token": paymentToken,
      "cavv": cavv,
      "eci": eci,
      "directoryServerId": directoryServerId,
      "three_ds_version": threeDsVersion,
      "cardType": cardType,
      "first_name": firstName,
      "last_name": lastName
    };

    return dio.post('/customers/bookings-sale-vault',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> makeMonthlyBooking({
    required String parkingType,
    required String token,
    required String? bookingId,
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
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "billingId": billingId,
      "bookingId": bookingId,
      "payment_token": paymentToken,
      "cavv": cavv,
      "eci": eci,
      "directoryServerId": directoryServerId,
      "three_ds_version": threeDsVersion,
      "cardType": cardType,
      "first_name": firstName,
      "last_name": lastName
    };

    return dio.post('/customers/booking-monthly-confirm-by-vault',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> makeUnFixedDurationBooking({
    required String parkingType,
    required String token,
    required String vehicleNumberPate,
    required String carParkId,
    required String? bookingStartTime,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "parkingType": parkingType,
      "vehicleNumberPlate": vehicleNumberPate,
      "carParkId": carParkId,
      "bookingStart": bookingStartTime,
      "vehicleId": carParkId
    };
    return dio.post('/customers/bookings-dontKnowParking',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> getNotification({required String token}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    return dio.post('/customers/notifications',
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> getSingleNotification(
      {required String token, required String id}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    return dio.post('/customers/notifications/$id',
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> createReview(
      {required String token,
      required String carParkId,
      required String? review,
      required int rating,
      required int date}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "carParkId": carParkId,
      "review": review,
      "rating": rating,
      "date": date
    };

    return dio.post('/customers/review',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> getReview({
    required String token,
    required String carParkId,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    return dio.get('/customers/carpark/review/$carParkId',
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> cancelBooking({
    required String token,
    required String id,
    required String reason,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {"refundReason": reason};
    print(id);
    print(reason);
    return dio.post('/customers/booking/cancel/$id',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> checkAmendBooking({
    required String token,
    required int bookingStart,
    required int bookingEnd,
    required String id,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {"bookingStart": bookingStart, "bookingEnd": bookingEnd};
    print(body);
    print(id);

    return dio.post('/customers/booking-amend-check/$id',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> draftAmendBooking({
    required String token,
    required int bookingStart,
    required int bookingEnd,
    required String id,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      'bookingStartFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingStart).toString(),
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString(),
      'timeZone': SharedPref.getTimeZone(),
    };

    return dio.post('/customers/booking-amend-draft/$id',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> confirmAmendBooking({
    required String token,
    required String billingId,
    required String bookingId,
    required String id,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "billingId": billingId,
      "bookingId": bookingId,
      "cardType": 'existing'
    };

    return dio.post('/customers/booking-amend-confirm-by-vault/$id',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> amendBookingWihoutPaymentGateway({
    required String token,
    required int bookingStart,
    required int bookingEnd,
    required String id,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };
    var body = {
      "bookingStart": bookingStart,
      "bookingEnd": bookingEnd,
      'bookingStartFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingStart).toString(),
      'bookingEndFormatted':
          DateTime.fromMillisecondsSinceEpoch(bookingEnd).toString(),
      'timeZone': SharedPref.getTimeZone(),
    };

    return dio.post(
        '/customers/booking-amend-confirm-without-payment-gateway/$id',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }

  Future<dios.Response> parkNowBookingUsingVolet({
    required String? parkingType,
    required String token,
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
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {
      "billingId": billingId,
      "bookingId": bookingId,
      "payment_token": paymentToken,
      "cavv": cavv,
      "eci": eci,
      "directoryServerId": directoryServerId,
      "three_ds_version": threeDsVersion,
      "cardType": cardType,
      "first_name": firstName,
      "last_name": lastName
    };
    print(body);

    return dio.post('/customers/bookings-sale-vault',
        data: body,
        options: dios.Options(
          headers: header,
        ));
  }
}
