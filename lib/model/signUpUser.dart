class SignUpUserModel {
  String userName;
  String email;
  String? password;
  String? phoneNumber;
  String? id;
  int? iat;
  SignUpUserModel({
    required this.userName,
    required this.email,
    this.password,
    this.phoneNumber,
    this.id,
    this.iat,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      if (password != null) 'password': password,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (id != null) 'id': id,
      if (iat != null) 'iat': iat,
    };
  }
}
