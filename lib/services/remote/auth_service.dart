import 'package:dio/dio.dart';
import 'package:parkfinda_mobile/services/remote/account_service.dart';

import 'dart:async';

import '../../constants/constant.dart';

class AuthService {
  Dio dio = Dio(BaseOptions(baseUrl: Constant.authUrl));

  Future<Response> emailSignIn(
      {required String email, required String password}) async {
    var data = {
      'username': email,
      'password': password,
    };

    var header = {"Accept": "application/json"};
    return dio.post('/customers/login',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> googleSignIn(String token) {
    var header = {"socialToken": token};
    return dio.post('/customers/login/google',
        options: Options(headers: header));
  }

  Future<Response> facebookSignIn(String token) {
    var header = {"socialToken": token};
    return dio.post('/customers/login/facebook',
        options: Options(headers: header));
  }

  Future<Response> appleSignIn(String token) {
    var header = {"socialToken": token};
    return dio.post('/customers/login/apple',
        options: Options(headers: header));
  }

  Future<Response> forgetEmailPassword(String email) async {
    var data = {
      'email': email,
    };
    var header = {"Accept": "application/json"};
    return dio.post('/customer/forgot-password',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> emailSignUp(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String countryCode,
      required String phone}) async {
    var data = {
      "firstName": firstname,
      "lastName": lastname,
      "email": email,
      "password": password,
      "mobileNumber": phone,
      "profilePicture": null,
      "countryCode": countryCode
    };
    print(data);

    var header = {"Accept": "application/json"};
    return dio.post('/customers/register',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> guestUserLogin() async {
    var header = {"Accept": "application/json"};
    return dio.post('/customers/login/guest',
        options: Options(
          headers: header,
        ));
  }

  Future<Response> validateToken(String token) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.get('/customers/current-user',
        options: Options(
          headers: header,
        ));
  }

  Future<Response> logOut(String token) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.post('/customers/logout', options: Options(headers: header));
  }

  Future<Response> forgetPassword({required String email}) {
    var header = {"Accept": "application/json"};
    return dio.post('/customers/forgot-password-web?email=$email',
        options: Options(headers: header));
  }

  Future<Response> verifyForgetPassword(
      {required String userId, required String otp}) {
    var body = {"customerId": userId, "otp": otp};
    var header = {"Accept": "application/json"};
    return dio.post('/customers/forgot-password-otp',
        data: body, options: Options(headers: header));
  }

  Future<Response> updatePassword(
      {required String userId, required String password}) {
    var body = {"customerId": userId, "password": password};
    var header = {"Accept": "application/json"};
    return dio.post('/customers/update-password',
        data: body, options: Options(headers: header));
  }

  Future<Response> getAllBooking({required String token}) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.get('/customers/bookings/',
        options: Options(
          headers: header,
        ));
  }

  Future<Response> getCarparkPin(String token, String id) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.get('/customers/carpark-PIN/$id',
        options: Options(headers: header));
  }

  Future<Response> editAccount(
      {required String email,
      required String firstName,
      required String lastNAme,
      required String mobileNumber,
      required String token,
      required String countryCode}) async {
    var data = {
      "email": email,
      "firstName": firstName,
      "lastName": lastNAme,
      "countryCode": countryCode,
      "mobileNumber": mobileNumber
    };

    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.patch('/customers/update-profile',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> changePassword(
      String oldPassword, String newPassword, String token) async {
    var data = {"oldPassword": oldPassword, "password": newPassword};
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return dio.patch('/customers/change-password',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> setRecentSearch({
    required String token,
    String? keyWord,
    required String carparkId,
    required String url,
  }) async {
    Dio d = Dio(BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    var body = {"keyWord": keyWord, "carParkId": carparkId};
    print(bookingController.baseUrl);
    return d.post('/customers/recent-search',
        data: body,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> getRecentSearch({
    required String token,
  }) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token',
      "Content-type": "application/json"
    };

    return dio.get('/customers/recent-search',
        options: Options(
          headers: header,
        ));
  }

  Future<Response> deleteUser({required String token}) {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };

    return dio.delete(
      '/api/v1/customers/delete-account',
      options: Options(
        headers: header,
      ),
    );
  }

  Future<Response> updateProfilePicture(String token, String url) async {
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    var data = {'profilePicture': url};
    return dio.patch('/customers/update-picture',
        data: data,
        options: Options(
          headers: header,
        ));
  }

  Future<Response> getAllVehicle({required String token, required String url}) {
    Dio d = Dio(BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print('vehicle data');
    print(url);

    return d.get('/customers/vehicle', options: Options(headers: header));
  }

  Future<Response> getPayHereCardDetail({
    required String token,
    required String userId,
  }) {
    Dio d =
        Dio(BaseOptions(baseUrl: 'https://staging-api.parkfinda.co.uk/api/v1'));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    return d.get('/customers/payhere/vault/$userId',
        options: Options(
          headers: header,
        ));
  }

  Future<Response> getCardDetail({
    required String token,
    required String url,
  }) {
    Dio d = Dio(BaseOptions(baseUrl: url));
    var header = {
      "Accept": "application/json",
      "Authorization": 'Bearer $token'
    };
    print(url);

    return d.post(
      '/customers/customer-vault',
      options: Options(
        headers: header,
      ),
    );
  }
}
