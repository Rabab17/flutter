class SignUpUserModel {
  String userName;
  String email;
  String password;
  String phoneNumber;

  SignUpUserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
