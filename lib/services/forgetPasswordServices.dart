import 'package:dio/dio.dart';
import 'package:flutter_app/model/logInUser.dart';
import 'baseURLServices.dart';

var dio = Dio();

String baseURL = returnBaseURLFun();

Future<dynamic> forgetPassword(LoginUserModel user) async {
  dynamic message = '';

  try {
    var res = await dio.post(
      "${baseURL}user/forgotPassword",
      data: user.toJson(),
    );
    message = res.data;
    // print("the res is ${res} , message is ${message}");
    return message;
  } catch (e) {
    print(e);
    throw Exception("an error on the function forget password");
  }
}
