import 'package:flutter/material.dart';
import 'package:flutter_app/screens/loginScreen.dart';
import 'package:flutter_app/services/patchUserDataServices.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class patchUserScren extends StatefulWidget {
  const patchUserScren({super.key, required this.data, required this.id});
  final String data;
  final String id;

  @override
  State<patchUserScren> createState() => _patchUserScrenState();
}

class _patchUserScrenState extends State<patchUserScren> {
  final TextEditingController _dataToPatch = TextEditingController();
  String? dataToPatchError;
  bool isButtonEnabled = false;
  bool isBold = false;
  bool loading = true;
  String messageFromBackend = '';

  bool validateInputs() {
    bool isValid = true;

    setState(() {
      dataToPatchError = null;

      if (_dataToPatch.text.trim().isEmpty) {
        dataToPatchError = "Please enter new data";
        isValid = false;
      }

      if (widget.data == "email" &&
          !_dataToPatch.text.trim().contains(
            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
          )) {
        dataToPatchError = "Please enter a valid email";
        isValid = false;
      }
    });
    return isValid;
  }

  // ========================================
  void _showErrorDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("خطأ"),
          content: Text(text),
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

  // ======================================

  Future<void> patchDataForUser(
    Map<String, dynamic> userData,
    String id,
  ) async {
    if (validateInputs()) {
      try {
        var res = await updateData(userData, id);
        messageFromBackend = res;
        if (messageFromBackend != "Error updating user" &&
            messageFromBackend == "User updated successfully") {
          _showErrorDialog("Your data updated successfully");
        }

        if (messageFromBackend == "No data provided for update") {
          _showErrorDialog("No data provided for update");
        }

        if (messageFromBackend == "User not found") {
          _showErrorDialog("Please Try again");
        }
      } catch (e) {
        print("an error in patch Screen $e");
        throw Exception("an error in patch Screen");
      }
    }
  }

  // ==========================================
  void updateButtonState() {
    setState(() {
      isButtonEnabled = _dataToPatch.text.isNotEmpty;
    });
  }
  // ====================================

  @override
  void initState() {
    super.initState();
    _dataToPatch.addListener(updateButtonState);
  }

  // =====================================
  @override
  void dispose() {
    _dataToPatch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),

        child: Column(
          children: [
            TextFormField(
              controller: _dataToPatch,
              inputFormatters:
                  widget.data == "phoneNumber"
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,

              keyboardType:
                  widget.data == "email"
                      ? TextInputType.emailAddress
                      : widget.data == "phoneNumber"
                      ? TextInputType.phone
                      : TextInputType.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText:
                    widget.data == "email"
                        ? "Email"
                        : widget.data == "phoneNumber"
                        ? "Phone Number"
                        : "user Name",
                errorText: dataToPatchError,
                labelStyle: GoogleFonts.lora(color: const Color(0xFF003B95)),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                  icon:
                      widget.data == "email"
                          ? const Icon(Icons.email_outlined, color: Colors.grey)
                          : widget.data == "phoneNumber"
                          ? const Icon(Icons.phone_android, color: Colors.grey)
                          : const Icon(Icons.person_2, color: Colors.grey),
                ),
              ),
            ),

            // #################################
            SizedBox(height: 25),
            // ##################
            MaterialButton(
              elevation: 15,

              color: const Color(0xFF003B95),
              height: 40,
              disabledColor: Colors.grey, // لون الزر عند التعطيل
              onPressed:
                  isButtonEnabled
                      ? () {
                        if (validateInputs()) {
                          patchDataForUser({
                            widget.data: _dataToPatch.text,
                          }, widget.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                      }
                      : null,
              // إذا كان غير مفعّل، لا يحدث شيء عند الضغط
              child: Center(
                child: Text(
                  "update now",
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
