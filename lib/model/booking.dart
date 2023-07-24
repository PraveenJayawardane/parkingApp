class Booking {
  String? status;
  String? bookingEnd;
  int? bookingDraft;
  int? duration;
  String? timeZone;
  double? netParkingFee;
  double? serviceFee;
  double? bookingFee;
  double? totalFee;
  String? parkingType;
  String? transactionId;
  String? authorizationId;
  bool? isDeleted;
  String? carParkId;
  String? bookingStart;
  String? slotId;
  String? bookingDate;
  String? accountId;
  String? customerId;
  String? bookingId;
  String? vehicleId;
  String? id;
  Carpark? carpark;
  Vehicle? vehicle;

  Booking(
      {this.status,
      this.bookingEnd,
      this.timeZone,
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
      this.carParkId,
      this.bookingStart,
      this.slotId,
      this.bookingDate,
      this.accountId,
      this.customerId,
      this.bookingId,
      this.vehicleId,
      this.id,
      this.carpark,
      this.vehicle});

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    bookingEnd = json['bookingEnd'];
    timeZone = json['timeZone'];
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
    carParkId = json['carParkId'];
    bookingStart = json['bookingStart'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    accountId = json['accountId'];
    customerId = json['customerId'];
    bookingId = json['bookingId'];
    vehicleId = json['vehicleId'];
    id = json['id'];
    carpark =
        json['carpark'] != null ? new Carpark.fromJson(json['carpark']) : null;
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['bookingEnd'] = this.bookingEnd;
    data['bookingDraft'] = this.bookingDraft;
    data['duration'] = this.duration;
    data['netParkingFee'] = this.netParkingFee;
    data['serviceFee'] = this.serviceFee;
    data['bookingFee'] = this.bookingFee;
    data['totalFee'] = this.totalFee;
    data['parkingType'] = this.parkingType;
    data['transactionId'] = this.transactionId;
    data['authorizationId'] = this.authorizationId;
    data['isDeleted'] = this.isDeleted;
    data['carParkId'] = this.carParkId;
    data['bookingStart'] = this.bookingStart;
    data['slotId'] = this.slotId;
    data['bookingDate'] = this.bookingDate;
    data['accountId'] = this.accountId;
    data['customerId'] = this.customerId;
    data['bookingId'] = this.bookingId;
    data['vehicleId'] = this.vehicleId;
    data['id'] = this.id;
    if (this.carpark != null) {
      data['carpark'] = this.carpark!.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    return data;
  }
}

class Carpark {
  String? nmiSecurityKey;
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
  double? parkingFee;
  String? carParkInformation;
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  String? id;

  Carpark(
      {this.nmiSecurityKey,
      this.spaces,
      this.photo,
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

  Carpark.fromJson(Map<String, dynamic> json) {
    nmiSecurityKey = json['nmiSecurityKey'];
    spaces = json['spaces'];
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
    parkingFee = json['parkingFee'];
    carParkInformation = json['carParkInformation'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    carParkPIN = json['carParkPIN'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nmiSecurityKey'] = this.nmiSecurityKey;
    data['spaces'] = this.spaces;
    data['photo'] = this.photo;
    data['isDeleted'] = this.isDeleted;
    data['accountId'] = this.accountId;
    data['carParkName'] = this.carParkName;
    data['email'] = this.email;
    data['addressLineOne'] = this.addressLineOne;
    data['addressLineTwo'] = this.addressLineTwo;
    data['postCode'] = this.postCode;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['contactPersonName'] = this.contactPersonName;
    data['contactNumber'] = this.contactNumber;
    data['maxHeight'] = this.maxHeight;
    data['parkingFee'] = this.parkingFee;
    data['carParkInformation'] = this.carParkInformation;
    data['accessPinNumber'] = this.accessPinNumber;
    data['accessInformation'] = this.accessInformation;
    data['carParkPIN'] = this.carParkPIN;
    data['id'] = this.id;
    return data;
  }
}

class Vehicle {
  String? color;
  bool? isForeign;
  bool? isDeleted;
  Null? name;
  String? model;
  String? customerId;
  String? vRN;
  String? id;

  Vehicle(
      {this.color,
      this.isForeign,
      this.isDeleted,
      this.name,
      this.model,
      this.customerId,
      this.vRN,
      this.id});

  Vehicle.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isForeign = json['isForeign'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    model = json['model'];
    customerId = json['customerId'];
    vRN = json['VRN'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['isForeign'] = this.isForeign;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['model'] = this.model;
    data['customerId'] = this.customerId;
    data['VRN'] = this.vRN;
    data['id'] = this.id;
    return data;
  }
}
