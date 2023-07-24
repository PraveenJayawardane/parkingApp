class User {
  String? profilePicture;
  bool? isActive;
  bool? otpVerified;
  bool? tfaEnable;
  bool? isGuest;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? id;
  String? token;
  String? customerVaultId;
  String? countryCode;

  User(
      {this.profilePicture,
      this.isActive,
      this.countryCode,
      this.otpVerified,
      this.tfaEnable,
      this.firstName,
      this.isGuest,
      this.lastName,
      this.email,
      this.mobileNumber,
      this.id,
      this.customerVaultId,
      this.token});

  User.fromJson(Map<String, dynamic> json, String tkn) {
    profilePicture = json['profilePicture'];
    countryCode = json['countryCode'];
    isActive = json['isActive'];
    otpVerified = json['otpVerified'];
    tfaEnable = json['tfaEnable'];
    isGuest = json['isGuest'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    id = json['id'];
    customerVaultId = json['customerVaultId'];
    token = tkn;
  }
}
