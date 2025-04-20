import 'package:flutter/material.dart';
import 'package:flutter_app/model/signUpUser.dart';
import 'package:flutter_app/screens/nav.dart';
import 'package:flutter_app/widget/userAvatar.dart';
import 'package:flutter_app/widget/userData.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var decodedToken = SignUpUserModel(userName: '', email: '').toJson();
  bool loading = true;
  // ----------------------------------------------------
  Future<void> decodeToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString('token');

      if (savedToken != null) {
        decodedToken = JwtDecoder.decode(savedToken);
        print("saved token in profile screen: $savedToken");
        print("decoded token is: $decodedToken");
        setState(() {
          loading = false;
        });
      } else {
        throw Exception("error in decoding the token");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    decodeToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Nav()),
      body: Center(
        child:
            loading
                ? CircularProgressIndicator()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserAvatar(userName: decodedToken["username"]),
                    UserData(myData: decodedToken),
                  ],
                ),
      ),
    );
  }
}
