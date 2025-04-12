import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/categorie.dart';
import 'package:flutter_app/screens/nav.dart'; // تأكد من استيراد نموذج Categorie

class Favor extends StatefulWidget {
  final String id;
  final List<Categorie> favorites; // قائمة لتخزين العناصر المفضلة

  const Favor({Key? key, required this.id, required this.favorites}) : super(key: key);

  @override
  _FavorState createState() => _FavorState();
}

class _FavorState extends State<Favor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0), // ارتفاع الـ AppBar
        child: Nav(), // استبدال AppBar بالـ Nav
      ),
      body: ListView.builder(
        itemCount: widget.favorites.length, // عدد العناصر المفضلة
        itemBuilder: (context, index) {
          final categorie = widget.favorites[index]; // الحصول على العنصر المفضل
          return Card(
            margin: EdgeInsets.all(8),
            child: Column( // استخدام Column لعرض الصورة والنص
              children: [
                // الصورة تأخذ عرض الـ Card بالكامل
                Container(
                  width: double.infinity, // عرض الصورة بالكامل
                  height: 150, // تحديد ارتفاع الصورة
                  child: Image.network(
                    categorie.imgUrl,
                    // fit: BoxFit.cover, 
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('خطأ في تحميل الصورة')); // رسالة عند حدوث خطأ في تحميل الصورة
                    },
                  ),
                ),
                // النص تحت الصورة
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categorie.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4), // مسافة بين الاسم والوصف
                      Text(
                        categorie.description,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}