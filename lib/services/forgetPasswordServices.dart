import 'package:dio/dio.dart';
import 'package:flutter_app/model/logInUser.dart';

var dio = Dio();

String baseURL = "http://192.168.1.4:3001/";

Future<dynamic> forgetPassword(LoginUserModel user) async {
  dynamic message = '';

  try {
    var res = await dio.post(
      "${baseURL}user/forgotPassword",
      data: user.toJson(),
    );
    message = res.data;
    print("the res is ${res} , message is ${message}");
    return message;
  } catch (e) {
    print(e);
    throw Exception("an error on the function forget password");
  }
}
