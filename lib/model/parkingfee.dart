class ParkingFee {
  bool? success;
  String? message;
  ParkingDetails? data;
  String? errorMessage;

  ParkingFee({this.success, this.message, this.data, this.errorMessage});

  ParkingFee.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ParkingDetails.fromJson(json['data']) : null;
    errorMessage = json['errorMessage'];
  }
}

class ParkingDetails {
  Carpark? carpark;
  Price? price;
  String? slotID;

  ParkingDetails({this.carpark, this.price, this.slotID});

  ParkingDetails.fromJson(Map<String, dynamic> json) {
    carpark =
        json['carpark'] != null ? Carpark.fromJson(json['carpark']) : null;
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    slotID = json['slotID'];
  }
}

class Carpark {
  int? spaces;
  String? photo;
  bool? isDeleted;
  String? accountId;
  String? carParkName;
  String? email;
  String? addressLineOne;
  String? addressLineTwo;
  String? postCode;
  String? city;
  double? latitude;
  double? longitude;
  String? contactPersonName;
  String? contactNumber;
  String? maxHeight;
  String? currency;
  String? carParkInformation;
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  String? id;

  Carpark(
      {this.spaces,
      this.photo,
      this.currency,
      this.isDeleted,
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
      this.id});

  Carpark.fromJson(Map<String, dynamic> json) {
    spaces = json['spaces'];
    currency = json['currency'];
    photo = json['photo'];
    isDeleted = json['isDeleted'];
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

    carParkInformation = json['carParkInformation'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    carParkPIN = json['carParkPIN'];
    id = json['id'];
  }
}

class Price {
  double? serviceFee;

  double? parkingFee;

  double? total;

  Price({this.parkingFee, this.serviceFee, this.total});

  Price.fromJson(Map<String, dynamic> json) {
    serviceFee = json['serviceFee'].toDouble();
    parkingFee = json['parkingFee'].toDouble();
    total = json['total'].toDouble();
  }
}
