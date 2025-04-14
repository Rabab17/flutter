import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/logInUser.dart';
import 'package:flutter_app/screens/EmailToforgetPass.dart';
import 'package:flutter_app/screens/categories_screen.dart';
import 'package:flutter_app/screens/signUp.dart';
import 'package:flutter_app/services/loginServices.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  bool isVisible = false;
  bool isButtonEnabled = false;
  String? emailError;
  bool loading = true;
  dynamic userToken = '';
  bool isBold = false;

  // ----------------------------------------------
  bool validateInputs() {
    bool isValid = true;
    setState(() {
      emailError = null;

      // تحقق من الإيميل
      if (_email.text.trim().isEmpty ||
          !_email.text.trim().contains(
            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
          )) {
        emailError = "Enter a valid email address";
        isValid = false;
      }
    });
    return isValid;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: Text("يرجى إدخال بيانات صحيحة."),
          actions: <Widget>[
            TextButton(
              child: Text("موافق"),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق التنبيه
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logInForUser() async {
    if (validateInputs()) {
      final userModel = LoginUserModel(
        email: _email.text,
        password: _password.text,
      );

      var result = await loginUser(userModel);
      userToken = result;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', userToken);

      String? savedToken = prefs.getString('token');

      if (savedToken != null) {
        print("Logged in with saved token in preferences : $savedToken");
      }

      setState(() {
        loading = false;
      });

      print("user token in the login page $userToken");
      // يمكنك إضافة منطق للتحقق من نجاح عملية التسجيل هنا
      if (userToken != "error") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesScreen()),
        );
      } else {
        _showErrorDialog();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _email.addListener(updateButtonState);
    _password.addListener(() {
      updateButtonState();
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _email.text.isNotEmpty && _password.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            //  *************************** email input *********************************
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "Email",
                errorText: emailError,
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                  icon: const Icon(Icons.email_outlined, color: Colors.grey),
                ),
              ),
            ),

            // **************************** حقل كلمة المرور ****************************
            TextFormField(
              controller: _password,
              obscureText: !isVisible,
              keyboardType: TextInputType.visiblePassword,
              maxLength: 10,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.next,

              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                counterText: "${_password.text.length}/10",
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            // **************************** زر تسجيل الدخول ****************************
            MaterialButton(
              elevation: 15,

              color: const Color(0xFF003B95),
              height: 40,
              disabledColor: Colors.grey, // لون الزر عند التعطيل
              onPressed:
                  isButtonEnabled
                      ? () {
                        if (validateInputs()) {
                          logInForUser();
                        }
                      }
                      : null,
              // إذا كان غير مفعّل، لا يحدث شيء عند الضغط
              child: Center(
                child: Text(
                  "Log in",
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // مسافة بين الزر والنصوص
            // السطر الأول: لديك حساب بالفعل؟ تسجيل الدخول
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Donot an account? "),
                GestureDetector(
                  onTap: () {
                    // انتقل إلى صفحة تسجيل الدخول
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10), // مسافة بسيطة بين السطرين
            // السطر الثاني: هل نسيت كلمة المرور؟
            GestureDetector(
              onTap: () {
                // انتقل إلى صفحة نسيان كلمة المرور
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailtoForgetpass()),
                );
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
