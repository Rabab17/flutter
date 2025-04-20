import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter_app/model/signUpUser.dart';
import 'baseURLServices.dart';

var dio = Dio();

String baseURL = returnBaseURLFun();

Future<dynamic> updateData(Map<String, dynamic> user, String id) async {
  dynamic bachendMessage = '';

  try {
    var res = await dio.patch("${baseURL}user/UpdateData/$id", data: user);
    // print(res.data);
    bachendMessage = res.data;
    return bachendMessage;
  } catch (e) {
    print("an error in patchdata sevices $e");
    return "error";
  }
}
