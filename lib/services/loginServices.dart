import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/logInUser.dart';
import 'baseURLServices.dart';

var dio = Dio();

String baseURL = returnBaseURLFun();

Future<dynamic> loginUser(LoginUserModel user) async {
  dynamic token = '';
  try {
    var res = await dio.post("${baseURL}user/login", data: user.toJson());
    // print(res.data);
    token = res.data;
    return token;
  } catch (e) {
    print("an error in login sevices ${e}");
    return "error";
  }
}
