class ExtendbookingCalculation {
  VatDetails? vatDetails;
  TaxDetails? taxDetails;
  double? taxFee;
  double? vatFee;
  double? smsFee;
  double? serviceFee;
  double? parkingFee;
  double? total;
  double? oldParkingFee;
  double? extraParkingFee;
  double? newTotalParkingFee;
  double? parkingCharges;
  bool? redirectToPaymentGateway;
  String? currency;

  ExtendbookingCalculation(
      {this.vatDetails,
      this.taxDetails,
      this.currency,
      this.taxFee,
      this.vatFee,
      this.smsFee,
      this.serviceFee,
      this.parkingFee,
      this.total,
      this.oldParkingFee,
      this.extraParkingFee,
      this.newTotalParkingFee,
      this.parkingCharges,
      this.redirectToPaymentGateway});

  ExtendbookingCalculation.fromJson(Map<String, dynamic> json) {
    vatDetails = json['vatDetails'] != null
        ? VatDetails.fromJson(json['vatDetails'])
        : null;
    taxDetails = json['taxDetails'] != null
        ? TaxDetails.fromJson(json['taxDetails'])
        : null;
    taxFee = double.parse(json['taxFee'].toString());
    vatFee = double.parse(json['vatFee']);
    smsFee = double.parse(json['smsFee'].toString());
    serviceFee = double.parse(json['serviceFee'].toString());
    parkingFee = double.parse(json['parkingFee'].toString());
    total = double.parse(json['total'].toString());
    currency = json['currency'];
    // ignore: unnecessary_null_in_if_null_operators
    oldParkingFee = double.parse(json['oldParkingFee'].toString());
    extraParkingFee = double.parse(json['extraParkingFee'].toString());
    newTotalParkingFee = double.parse(json['newTotalParkingFee'].toString());
    parkingCharges = double.parse(json['parkingCharges'].toString());
    redirectToPaymentGateway = json['redirectToPaymentGateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vatDetails != null) {
      data['vatDetails'] = vatDetails!.toJson();
    }
    if (taxDetails != null) {
      data['taxDetails'] = taxDetails!.toJson();
    }
    data['taxFee'] = taxFee;
    data['vatFee'] = vatFee;
    data['smsFee'] = smsFee;
    data['serviceFee'] = serviceFee;
    data['parkingFee'] = parkingFee;
    data['total'] = total;
    data['oldParkingFee'] = oldParkingFee;
    data['extraParkingFee'] = extraParkingFee;
    data['newTotalParkingFee'] = newTotalParkingFee;
    data['parkingCharges'] = parkingCharges;
    data['redirectToPaymentGateway'] = redirectToPaymentGateway;
    return data;
  }
}

class VatDetails {
  double? serviceFeeVAT;
  double? parkingFeeVAT;
  double? smsFeeVAT;
  double? totalVATFee;

  VatDetails(
      {this.serviceFeeVAT,
      this.parkingFeeVAT,
      this.smsFeeVAT,
      this.totalVATFee});

  VatDetails.fromJson(Map<String, dynamic> json) {
    serviceFeeVAT = double.parse(json['serviceFeeVAT']);
    parkingFeeVAT = double.parse(json['parkingFeeVAT']);
    smsFeeVAT = double.parse(json['smsFeeVAT']);
    totalVATFee = double.parse(json['totalVATFee']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceFeeVAT'] = serviceFeeVAT;
    data['parkingFeeVAT'] = parkingFeeVAT;
    data['smsFeeVAT'] = smsFeeVAT;
    data['totalVATFee'] = totalVATFee;
    return data;
  }
}

class TaxDetails {
  double? serviceFeeTAX;
  double? parkingFeeTAX;
  double? smsFeeTAX;
  double? totalTAXFee;

  TaxDetails(
      {this.serviceFeeTAX,
      this.parkingFeeTAX,
      this.smsFeeTAX,
      this.totalTAXFee});

  TaxDetails.fromJson(Map<String, dynamic> json) {
    serviceFeeTAX = json['serviceFeeTAX'].toDouble();
    parkingFeeTAX = json['parkingFeeTAX'].toDouble();
    smsFeeTAX = json['smsFeeTAX'].toDouble();
    totalTAXFee = json['totalTAXFee'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceFeeTAX'] = serviceFeeTAX;
    data['parkingFeeTAX'] = parkingFeeTAX;
    data['smsFeeTAX'] = smsFeeTAX;
    data['totalTAXFee'] = totalTAXFee;
    return data;
  }
}
