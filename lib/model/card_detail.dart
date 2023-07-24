class CardDetail {
  String? id;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? company;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  String? email;
  String? phone;
  String? fax;
  String? ccNumber;
  String? ccHash;
  String? ccExp;
  String? ccStartDate;
  String? ccIssueNumber;
  String? checkAccount;
  String? checkHash;
  String? checkAba;
  String? checkName;
  String? accountHolderType;
  String? accountType;
  String? secCode;
  String? priority;
  String? ccBin;
  String? ccType;
  String? created;
  String? updated;
  String? accountUpdated;
  String? customerVaultId;

  CardDetail(
      {this.id,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.company,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.email,
      this.phone,
      this.fax,
      this.ccNumber,
      this.ccHash,
      this.ccExp,
      this.ccStartDate,
      this.ccIssueNumber,
      this.checkAccount,
      this.checkHash,
      this.checkAba,
      this.checkName,
      this.accountHolderType,
      this.accountType,
      this.secCode,
      this.priority,
      this.ccBin,
      this.ccType,
      this.created,
      this.updated,
      this.accountUpdated,
      this.customerVaultId});

  CardDetail.fromJson(Map<String, dynamic> json) {
    id=json['\$']['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    company = json['company'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    ccNumber = json['cc_number'];
    ccHash = json['cc_hash'];
    ccExp = json['cc_exp'];
    ccStartDate = json['cc_start_date'];
    ccIssueNumber = json['cc_issue_number'];
    checkAccount = json['check_account'];
    checkHash = json['check_hash'];
    checkAba = json['check_aba'];
    checkName = json['check_name'];
    accountHolderType = json['account_holder_type'];
    accountType = json['account_type'];
    secCode = json['sec_code'];
    priority = json['priority'];
    ccBin = json['cc_bin'];
    ccType = json['cc_type'];
    created = json['created'];
    updated = json['updated'];
    accountUpdated = json['account_updated'];
    customerVaultId = json['customer_vault_id'];
  }
}


