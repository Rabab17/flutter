import 'package:dio/dio.dart';
import 'package:flutter_app/model/confirmPasswordMode.dart';
import 'package:flutter_app/model/logInUser.dart';

var dio = Dio();
String baseURL = "http://192.168.1.5:3001/";

Future<dynamic> confirmPassword(
  ConfirmPasswordModel confirm,
  String token,
) async {
  dynamic message = '';
  try {
    var res = await dio.patch(
      "${baseURL}user/resetPassword/${token}",
      data: confirm.toJson(),
    );
    message = res.data;
    print("the res is ${res} , message is ${message}");

    return message;
  } catch (e) {
    print("the catch from confirmPassword sevices ${e}");
    return "error";
  }
}
