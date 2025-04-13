import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/signUpUser.dart';

var dio = Dio();

String baseURL = "http://192.168.1.4:3001/";

Future<dynamic> signUpUser(SignUpUserModel user) async {
  dynamic token = '';
  try {
    var res = await dio.post("${baseURL}user", data: user.toJson());
    print(res.data);
    token = res.data; // احصل على البيانات من الاستجابة
    // print("the token only ${token['token']}");
    return token;
  } catch (e) {
    print(e);
    return "error";
  }
}
