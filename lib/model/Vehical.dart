class Vehicles {
  bool? success;
  String? message;
  List<Vehicle>? data;
  String? errorMessage;

  Vehicles({this.success, this.message, this.data, this.errorMessage});

  Vehicles.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Vehicle>[];
      json['data'].forEach((v) {
        data!.add(Vehicle.fromJson(v));
      });
    }
    errorMessage = json['errorMessage'];
  }
}

class Vehicle {
  String? color;
  bool? isForeign;
  bool? isDeleted;
  String? name;
  String? model;
  String? vRN;
  String? customerId;
  String? id;
  String? fuelType;
  String? baseURL;

  Vehicle(
      {this.color,
      this.isForeign,
      this.isDeleted,
      this.name,
      this.baseURL,
      this.model,
      this.vRN,
      this.customerId,
      this.id,
      this.fuelType});

  Vehicle.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isForeign = json['isForeign'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    model = json['model'];
    vRN = json['VRN'];
    customerId = json['customerId'];
    id = json['id'];
    fuelType = json['fuelType'];
    baseURL = json['baseURL'];
  }
}
