class RegisterAuth {
  String address;
  String companyName;
  String email;
  String landmark;
  String mobNumber;
  String name;
  String pincode;
  String resident;

  RegisterAuth(
      {this.address,
        this.companyName,
        this.email,
        this.landmark,
        this.mobNumber,
        this.name,
        this.pincode,
        this.resident});

  RegisterAuth.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    companyName = json['company_name'];
    email = json['email'];
    landmark = json['landmark'];
    mobNumber = json['mob_number'];
    name = json['name'];
    pincode = json['pincode'];
    resident = json['resident'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['company_name'] = this.companyName;
    data['email'] = this.email;
    data['landmark'] = this.landmark;
    data['mob_number'] = this.mobNumber;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['resident'] = this.resident;
    return data;
  }
}
