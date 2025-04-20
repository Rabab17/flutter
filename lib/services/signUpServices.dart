import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/signUpUser.dart';
import 'baseURLServices.dart';

var dio = Dio();

String baseURL = returnBaseURLFun();

Future<dynamic> signUpUser(SignUpUserModel user) async {
  dynamic token = '';
  try {
    var res = await dio.post("${baseURL}user", data: user.toJson());
    // print("the response from the signup services ${res}");
    token = res.data;
    // print("the token only ${token['token']}");
    return token;
  } catch (e) {
    print(e);
    return "error";
  }
}
