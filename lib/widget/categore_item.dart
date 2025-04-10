import 'package:flutter/material.dart';
import 'package:flutter_app/model/categorie.dart';

class CategoreItem extends StatefulWidget {
  const CategoreItem({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.id, // إضافة id كمعامل
    required this.description, // إضافة الوصف كمعامل
    required this.onFavoriteToggle, // دالة لتحديث المفضلات
  });

  final String name;
  final String imgUrl;
  final String id; // إضافة id كمتغير
  final String description; // إضافة الوصف كمتغير
  final Function(Categorie) onFavoriteToggle; // دالة لتحديث المفضلات

  @override
  _CategoreItemState createState() => _CategoreItemState();
}

class _CategoreItemState extends State<CategoreItem> {
  bool isFavorite = false; // حالة لتتبع ما إذا كانت الأيقونة مفضلة أم لا

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.imgUrl,
              fit: BoxFit.cover,
            ),
          ),
          // خلفية خفيفة خلف النص لتكون مقروءة
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // إضافة أيقونة "المفضلة" في الزاوية العليا
          Positioned(
            top: 8, // Adjusted position
            right: 8, // Adjusted position
            child: GestureDetector( // استخدام GestureDetector
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite; // تغيير حالة الأيقونة عند النقر
                });
                // إنشاء كائن Categorie وإضافته إلى المفضلات
                Categorie favoriteItem = Categorie(
                  id: widget.id,
                  name: widget.name,
                  imgUrl: widget.imgUrl,
                  description: widget.description, // استخدام الوصف الممرر
                );
                widget.onFavoriteToggle(favoriteItem); // تمرير العنصر إلى الدالة
              },
              child: Icon(
                Icons.favorite, // استخدام الأيقونة
                color: isFavorite ? Colors.yellow : Colors.white70.withOpacity(1), // تغيير اللون
              ),
            ),
          ),
        ],
      ),
    );
  }
}