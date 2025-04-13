class LoginUserModel {
  String email;
  String password;

  LoginUserModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
