import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter_app/model/hostByIdModel.dart';
import 'baseURLServices.dart';

var dio = Dio();

String baseURL = returnBaseURLFun();

Future<HostByIdModel> getHostById(String id) async {
  // HostByIdModel host;

  try {
    var res = await dio.get("${baseURL}host/${id}");
    // print(res.data);
    if (res.data is Map<String, dynamic>) {
      HostByIdModel host = HostByIdModel.fromJson(res.data);
      return host;
    } else {
      throw Exception("البيانات المستلمة ليست بصيغة JSON متوقعة");
    }
  } catch (e) {
    print(e);
    return throw Exception("فشل في جلب بيانات المضيف");
  }
}
