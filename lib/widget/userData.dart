import 'package:flutter/material.dart';
import 'package:flutter_app/screens/patchUserScren.dart';
import 'package:google_fonts/google_fonts.dart';

class UserData extends StatefulWidget {
  const UserData({super.key, required this.myData});
  final myData;

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => patchUserScren(
                            data: "userName",
                            id: widget.myData['id'],
                          ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Color(0xFF003B95), size: 20),
              ),
              SizedBox(width: 25),
              Text(
                "User Name :",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(width: 10),
              Text(
                widget.myData['username'],
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          //  ***********************************
          Divider(color: Color(0xFF003B95), thickness: 2, height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => patchUserScren(
                            data: "phoneNumber",
                            id: widget.myData['id'],
                          ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Color(0xFF003B95), size: 20),
              ),
              SizedBox(width: 25),
              Text(
                "Phone Number",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(width: 15),

              Text(
                widget.myData['phonenumber'],
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),

          //  ***********************************
          Divider(color: Color(0xFF003B95), thickness: 2, height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => patchUserScren(
                            data: "email",
                            id: widget.myData['id'],
                          ),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Color(0xFF003B95), size: 20),
              ),
              SizedBox(width: 25),
              Text(
                "Email",
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(width: 15),

              Text(
                widget.myData['email'],
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsetsDirectional.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MaterialButton(
                //   onPressed: () {},
                //   color: Color(0xFF003B95),
                //   textColor: Colors.white,
                //   child: Row(
                //     children: [
                //       Icon(Icons.edit_note, color: Colors.white, size: 30),
                //       Container(
                //         margin: EdgeInsetsDirectional.only(start: 15),
                //         child: Text(
                //           "Edit My Data",
                //           style: GoogleFonts.lora(
                //             fontSize: 15,
                //             fontWeight: FontWeight.w600,
                //             fontStyle: FontStyle.italic,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 20),
                  child: MaterialButton(
                    onPressed: () {},
                    color: Color.fromARGB(255, 93, 4, 4),
                    textColor: Colors.white,
                    child: Row(
                      children: [
                        Icon(Icons.edit_note, color: Colors.white, size: 30),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 15),
                          child: Text(
                            "Change My Password Only",
                            style: GoogleFonts.lora(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
