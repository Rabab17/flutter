import 'package:flutter/material.dart';
import 'package:flutter_app/screens/categories_screen.dart';
import 'package:flutter_app/screens/confirmPasswordScreen.dart';
import 'package:flutter_app/screens/signUp.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (state.matchedLocation.startsWith('/confirmPassword/')) {
        return null;
      }

      // التحقق من وجود التوكن في SharedPreferences (تم تحميله مسبقاً)
      if (token == null || token.isEmpty) {
        return '/signup';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => CategoriesScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(
        path: '/confirmPassword/:token',
        builder: (context, state) {
          final token = state.pathParameters['token'];
          print("TOKEN from URL: $token");
          return ConfirmPasswordScreen(tokenFromURL: token!);
        },
      ),
    ],
  );

  runApp(MyApp(router: _router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Booking',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
    );
  }
}
