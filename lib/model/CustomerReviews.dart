class CustomerReviews {
  List<Review>? review;

  CustomerReviews({this.review});

  CustomerReviews.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      review = <Review>[];
      json['data'].forEach((v) {
        review!.add(Review.fromJson(v));
      });
    }
  }
}

class Review {
  String? sId;
  String? review;
  int? rating;
  String? createDate;
  bool? isApproved;
  String? carParkId;
  String? customerId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Customer>? customer;

  Review(
      {this.sId,
        this.review,
        this.rating,
        this.createDate,
        this.isApproved,
        this.carParkId,
        this.customerId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.customer});

  Review.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    review = json['review'];
    rating = json['rating'];
    createDate = json['createDate'];
    isApproved = json['isApproved'];
    carParkId = json['carParkId'];
    customerId = json['customerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['customer'] != null) {
      customer = <Customer>[];
      json['customer'].forEach((v) {
        customer!.add(new Customer.fromJson(v));
      });
    }
  }
}

class Customer {
  String? sId;
  String? profilePicture;
  bool? isActive;
  bool? otpVerified;
  bool? tfaEnable;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? mobileNumber;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Customer(
      {this.sId,
        this.profilePicture,
        this.isActive,
        this.otpVerified,
        this.tfaEnable,
        this.firstName,
        this.lastName,
        this.email,
        this.password,
        this.mobileNumber,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Customer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profilePicture = json['profilePicture'];
    isActive = json['isActive'];
    otpVerified = json['otpVerified'];
    tfaEnable = json['tfaEnable'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    password = json['password'];
    mobileNumber = json['mobileNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profilePicture'] = this.profilePicture;
    data['isActive'] = this.isActive;
    data['otpVerified'] = this.otpVerified;
    data['tfaEnable'] = this.tfaEnable;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobileNumber'] = this.mobileNumber;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
