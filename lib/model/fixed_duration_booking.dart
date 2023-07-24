class FixedDurationbooking {
  Booking? booking;
  CarPark? carPark;
  Vehicle? vehicle;
  Slot? slot;

  FixedDurationbooking({this.booking, this.carPark, this.vehicle, this.slot});

  FixedDurationbooking.fromJson(Map<String, dynamic> json) {
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    carPark =
        json['carPark'] != null ? CarPark.fromJson(json['carPark']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    slot = json['slot'] != null ? Slot.fromJson(json['slot']) : null;
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
  String? timeZone;
  String? carParkId;
  int? bookingStart;
  String? vehicleId;
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
      this.vehicleId,
      this.slotId,
      this.bookingDate,
      this.accountId,
      this.customerId,
      this.bookingId,
      this.id});

  Booking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timeZone = json['timeZone'];
    bookingModule = json['bookingModule'];
    bookingEnd = json['bookingEnd'];
    bookingDraft = json['bookingDraft'];
    duration = json['duration'];
    netParkingFee = json['netParkingFee'];
    serviceFee = json['serviceFee'].toDouble();
    bookingFee = json['bookingFee'];
    totalFee = json['totalFee'].toDouble();
    parkingType = json['parkingType'];
    transactionId = json['transactionId'];
    authorizationId = json['authorizationId'];
    isDeleted = json['isDeleted'];
    carParkId = json['carParkId'];
    bookingStart = json['bookingStart'];
    vehicleId = json['vehicleId'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    accountId = json['accountId'];
    customerId = json['customerId'];
    bookingId = json['bookingId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['bookingModule'] = bookingModule;
    data['bookingEnd'] = bookingEnd;
    data['bookingDraft'] = bookingDraft;
    data['duration'] = duration;
    data['netParkingFee'] = netParkingFee;
    data['serviceFee'] = serviceFee;
    data['bookingFee'] = bookingFee;
    data['totalFee'] = totalFee;
    data['parkingType'] = parkingType;
    data['transactionId'] = transactionId;
    data['authorizationId'] = authorizationId;
    data['isDeleted'] = isDeleted;
    data['carParkId'] = carParkId;
    data['bookingStart'] = bookingStart;
    data['vehicleId'] = vehicleId;
    data['slotId'] = slotId;
    data['bookingDate'] = bookingDate;
    data['accountId'] = accountId;
    data['customerId'] = customerId;
    data['bookingId'] = bookingId;
    data['id'] = id;
    return data;
  }
}

class CarPark {
  String? nmiSecurityKey;
  int? spaces;
  String? photo;
  bool? isDeleted;
  String? accountId;
  String? carParkName;
  String? email;
  String? currency;
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
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  List<String>? images;
  String? id;

  CarPark(
      {this.nmiSecurityKey,
      this.currency,
      this.spaces,
      this.photo,
      this.images,
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

  CarPark.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    nmiSecurityKey = json['nmiSecurityKey'];
    spaces = json['spaces'];
    photo = json['photo'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images?.add(v);
      });
    }
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

class Vehicle {
  String? color;
  bool? isForeign;
  bool? isDeleted;
  String? name;
  String? model;
  String? customerId;
  String? vRN;
  String? id;
  String? fuelType;

  Vehicle(
      {this.color,
      this.isForeign,
      this.isDeleted,
      this.name,
      this.model,
      this.customerId,
      this.vRN,
      this.id,
      this.fuelType});

  Vehicle.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isForeign = json['isForeign'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    model = json['model'];
    customerId = json['customerId'];
    vRN = json['VRN'];
    id = json['id'];
    fuelType = json['fuelType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['isForeign'] = isForeign;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['model'] = model;
    data['customerId'] = customerId;
    data['VRN'] = vRN;
    data['id'] = id;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDeleted'] = isDeleted;
    data['accountId'] = accountId;
    data['carParkId'] = carParkId;
    data['slotName'] = slotName;
    data['id'] = id;
    return data;
  }
}
