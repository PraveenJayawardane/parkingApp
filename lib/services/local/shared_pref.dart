import 'package:get_storage/get_storage.dart';
import 'package:parkfinda_mobile/model/park_again.dart';
import 'package:parkfinda_mobile/model/user.dart';
import 'package:parkfinda_mobile/constants/constant.dart';

class SharedPref {
  static GetStorage userBox = GetStorage(Constant.userBox);
  static GetStorage parkAgainDetail = GetStorage(Constant.parkAgainDetail);

  List<SearchResult> searchResult = [];

  void addUserBox(String key, dynamic value) {
    userBox.write(key, value);
  }

  static String? getToken() {
    return userBox.read(Constant.token);
  }

  static bool hasToken() {
    if (userBox.read(Constant.token) == null) {
      return false;
    } else {
      return true;
    }
  }

  static bool isGuestAccount() {
    if (userBox.read(Constant.guest) == null) {
      return false;
    } else {
      return userBox.read(Constant.guest);
    }
  }

  void saveUserData(User user) {
    userBox.write(Constant.profilePicture, user.profilePicture);
    userBox.write(Constant.isActive, user.isActive);
    userBox.write(Constant.otpVerified, user.otpVerified);
    userBox.write(Constant.tfaEnable, user.tfaEnable);
    userBox.write(Constant.guest, user.isGuest);
    userBox.write(Constant.firstName, user.firstName);
    userBox.write(Constant.lastName, user.lastName);
    userBox.write(Constant.email, user.email);
    userBox.write(Constant.mobileNumber, user.mobileNumber);
    userBox.write(Constant.id, user.id);
    userBox.write(Constant.token, user.token);
    userBox.write(Constant.customerVaultId, user.customerVaultId);
  }

  User getUser() {
    User user = User();
    user.profilePicture = userBox.read(Constant.profilePicture);
    user.isActive = userBox.read(Constant.isActive);
    user.otpVerified = userBox.read(Constant.otpVerified);
    user.tfaEnable = userBox.read(Constant.tfaEnable);
    user.isGuest = userBox.read(Constant.guest);
    user.firstName = userBox.read(Constant.firstName);
    user.lastName = userBox.read(Constant.lastName);
    user.email = userBox.read(Constant.email);
    user.mobileNumber = userBox.read(Constant.mobileNumber);
    user.id = userBox.read(Constant.id);
    user.token = userBox.read(Constant.token);
    user.customerVaultId = userBox.read(Constant.customerVaultId);
    return user;
  }

  void setParkAgainDetails({required ParkAgain parkAgain}) {
    parkAgainDetail.write(Constant.displayTimeZone, parkAgain.timeZone);
    parkAgainDetail.write(Constant.carParkPin, parkAgain.carParkPin);
    parkAgainDetail.write(Constant.carParkName, parkAgain.carParkName);
    parkAgainDetail.write(Constant.city, parkAgain.city);
    parkAgainDetail.write(Constant.id, parkAgain.id);
    parkAgainDetail.write(Constant.startTime, parkAgain.startTime);
    parkAgainDetail.write(Constant.endTime, parkAgain.endTime);
    parkAgainDetail.write(Constant.dontKnowParking, parkAgain.dontKnowParking);
  }

  static bool hasParkAgain() {
    return parkAgainDetail.hasData(Constant.carParkPin);
  }

  static int? carParkPin() {
    return parkAgainDetail.read(Constant.carParkPin);
  }

  static String? getCarParkName() {
    return parkAgainDetail.read(Constant.carParkName);
  }

  static String? getCity() {
    return parkAgainDetail.read(Constant.city);
  }

  static String? getDisplayTimeZone() {
    return parkAgainDetail.read(Constant.displayTimeZone);
  }

  static String? getId() {
    return parkAgainDetail.read(Constant.id);
  }

  static int? getStartTime() {
    return parkAgainDetail.read(Constant.startTime);
  }

  static int? getEndTime() {
    return parkAgainDetail.read(Constant.endTime);
  }

  static bool isDontknowParking() {
    bool? isDontKnow = parkAgainDetail.read(Constant.dontKnowParking);
    if (isDontKnow == null) {
      return false;
    } else {
      return parkAgainDetail.read(Constant.dontKnowParking);
    }
  }

  void setCustomerVaultId({required String customerVaultId}) {
    userBox.write(Constant.customerVaultId, customerVaultId);
  }

  void setSearchResult({required SearchResult result}) {
    userBox.write('searchResult', <String, dynamic>{
      'carParkName': result.carParkName,
      'address': result.address,
      'postCode': result.postCode,
      'carParkPin': result.carParkPin,
      'lautitude': result.lautitude,
      'longtitude': result.longtitude,
      'country': result.country,
      'city': result.city
    });
  }

  SearchResult? getSearchResult() {
    var result = userBox.read('searchResult');
    print(result);
    if (result != null) {
      return SearchResult(
        lautitude: result['lautitude'],
        longtitude: result['longtitude'],
        carParkName: result['carParkName'],
        address: result['address'],
        postCode: result['postCode'],
        carParkPin: result['carParkPin'],
        country: result['country'],
        city: result['city'],
      );
    } else {
      return null;
    }
  }

  static bool hasSearchResult() {
    var result = userBox.read('searchResult');
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  static bool hasIvrFirstBooking() {
    var result = userBox.read('hasIvr');
    if (result != null) {
      if (result == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static void setIvrFirstBooking(bool state) {
    userBox.write('hasIvr', state);
  }

  static void setTimeZone(String? timeZone) {
    userBox.write('timeZone', timeZone);
  }

  static String? getTimeZone() {
    var timeZone = userBox.read('timeZone');
    if (timeZone != null) {
      return timeZone;
    } else {
      return null;
    }
  }

  static void setCurerentParkCurrency(String? currency) {
    userBox.write('curerentParkCurrency', currency);
  }

  static String? getCurerentParkCurrency() {
    var curerentParkCurrency = userBox.read('curerentParkCurrency');
    if (curerentParkCurrency != null) {
      return curerentParkCurrency;
    } else {
      return null;
    }
  }
}

class SearchResult {
  String? carParkName;
  String? address;
  String? postCode;
  String? carParkPin;
  double? lautitude;
  double? longtitude;
  String? country;
  String? city;

  SearchResult(
      {required this.carParkName,
      this.country,
      required this.address,
      required this.postCode,
      required this.carParkPin,
      required this.lautitude,
      required this.longtitude,
      this.city});
}
