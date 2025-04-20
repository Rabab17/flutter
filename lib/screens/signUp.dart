import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screens/EmailToforgetPass.dart';
import 'package:flutter_app/screens/categories_screen.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/model/signUpUser.dart';
import 'package:flutter_app/services/signUpServices.dart';
// --------------------------------------
import 'package:password_strength/password_strength.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();

  bool isVisible = false;
  bool isBold = false;
  bool isButtonEnabled = false; // للتحكم بحالة الزر
  String? usernameError;
  String? emailError;
  double passwordStrength = 0.0;
  bool loading = true;
  dynamic userToken = '';

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

  Future<void> signUpForUser() async {
    if (validateInputs()) {
      final userModel = SignUpUserModel(
        userName: _userName.text,
        email: _email.text,
        password: _password.text,
        phoneNumber: _mobile.text,
      );

      var result = await signUpUser(userModel);
      userToken = result["token"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', userToken);

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
    _userName.addListener(updateButtonState);
    _email.addListener(updateButtonState);

    _password.addListener(() {
      updateButtonState();
      updatePasswordStrength();
    });
    _mobile.addListener(updateButtonState);
  }

  void updatePasswordStrength() {
    final strength = estimatePasswordStrength(_password.text);
    setState(() {
      passwordStrength = strength;
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          _userName.text.isNotEmpty &&
          _password.text.isNotEmpty &&
          _email.text.isNotEmpty &&
          _mobile.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    _email.dispose();
    _mobile.dispose();
    super.dispose();
  }

  bool validateInputs() {
    bool isValid = true;
    setState(() {
      usernameError = null;
      emailError = null;

      // تحقق من username
      if (_userName.text.trim().isEmpty ||
          !_userName.text.trim().contains(RegExp(r'^[a-zA-Z0-9_]+$'))) {
        usernameError = "Username must contain only letters and numbers";
        isValid = false;
      }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            // **************************** حقل اسم المستخدم ****************************
            TextFormField(
              controller: _userName,
              keyboardType: TextInputType.text,
              maxLength: 20,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: usernameError, // ✅ هنا
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                counterText: "${_userName.text.length}/20",
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                  icon: const Icon(
                    Icons.assignment_ind_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            //  *************************** email input *********************************
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
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
              // maxLength: 10,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                // counterText: "${_password.text.length}/10",
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
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: LinearProgressIndicator(
                value: passwordStrength, // القيمة بين 0.0 إلى 1.0
                backgroundColor: Colors.grey[300],
                color:
                    passwordStrength < 0.3
                        ? Colors.red
                        : passwordStrength < 0.7
                        ? Colors.orange
                        : Colors.green,
                minHeight: 8,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // **************************** حقل رقم الهاتف ****************************
            TextFormField(
              controller: _mobile,
              keyboardType: TextInputType.phone,
              maxLength: 20,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                counterText: "${_mobile.text.length}/20",
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                  icon: const Icon(
                    Icons.assignment_ind_outlined,
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
                          signUpForUser();
                        }
                      }
                      : null,
              // إذا كان غير مفعّل، لا يحدث شيء عند الضغط
              child: Center(
                child: Text(
                  "Sign up",
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
                Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    // انتقل إلى صفحة تسجيل الدخول
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
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
