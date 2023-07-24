class ParkLaterSingleParkDetails {
  String? nmiSecurityKey;
  int? spaces;
  bool? isCCTV;
  bool? isSecurity;
  bool? isShelter;
  bool? isDisableAcsess;
  bool? isOverNight;
  bool? isWide;
  bool? isHigh;
  bool? isStaff;
  bool? isLift;
  bool? isCongestion;

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
  double? latitude;
  double? longitude;
  String? contactPersonName;
  String? contactNumber;
  String? maxHeight;
  double? parkingFee;
  String? carParkInformation;
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  String? id;

  ParkLaterSingleParkDetails(
      {this.nmiSecurityKey,
      this.spaces,
      this.isCCTV,
      this.isSecurity,
      this.isShelter,
      this.isDisableAcsess,
      this.isOverNight,
      this.isWide,
      this.isHigh,
      this.isStaff,
      this.isLift,
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
      this.parkingFee,
      this.carParkInformation,
      this.accessPinNumber,
      this.accessInformation,
      this.carParkPIN,
      this.isCongestion,
      this.id});

  ParkLaterSingleParkDetails.fromJson(Map<String, dynamic> json) {
    nmiSecurityKey = json['nmiSecurityKey'];
    spaces = json['spaces'];
    isCCTV = json['isCCTV'];
    isSecurity = json['isSecurity'];
    isShelter = json['hasShelter'];
    isDisableAcsess = json['hasDisabledAccess'];
    isOverNight = json['isOverNight'];
    isWide = json['isWide'];
    isHigh = json['isHigh'];
    isStaff = json['hasStaff'];
    isLift = json['hasLift'];
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
    parkingFee = json['parkingFee'];
    carParkInformation = json['carParkInformation'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    carParkPIN = json['carParkPIN'];
    id = json['id'];
    isCongestion = json['isCongestion'];
  }
}
