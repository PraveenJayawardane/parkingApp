class RecentSearch {
  String? sId;
  String? kewWord;
  String? carParkId;
  String? customerId;
  String? baseURL;
  List<CarPark>? carPark;

  RecentSearch(
      {this.sId,
      this.kewWord,
      this.carParkId,
      this.customerId,
      this.carPark,
      this.baseURL});

  RecentSearch.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    baseURL = json['baseURL'];
    kewWord = json['kewWord'];
    carParkId = json['carParkId'];
    customerId = json['customerId'];

    if (json['carPark'] != null) {
      carPark = <CarPark>[];
      json['carPark'].forEach((v) {
        carPark!.add(CarPark.fromJson(v));
      });
    }
  }
}

class CarPark {
  String? sId;
  String? operatorId;
  int? carParkPIN;
  String? addressLineTwo;
  String? addressLineThree;
  String? postCode;
  String? state;

  String? carParkName;
  String? addressLineOne;
  String? city;
  double? latitude;
  double? longitude;
  String? email;
  String? country;

  CarPark({
    this.sId,
    this.operatorId,
    this.carParkPIN,
    this.addressLineTwo,
    this.addressLineThree,
    this.postCode,
    this.state,
    this.carParkName,
    this.addressLineOne,
    this.city,
    this.latitude,
    this.longitude,
    this.email,
    this.country,
  });

  CarPark.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    operatorId = json['operatorId'];
    carParkPIN = json['carParkPIN'];
    addressLineTwo = json['addressLineTwo'];
    addressLineThree = json['addressLineThree'];
    postCode = json['postCode'];
    state = json['state'];

    carParkName = json['carParkName'];
    addressLineOne = json['addressLineOne'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];

    email = json['email'];

    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['operatorId'] = operatorId;
    data['carParkPIN'] = carParkPIN;
    data['addressLineTwo'] = addressLineTwo;
    data['addressLineThree'] = addressLineThree;
    data['postCode'] = postCode;
    data['state'] = state;

    data['carParkName'] = carParkName;
    data['addressLineOne'] = addressLineOne;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    data['email'] = email;

    data['country'] = country;

    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
