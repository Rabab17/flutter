import 'package:flutter/material.dart';
import 'package:flutter_app/model/categorie.dart';
import 'package:flutter_app/screens/nav.dart';
import '../appData.dart';
import '../widget/categore_item.dart';
import 'favor.dart'; // تأكد من استيراد صفحة Favor

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Categorie> favorites = []; // قائمة لتخزين العناصر المفضلة

  void toggleFavorite(Categorie categorie) {
    setState(() {
      if (favorites.any((item) => item.id == categorie.id)) {
        favorites.removeWhere((item) => item.id == categorie.id); // إزالة العنصر إذا كان موجودًا
      } else {
        favorites.add(categorie); // إضافة العنصر إلى المفضلات
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0), // ارتفاع الـ AppBar
        child: Nav(), // استبدال AppBar بالـ Nav
      ),
      body: FutureBuilder<List<Categorie>>(
        future: CategorieService().fetchCategories(), // Fetch categories
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}')); // Error handling
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد فئات متاحة')); // No data message
          }

          final categorieData = snapshot.data!; // Get the fetched data

          // تحديد نسبة العرض إلى الارتفاع بناءً على الحجم
          double aspectRatio = 1;  // القيمة الافتراضية لنسبة العرض إلى الارتفاع
          int crossAxisCount = 2;  // الافتراضي هو عمودين على الموبايل

          // تحديد عدد الأعمدة بناءً على حجم الشاشة
          if (MediaQuery.of(context).size.width > 1200) {
            crossAxisCount = 4;  // للشاشات الكبيرة (desktop)
          } else if (MediaQuery.of(context).size.width > 800) {
            crossAxisCount = 3;  // للأجهزة اللوحية (tablet)
          } else {
            crossAxisCount = 2;  // للموبايل
          }

          // تحديد نسبة العرض إلى الارتفاع بناءً على الحجم
          if (MediaQuery.of(context).size.width > 1200) {
            aspectRatio = 1.2;  // نسبة العرض إلى الارتفاع للأجهزة الكبيرة
          } else if (MediaQuery.of(context).size.width > 800) {
            aspectRatio = 1.3;  // للأجهزة اللوحية
          }

          return Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,  // عدد الأعمدة بناءً على الحجم
                mainAxisSpacing: 10,  // المسافة بين الصفوف
                crossAxisSpacing: 10,  // المسافة بين الأعمدة
                childAspectRatio: aspectRatio,  // نسبة العرض إلى الارتفاع
              ),
              itemCount: categorieData.length, // استخدام الطول الفعلي لقائمة البيانات
              itemBuilder: (BuildContext context, int index) {
                final categorie = categorieData[index]; // أخذ البيانات من القائمة
                return CategoreItem(
                  imgUrl: categorie.imgUrl,
                  name: categorie.name,
                  description: categorie.description, // تمرير الوصف
                  id: categorie.id, // تمرير id إلى CategoreItem
                  onFavoriteToggle: toggleFavorite, // تمرير دالة المفضلات
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Favor page and pass the favorites list
          if (favorites.isNotEmpty) { // تحقق من أن قائمة المفضلات ليست فارغة
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Favor(id: "Favorites", favorites: favorites), // تمرير قائمة المفضلات
              ),
            );
          } else {
            // يمكنك إضافة رسالة تنبيه هنا إذا كانت قائمة المفضلات فارغة
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لا توجد عناصر مفضلة لعرضها!')),
            );
          }
        },
        child: Icon(Icons.favorite), // أيقونة المفضلات
      ),
    );
  }
}