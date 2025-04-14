import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/logInUser.dart';

var dio = Dio();

String baseURL = "http://192.168.1.4:3001/";

Future<dynamic> loginUser(LoginUserModel user) async {
  dynamic token = '';
  try {
    var res = await dio.post("${baseURL}user/login", data: user.toJson());
    print(res.data);
    token = res.data; // احصل على البيانات من الاستجابة
    // print("the token only ${token['token']}");
    return token;
  } catch (e) {
    print(e);
    return "error";
  }
}
