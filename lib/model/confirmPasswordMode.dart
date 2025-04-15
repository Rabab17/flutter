class ConfirmPasswordModel {
  String confirmPassword;
  String password;

  ConfirmPasswordModel({required this.confirmPassword, required this.password});

  Map<String, dynamic> toJson() {
    return {'confirmPassword': confirmPassword, 'password': password};
  }
}
