class CarParks {
  bool? success;
  String? message;
  List<CarParkData>? carParkData;
  String? errorMessage;

  CarParks({this.success, this.message, this.carParkData, this.errorMessage});

  CarParks.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      carParkData = <CarParkData>[];
      json['data'].forEach((v) {
        carParkData!.add(CarParkData.fromJson(v));
      });
    }
    errorMessage = json['errorMessage'];
  }
}

class CarParkData {
  String? photo;
  bool? isDeleted;
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
  String? carParkInformation;
  int? spaces;
  String? accessPinNumber;
  String? accessInformation;
  String? accountId;
  String? id;
  String? parkingFee;


  CarParkData({
    this.photo,
    this.isDeleted,
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
    this.spaces,
    this.accessPinNumber,
    this.accessInformation,
    this.accountId,
    this.id,
    this.parkingFee,

  });

  CarParkData.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    isDeleted = json['isDeleted'];
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
    spaces = json['spaces'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    accountId = json['accountId'];
    id = json['id'];
    parkingFee = json['parkingFee'].toString();

  }
}
