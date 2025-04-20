import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/confirmPasswordMode.dart';
import 'package:flutter_app/screens/nav.dart';
import 'package:flutter_app/services/confirmPasswordServices.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_strength/password_strength.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String tokenFromURL;
  const ConfirmPasswordScreen({super.key, required this.tokenFromURL});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isVisible = false;
  bool isButtonEnabled = false;
  bool isBold = false;
  dynamic messageFromBackend = '';
  bool loading = true;
  String? passwordConfirmError;
  String? passwordError;
  double passwordStrength = 0.0;

  // ----------------------------------------------
  bool validateInputs() {
    bool isValid = true;
    setState(() {
      passwordError = null;
      passwordConfirmError = null;

      if (_password.text.trim().isEmpty) {
        passwordError = "Enter Your New Password";
        isValid = false;
      }

      if (_confirmPassword.text.trim().isEmpty) {
        passwordError = "Please, Confirm Your Password";
        isValid = false;
      }

      if (_confirmPassword.text.trim() != _password.text.trim()) {
        passwordConfirmError = "Password And Confirm Password is not Similar ";
        isValid = false;
      }
    });
    return isValid;
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          _password.text.isNotEmpty && _confirmPassword.text.isNotEmpty;
    });
  }

  void updatePasswordStrength() {
    final strength = estimatePasswordStrength(_password.text);
    setState(() {
      passwordStrength = strength;
    });
  }

  void _showErrorDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: Text("${text}"),
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

  Future<void> confirmPasswordForUser(String token) async {
    if (validateInputs()) {
      final confirm = ConfirmPasswordModel(
        confirmPassword: _confirmPassword.text,
        password: _password.text,
      );

      try {
        var result = await confirmPassword(confirm, token);
        messageFromBackend = result['message'];

        if (messageFromBackend == "Invalid or expired token") {
          _showErrorDialog("Invalid or expired token");
        }

        if (messageFromBackend == "Passwords do not match") {
          _showErrorDialog("Passwords do not match");
        }
      } catch (e) {
        print("the catch from confirmPassword screen:  ${e}");
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      updateButtonState();
      updatePasswordStrength();
    });
    _confirmPassword.addListener(updateButtonState);
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Nav()),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              child: Text(
                "Reset your password",
                style: GoogleFonts.lora(
                  color: const Color.fromARGB(255, 93, 4, 4),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            TextFormField(
              controller: _password,
              obscureText: !isVisible,

              // maxLength: 10,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                errorText: passwordError,
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
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

            TextFormField(
              controller: _confirmPassword,
              obscureText: !isVisible,

              // maxLength: 10,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "confirm password",
                errorText: passwordConfirmError,
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
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
              margin: const EdgeInsets.only(top: 20, bottom: 20),
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

            Container(
              margin: EdgeInsetsDirectional.only(top: 30),
              child: MaterialButton(
                elevation: 15,

                color: const Color(0xFF003B95),
                height: 40,
                disabledColor: Colors.grey, // لون الزر عند التعطيل
                onPressed:
                    isButtonEnabled
                        ? () {
                          if (validateInputs()) {
                            confirmPasswordForUser(widget.tokenFromURL);
                          }
                        }
                        : null,
                // إذا كان غير مفعّل، لا يحدث شيء عند الضغط
                child: Center(
                  child: Text(
                    "Reset password ",
                    style: GoogleFonts.lora(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            !loading
                ? Container(
                  margin: EdgeInsetsDirectional.only(top: 20),
                  child: Text(
                    messageFromBackend,
                    style: GoogleFonts.lora(
                      color: const Color.fromARGB(255, 93, 4, 4),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                : Text(""),
          ],
        ),
      ),
    );
  }
}
