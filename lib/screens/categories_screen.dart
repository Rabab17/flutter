import 'package:flutter/material.dart';
import 'package:flutter_app/model/categorie.dart';
import 'package:flutter_app/screens/footer.dart';
import 'package:flutter_app/screens/nav.dart';
import '../appData.dart';
import '../widget/categore_item.dart';
import 'favor.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({super.key});

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Categorie> favorites = [];
  int? hoveredIndex;

  // تعريف العناصر بشكل صحيح مع تحديد نوع البيانات
  final List<Map<String, dynamic>> items = [
    {'icon': Icons.bed, 'text': 'status', 'rotate': 0.0},
    {'icon': Icons.flight, 'text': 'flight', 'rotate': 1.6},
    {'icon': Icons.car_crash, 'text': 'car', 'rotate': 0.0},
  ];

  void toggleFavorite(Categorie categorie) {
    setState(() {
      if (favorites.any((item) => item.id == categorie.id)) {
        favorites.removeWhere((item) => item.id == categorie.id);
      } else {
        favorites.add(categorie);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: Nav(),
      ),
      body: SizedBox(
        height: 800,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.all(0),
              color: Color(0xFF003B95),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: List.generate(items.length, (index) {
                  final hovered = hoveredIndex == index;
                  final item = items[index];

                  return MouseRegion(
                    onEnter: (_) => setState(() => hoveredIndex = index),
                    onExit: (_) => setState(() => hoveredIndex = null),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 50),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(40),
                        border: hovered
                            ? Border.all(color: Colors.white.withOpacity(0.5), width: 2)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: item['rotate'],
                            child: Icon(
                              item['icon'],
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            item['text'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Categorie>>(
                future: CategorieService().fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('حدث خطأ: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('لا توجد فئات متاحة'));
                  }

                  final categorieData = snapshot.data!;

                  int crossAxisCount = 2;
                  if (MediaQuery.of(context).size.width > 1200) {
                    crossAxisCount = 4;
                  } else if (MediaQuery.of(context).size.width > 800) {
                    crossAxisCount = 3;
                  }

                  return Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(10),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: categorieData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final categorie = categorieData[index];
                        return CategoreItem(
                          imgUrl: categorie.imgUrl,
                          name: categorie.name,
                          description: categorie.description,
                          id: categorie.id,
                          onFavoriteToggle: toggleFavorite,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Footer()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (favorites.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Favor(id: "Favorites", favorites: favorites),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لا توجد عناصر مفضلة لعرضها!')),
            );
          }
        },
        child: Icon(Icons.favorite),
      ),


    );
  }
}
