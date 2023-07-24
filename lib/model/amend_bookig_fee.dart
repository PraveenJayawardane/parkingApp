class Amendbookigfee {
  double? serviceFee;
  double? parkingFee;
  double? total;
  double? oldParkingPrice;
  double? extraParkingFee;
  double? newparkingPrice;
  bool? redirectToPaymentGateway;

  Amendbookigfee(
      {this.serviceFee,
      this.parkingFee,
      this.total,
      this.oldParkingPrice,
      this.extraParkingFee,
      this.newparkingPrice,
      this.redirectToPaymentGateway});

  Amendbookigfee.fromJson(Map<String, dynamic> json) {
    serviceFee = json['serviceFee'].toDouble();
    parkingFee = json['parkingFee'].toDouble();
    total = json['total'].toDouble();
    oldParkingPrice = json['oldParkingPrice'].toDouble();
    extraParkingFee = json['extraParkingFee'].toDouble();
    newparkingPrice = json['newparkingPrice'].toDouble();
    redirectToPaymentGateway = json['redirectToPaymentGateway'];
  }
}
