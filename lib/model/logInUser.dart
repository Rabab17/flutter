class LoginUserModel {
  String email;
  String? password; // Make password nullable

  LoginUserModel({required this.email, this.password});

  Map<String, dynamic> toJson() {
    // Only include password if it's not null
    return {'email': email, if (password != null) 'password': password};
  }
}
