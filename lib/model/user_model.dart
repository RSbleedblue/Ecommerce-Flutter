class UserModel {
  final String? fullname;
  final String? address;
  final String? phoneNo;
  final String? email;

  UserModel({required this.fullname, required this.address, required this.phoneNo, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'address': address,
      'phoneNo': phoneNo,
      'email': email,
    };
  }
}
