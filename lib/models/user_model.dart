class UserModel {
  final String id;
  final String fullName;
  final String address;
  final String email;
  final String phone;
  final String altPhone;
  final String verified;
  final String county;

  final String userRole;

  UserModel(
      {this.id,
      this.fullName,
      this.email,
      this.userRole,
      this.altPhone,
      this.phone,
      this.address,
      this.verified,
      this.county});

  UserModel.fromData(Map<String, dynamic> data)
      : id = (data['id'] != null) ? data['id'] : "",
        fullName = data['fullName'] ?? "",
        address = data['address'] ?? "",
        email = data['email'] ?? "",
        phone = data['phone'] ?? "",
        altPhone = data['alt_phone'] ?? "",
        userRole = data['userRole'] ?? "",
        verified = data['verified'] ?? "",
        county = data['county'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'email': email,
      'phone': phone,
      'alt_phone': altPhone,
      'userRole': userRole,
      'verified': verified,
      'county': county
    };
  }
}
