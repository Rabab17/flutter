import 'package:flutter/material.dart';
import 'package:flutter_app/model/categorie.dart';
import 'package:flutter_app/model/hostByIdModel.dart';
import 'package:flutter_app/screens/favor.dart';
import 'package:flutter_app/screens/footer.dart';
import 'package:flutter_app/screens/nav.dart';
import 'package:flutter_app/services/hostByIdServices.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class details extends StatefulWidget {
  const details({super.key, required this.id});
  final String id;

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  @override
  void initState() {
    super.initState();
    print("the host id is ${widget.id}");
    getOneHost(widget.id); // ← لازم تستدعيها هنا
  }

  late HostByIdModel oneHost;
  bool isLoading = true;
  bool isError = false;
  bool isExpanded = false;
  bool isFav = false;
  List<Categorie> favorites = [];

  void toggleFavorite(Categorie categorie) {
    setState(() {
      if (favorites.any((item) => item.id == categorie.id)) {
        favorites.removeWhere((item) => item.id == categorie.id);
      } else {
        favorites.add(categorie);
      }
    });
  }

  Future<void> getOneHost(id) async {
    try {
      var res = await getHostById(id);
      setState(() {
        oneHost = res;
        isLoading = false;
      });
    } catch (e) {
      print("فشل في تحميل المضيف: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("تفاصيل المضيف")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Nav()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 400,
            child: PageView.builder(
              itemCount: oneHost.images.length,
              controller: PageController(viewportFraction: 0.95),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 15,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            oneHost.images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 9,
                        right: 8,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              isFav = !isFav;
                            });

                            Categorie favoriteItem = Categorie(
                              id: oneHost.id,
                              name: oneHost.name.en,
                              imgUrl: oneHost.images[0],
                              description:
                                  oneHost
                                      .description
                                      .en, // استخدام الوصف الممرر
                            );
                            toggleFavorite(favoriteItem);
                          },
                          icon:
                              !isFav
                                  ? Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey[400],
                                  )
                                  : Icon(Icons.favorite),
                          color: Color(0xFF003B95),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded, color: Color(0xFF003B95)),
                    SizedBox(width: 5),
                    Text(oneHost.location.address.en),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.airline_seat_individual_suite_rounded,
                      color: Color(0xFF003B95),
                    ),
                    SizedBox(width: 5),
                    Text(oneHost.location.country.en),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_city, color: Color(0xFF003B95)),
                    SizedBox(width: 5),
                    Text(oneHost.location.city.en),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(Icons.phone_android_rounded, color: Color(0xFF003B95)),

                    Text("${oneHost.phone}"),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    RatingBarIndicator(
                      rating: 3.5,
                      itemBuilder:
                          (context, index) =>
                              Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 30.0,
                      direction: Axis.horizontal,
                    ),
                    Text("${oneHost.averageRating}"),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: MaterialButton(
                color: Color(0xFF003B95),
                textColor: Colors.white,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Chat With Owner"),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    child: Text(
                      oneHost.name.en,
                      style: GoogleFonts.lora(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(bottom: 10),

                    child: Text(
                      oneHost.subDescription.en,
                      style: GoogleFonts.lora(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                  ),

                  Container(
                    margin: EdgeInsetsDirectional.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          oneHost.description.en,
                          style: GoogleFonts.lora(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: isExpanded ? null : 3,
                          overflow: TextOverflow.fade,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Text(
                              isExpanded ? "عرض أقل" : "عرض المزيد",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (favorites.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => Favor(id: "Favorites", favorites: favorites),
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
