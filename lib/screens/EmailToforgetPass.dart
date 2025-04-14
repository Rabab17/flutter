import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/logInUser.dart';
import 'package:flutter_app/screens/nav.dart';
import 'package:flutter_app/services/forgetPasswordServices.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailtoForgetpass extends StatefulWidget {
  const EmailtoForgetpass({super.key});

  @override
  State<EmailtoForgetpass> createState() => _EmailtoForgetpassState();
}

class _EmailtoForgetpassState extends State<EmailtoForgetpass> {
  final TextEditingController _email = TextEditingController();
  String? emailError;
  bool isVisible = false;
  bool isButtonEnabled = false;
  bool isBold = false;
  dynamic messageFromBackend = '';
  bool loading = true;
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

  Future<void> forgetPasswordUser() async {
    if (validateInputs()) {
      final userModel = LoginUserModel(email: _email.text);

      try {
        var result = await forgetPassword(userModel);
        messageFromBackend = result['message'];
        if (messageFromBackend != null) {
          print("message of forgetPassword in the screen $messageFromBackend");
        } else {
          print("still there is an error");
        }
      } catch (e) {
        print(" the catch of the error in the forget screen $e");
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _email.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = _email.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
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
                "Please Enter A Valid Email To ResetYour Password",
                style: GoogleFonts.lora(
                  color: const Color.fromARGB(255, 93, 4, 4),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            TextFormField(
              controller: _email,
              // maxLength: 10,
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
                            forgetPasswordUser();
                          }
                        }
                        : null,
                // إذا كان غير مفعّل، لا يحدث شيء عند الضغط
                child: Center(
                  child: Text(
                    "Verify Email",
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
