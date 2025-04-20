import 'package:flutter/material.dart';
import 'package:flutter_app/screens/profileScreen.dart';

class Footer extends StatelessWidget {
  Footer({super.key});

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.search, 'text': 'search', 'rotate': 0.0},
    {'icon': Icons.favorite, 'text': 'favorite', 'rotate': 0.0},
    {'icon': Icons.hotel, 'text': 'Booking', 'rotate': 0.0},
    {'icon': Icons.person_add, 'text': 'person', 'rotate': 0.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF003B95), // خلفية للـ Footer
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // توزيع العناصر بالتساوي
        children: List.generate(items.length, (index) {
          final item = items[index]; // الوصول إلى كل عنصر في الـ List
          return MouseRegion(
            onEnter: (_) {},
            onExit: (_) {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: item['rotate'], // تدوير الأيقونة
                  child: IconButton(
                    icon: Icon(color: Colors.white, size: 30, item['icon']),
                    // الأيقونة
                    onPressed: () {
                      if (item['icon'] == Icons.person_add) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      } else {
                        null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  item['text'], // النص تحت الأيقونة
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
