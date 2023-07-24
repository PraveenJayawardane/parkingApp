class ParkLaterLocations {
  ParkLaterLocation? parkLaterLocation;

  ParkLaterLocations({
    this.parkLaterLocation,
  });

  ParkLaterLocations.fromJson(Map<String, dynamic> json) {
    parkLaterLocation =
        json['data'] != null ? ParkLaterLocation.fromJson(json['data']) : null;
  }
}

class ParkLaterLocation {
  List<ParkLaterLocationData>? all;
  List<ParkLaterLocationData>? rV;
  List<ParkLaterLocationData>? eVtype1;
  List<ParkLaterLocationData>? eVtype2;
  List<ParkLaterLocationData>? eVtype3;

  ParkLaterLocation(
      {this.all, this.rV, this.eVtype1, this.eVtype2, this.eVtype3});

  ParkLaterLocation.fromJson(Map<String, dynamic> json) {
    if (json['All'] != null) {
      all = <ParkLaterLocationData>[];
      json['All'].forEach((v) {
        all!.add(ParkLaterLocationData.fromJson(v));
      });
    }
    if (json['RV'] != null) {
      rV = <ParkLaterLocationData>[];
      json['RV'].forEach((v) {
        rV!.add(ParkLaterLocationData.fromJson(v));
      });
    }
    if (json['EVtype1'] != null) {
      eVtype1 = <ParkLaterLocationData>[];
      json['EVtype1'].forEach((v) {
        eVtype1!.add(ParkLaterLocationData.fromJson(v));
      });
    }
    if (json['EVtype2'] != null) {
      eVtype2 = <ParkLaterLocationData>[];
      json['EVtype2'].forEach((v) {
        eVtype2!.add(ParkLaterLocationData.fromJson(v));
      });
    }
    if (json['EVtype3'] != null) {
      eVtype3 = <ParkLaterLocationData>[];
      json['EVtype3'].forEach((v) {
        eVtype3!.add(ParkLaterLocationData.fromJson(v));
      });
    }
  }
}

class ParkLaterLocationData {
  String? nmiSecurityKey;
  int? spaces;
  bool? isCCTV;
  bool? isSecurity;
  bool? eV;
  bool? rV;
  bool? eVType1;
  bool? eVType2;
  bool? eVType3;
  bool? isDeleted;
  List<String>? photo;
  String? accountId;
  String? carParkName;
  String? email;
  String? addressLineOne;
  String? addressLineTwo;
  String? postCode;
  String? city;
  String? country;
  String? currency;

  double? latitude;
  double? longitude;
  String? contactPersonName;
  String? contactNumber;
  String? maxHeight;

  String? carParkInformation;
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  String? id;
  String? priceStartingFrom;

  ParkLaterLocationData(
      {this.nmiSecurityKey,
      this.spaces,
      this.currency,
      this.isCCTV,
      this.country,
      this.isSecurity,
      this.eV,
      this.rV,
      this.eVType1,
      this.eVType2,
      this.eVType3,
      this.isDeleted,
      this.photo,
      this.accountId,
      this.carParkName,
      this.email,
      this.addressLineOne,
      this.addressLineTwo,
      this.postCode,
      this.city,
      this.latitude,
      this.longitude,
      this.contactPersonName,
      this.contactNumber,
      this.maxHeight,
      this.carParkInformation,
      this.accessPinNumber,
      this.accessInformation,
      this.carParkPIN,
      this.id,
      this.priceStartingFrom});

  ParkLaterLocationData.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    nmiSecurityKey = json['nmiSecurityKey'];
    spaces = json['spaces'];
    isCCTV = json['isCCTV'];
    isSecurity = json['isSecurity'];
    eV = json['EV'];
    rV = json['RV'];
    eVType1 = json['EVType1'];
    eVType2 = json['EVType2'];
    eVType3 = json['EVType3'];
    isDeleted = json['isDeleted'];
    photo = json['photo'];
    accountId = json['accountId'];
    carParkName = json['carParkName'];
    email = json['email'];
    addressLineOne = json['addressLineOne'];
    addressLineTwo = json['addressLineTwo'];
    postCode = json['postCode'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    contactPersonName = json['contactPersonName'];
    contactNumber = json['contactNumber'];
    maxHeight = json['maxHeight'];
    priceStartingFrom = json['price_starting_from'].toString();
    country = json['country'];

    carParkInformation = json['carParkInformation'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    carParkPIN = json['carParkPIN'];
    id = json['id'];
  }
}
