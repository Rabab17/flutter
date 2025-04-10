import 'package:flutter/material.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    double aspectRatio = 1.5;
    int crossAxisCount = 2;

    if (MediaQuery.of(context).size.width > 1200) {
      crossAxisCount = 4;
      aspectRatio = 1.3;
    } else if (MediaQuery.of(context).size.width > 800) {
      crossAxisCount = 3;
      aspectRatio = 1.4;
    }

    return SafeArea(
      child: SingleChildScrollView( // ✅ عشان يمنع الoverflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF003B95),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking.com",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, color: Colors.white),
                        radius: 20,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Status", style: TextStyle(fontSize: 18, color: Colors.red,)),
            ),
              SizedBox(height: 20),
          
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Row(
            //     children: [
            //       Text("status",style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //         ),),
            //       Text("status",style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //         ),),
            //       Text("status",style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //         ),),
            //       Text("status",style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //         ),)



                 
                
                 
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
