import 'package:flutter/material.dart';
import 'package:flutter_app/screens/categories_screen.dart';
import 'package:flutter_app/screens/signUp.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> getInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // تحقق إذا كان فيه توكن
    if (token != null && token.isNotEmpty) {
      return CategoriesScreen();
    } else {
      return SignupScreen(); // أو LoginScreen() لو عندك شاشة تسجيل دخول منفصلة
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // عرض شاشة تحميل مؤقتة أثناء انتظار SharedPreferences
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const SignupScreen(); // احتياطيًا
          }
        },
      ),
    );
  }
}
