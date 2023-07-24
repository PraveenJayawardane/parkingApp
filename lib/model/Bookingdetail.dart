class BookingDetail {
  String? sId;
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
  Stream? authorizationId;
  bool? isDeleted;
  bool? isExtended;
  String? previousBookingId;
  String? carParkId;
  int? bookingStart;
  String? timeZone;
  String? vehicleId;
  String? slotId;
  String? bookingDate;
  String? accountId;
  String? customerId;
  String? bookingId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? invoiceURL;
  bool? startStopOption;
  List<CarPark>? carPark;
  List<Vehicle>? vehicle;
  List<Slot>? slot;

  BookingDetail(
      {this.sId,
      this.timeZone,
      this.invoiceURL,
      this.startStopOption,
      this.status,
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
      this.carParkId,
      this.bookingStart,
      this.vehicleId,
      this.slotId,
      this.bookingDate,
      this.accountId,
      this.customerId,
      this.bookingId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.carPark,
      this.vehicle,
      this.slot});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    sId = json['id'];
    startStopOption = json['startStopOption'];
    status = json['status'];
    timeZone = json['timeZone'];
    invoiceURL = json['invoiceURL'];
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
    isExtended = json['isExtended'];
    previousBookingId = json['previousBookingId'];
    carParkId = json['carParkId'];
    bookingStart = json['bookingStart'];
    vehicleId = json['vehicleId'];
    slotId = json['slotId'];
    bookingDate = json['bookingDate'];
    accountId = json['accountId'];
    customerId = json['customerId'];
    bookingId = json['bookingId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['carPark'] != null) {
      carPark = <CarPark>[];
      json['carPark'].forEach((v) {
        carPark!.add(CarPark.fromJson(v));
      });
    }
    if (json['vehicle'] != null) {
      vehicle = <Vehicle>[];
      json['vehicle'].forEach((v) {
        vehicle!.add(Vehicle.fromJson(v));
      });
    }
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
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
    data['isExtended'] = isExtended;
    data['previousBookingId'] = previousBookingId;
    data['carParkId'] = carParkId;
    data['bookingStart'] = bookingStart;
    data['vehicleId'] = vehicleId;
    data['slotId'] = slotId;
    data['bookingDate'] = bookingDate;
    data['accountId'] = accountId;
    data['customerId'] = customerId;
    data['bookingId'] = bookingId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (carPark != null) {
      data['carPark'] = carPark!.map((v) => v.toJson()).toList();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.map((v) => v.toJson()).toList();
    }
    if (slot != null) {
      data['slot'] = slot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CarPark {
  String? sId;
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
  String? currency;
  double? latitude;
  double? longitude;
  String? contactPersonName;
  String? contactNumber;
  String? maxHeight;
  List<String>? images;
  String? carParkInformation;
  String? accessPinNumber;
  String? accessInformation;
  int? carParkPIN;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? nmiSecurityKey;
  bool? rV;

  CarPark(
      {this.sId,
      this.currency,
      this.spaces,
      this.images,
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
      this.carParkInformation,
      this.accessPinNumber,
      this.accessInformation,
      this.carParkPIN,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.nmiSecurityKey,
      this.rV});

  CarPark.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images?.add(v);
      });
    }
    currency = json['currency'];
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

    carParkInformation = json['carParkInformation'];
    accessPinNumber = json['accessPinNumber'];
    accessInformation = json['accessInformation'];
    carParkPIN = json['carParkPIN'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    nmiSecurityKey = json['nmiSecurityKey'];
    rV = json['RV'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['spaces'] = spaces;
    data['photo'] = photo;
    data['isDeleted'] = isDeleted;
    data['accountId'] = accountId;
    data['carParkName'] = carParkName;
    data['email'] = email;
    data['addressLineOne'] = addressLineOne;
    data['addressLineTwo'] = addressLineTwo;
    data['postCode'] = postCode;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['contactPersonName'] = contactPersonName;
    data['contactNumber'] = contactNumber;
    data['maxHeight'] = maxHeight;

    data['carParkInformation'] = carParkInformation;
    data['accessPinNumber'] = accessPinNumber;
    data['accessInformation'] = accessInformation;
    data['carParkPIN'] = carParkPIN;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['nmiSecurityKey'] = nmiSecurityKey;
    data['RV'] = rV;
    return data;
  }
}

class Vehicle {
  String? sId;
  String? color;
  bool? isForeign;
  bool? isDeleted;
  String? name;
  String? model;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? vRN;
  String? fuelType;

  Vehicle(
      {this.sId,
      this.color,
      this.isForeign,
      this.isDeleted,
      this.name,
      this.model,
      this.customerId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.vRN,
      this.fuelType});

  Vehicle.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    color = json['color'];
    isForeign = json['isForeign'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    model = json['model'];
    fuelType = json['fuelType'];
    customerId = json['customerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    vRN = json['VRN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['color'] = color;
    data['isForeign'] = isForeign;
    data['isDeleted'] = isDeleted;
    data['name'] = name;
    data['model'] = model;
    data['customerId'] = customerId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['VRN'] = vRN;
    return data;
  }
}

class Slot {
  String? sId;
  bool? isDeleted;
  String? accountId;
  String? carParkId;
  String? slotName;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Slot(
      {this.sId,
      this.isDeleted,
      this.accountId,
      this.carParkId,
      this.slotName,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Slot.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isDeleted = json['isDeleted'];
    accountId = json['accountId'];
    carParkId = json['carParkId'];
    slotName = json['slotName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['isDeleted'] = isDeleted;
    data['accountId'] = accountId;
    data['carParkId'] = carParkId;
    data['slotName'] = slotName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
