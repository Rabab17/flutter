import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAvatar extends StatefulWidget {
  final String userName;
  const UserAvatar({super.key, required this.userName});

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: 10, top: 20, bottom: 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color.fromARGB(255, 94, 93, 93), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        // alignment: Alignment.bottomLeft,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.black38,
            foregroundColor: Color(0xFF003B95),
            child: Text(
              widget.userName.length >= 2
                  ? widget.userName.substring(0, 2)
                  : widget.userName,
              style: GoogleFonts.lora(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Positioned(
            left: 5,
            bottom: 2,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // لون الخلفية داخل الدائرة
                border: Border.all(
                  color: Colors.white, // لون الإطار
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 25,
                color: Color(0xFF003B95), // لون الأيقونة
              ),
            ),
          ),
        ],
      ),
    );
  }
}
