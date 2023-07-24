class DontKnowParkingResult {
  Booking? booking;
  CarPark? carPark;
  Vehicle? vehicle;
  Slot? slot;

  DontKnowParkingResult({this.booking, this.carPark, this.vehicle, this.slot});

  DontKnowParkingResult.fromJson(Map<String, dynamic> json) {
    booking =
        json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    carPark =
        json['carPark'] != null ? new CarPark.fromJson(json['carPark']) : null;
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    slot = json['slot'] != null ? new Slot.fromJson(json['slot']) : null;
  }
}

class Booking {
  String? status;
  String? bookingModule;
  int? bookingEnd;
  int? bookingDraft;
  int? duration;
  double? netParkingFee;
  double? serviceFee;
  double? bookingFee;
  double? totalFee;
  String? parkingType;
  String? transactionId;
  String? authorizationId;
  bool? isDeleted;
  bool? isExtended;
  String? previousBookingId;
  String? vehicleId;
  String? carParkId;
  int? bookingStart;
  String? slotId;
  String? bookingDate;
  String? accountId;
  String? customerId;
  String? bookingId;
  String? id;

  Booking(
      {this.status,
      this.bookingModule,
      this.bookingEnd,
      this.bookingDraft,
      this.duration,
      this.netParkingFee,
      this.serviceFee,
      this.bookingFee,
      this.totalFee,
      this.parkingType,
      this.transactionId,
      this.authorizationId,
      this.isDeleted,
      this.isExtended,
      this.previousBookingId,
      this.vehicleId,
      this.carParkId,
      this.bookingStart,
      this.slotId,
      this.bookingDate,
      this.accountId,
      this.customerId,
      this.bookingId,
      this.id});

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    bookingModule = json['bookingModule'];
    bookingEnd = json['bookingEnd'];
    bookingDraft = json['bookingDraft'];
    duration = json['duration'];
    netParkingFee = json['netParkingFee'];
    serviceFee = json['serviceFee'];
    bookingFee = json['bookingFee'];
    totalFee = json['totalFee'];
    parkingType = json['parkingType'];
    transactionId = json['transactionId'];
    authorizationId = json['authorizationId'];
    isDeleted = json['isDeleted'];
    isExtended = json['isExtended'];
    previousBookingId = json['previousBookingId'];
    vehicleId = json['vehicleId'];
    carParkId = json['carParkId'];
    bookingStart = json['bookingStart'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    accountId = json['accountId'];
    customerId = json['customerId'];
    bookingId = json['bookingId'];
    id = json['id'];
  }
}

class CarPark {
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

  CarPark(
      {this.nmiSecurityKey,
      this.spaces,
      this.isCCTV,
      this.isSecurity,
      this.eV,
      this.rV,
      this.eVType1,
      this.eVType2,
      this.eVType3,
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
      this.parkingFee,
      this.carParkInformation,
      this.accessPinNumber,
      this.accessInformation,
      this.carParkPIN,
      this.id});

  CarPark.fromJson(Map<String, dynamic> json) {
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
  }
}

class Vehicle {
  String? color;
  bool? isForeign;
  bool? isDeleted;
  String? name;
  String? model;
  String? vrn;
  String? customerId;
  String? id;

  Vehicle(
      {this.color,
      this.isForeign,
      this.isDeleted,
      this.name,
      this.model,
      this.vrn,
      this.customerId,
      this.id});

  Vehicle.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isForeign = json['isForeign'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    model = json['model'];
    vrn = json['VRN'];
    customerId = json['customerId'];
    id = json['id'];
  }
}

class Slot {
  bool? isDeleted;
  String? accountId;
  String? carParkId;
  String? slotName;
  String? id;

  Slot(
      {this.isDeleted, this.accountId, this.carParkId, this.slotName, this.id});

  Slot.fromJson(Map<String, dynamic> json) {
    isDeleted = json['isDeleted'];
    accountId = json['accountId'];
    carParkId = json['carParkId'];
    slotName = json['slotName'];
    id = json['id'];
  }
}
