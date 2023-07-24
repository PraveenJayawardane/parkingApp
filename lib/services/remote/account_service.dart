import 'package:dio/dio.dart' as dios;
import 'package:get/get.dart';

import '../../controllers/booking_controller.dart';

BookingController bookingController = Get.find<BookingController>();

class AccountService {
  dios.Dio dio =
      dios.Dio(dios.BaseOptions(baseUrl: bookingController.baseUrl.value));

  // Future<dios.Response> checkValidVehical(String vehicalNumber) async {
  //   dios.Dio dioo = dios.Dio(dios.BaseOptions(
  //       baseUrl: 'https://driver-vehicle-licensing.api.gov.uk'));
  //   var header = {
  //     'Content-Type': 'application/json',
  //     "Accept": "application/json",
  //     "x-api-key": "rgsfZJWoqFa6WkhnVMTIE4p7YIpLAsXSDXpAN5ig"
  //   };
  //   var data = {"registrationNumber": vehicalNumber};
  //   return dioo.post('/vehicle-enquiry/v1/vehicles',
  //       data: data, options: dios.Options(headers: header));
  // }

  Future<dios.Response> createVehicalGuest({
    required String numberPlate,
    required String token,
  }) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "VRN": numberPlate,
    };
    print(bookingController.baseUrl);
    return dio.post('/customers/vehicle',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> createVehical({
    required String numberPlate,
    required String token,
    required String url,
  }) {
    dios.Dio d = dios.Dio(dios.BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "VRN": numberPlate,
    };
    print(url);
    return d.post('/customers/vehicle',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> deteleVehical(
      {required String token, required String id, required String url}) {
    dios.Dio d = dios.Dio(dios.BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return d.delete('/customers/vehicle/$id',
        options: dios.Options(headers: header));
  }

  Future<dios.Response> createForignVehical(
      String numberPlate, String token, String name, String model) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "name": name,
      "numberPlate": numberPlate,
      "model": model,
      "isForeign": true
    };
    return dio.post('/customers/vehicle',
        data: data, options: dios.Options(headers: header));
  }

  Future<dios.Response> editVehical(
      String token, String id, String numberPlate) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "VRN": numberPlate,
    };
    return dio.patch('/customers/vehicle/$id',
        options: dios.Options(
          headers: header,
        ),
        data: data);
  }

  Future<dios.Response> saveCardDetail({
    required String token,
    required String paymentToken,
    required String url,
  }) {
    dios.Dio d = dios.Dio(dios.BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "payment_token": paymentToken,
    };
    return d.post('/customers/vault',
        options: dios.Options(
          headers: header,
        ),
        data: data);
  }

  Future<dios.Response> sendMessagetoMail({
    required String token,
    required String message,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {
      "firstName": firstName,
      "LastName": lastName,
      "email": email,
      "phoneNo": phoneNumber,
      "message": message,
    };
    print(data);
    return dio.post('/contact-us',
        options: dios.Options(
          headers: header,
        ),
        data: data);
  }

  Future<dios.Response> deleteCard({
    required String token,
    required String billingId,
  }) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.delete(
      '/customers/vault/$billingId',
      options: dios.Options(
        headers: header,
      ),
    );
  }
}
