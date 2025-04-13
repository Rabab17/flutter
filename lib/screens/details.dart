import 'package:flutter/material.dart';
import 'package:flutter_app/model/hostByIdModel.dart';
import 'package:flutter_app/screens/nav.dart';
import 'package:flutter_app/services/hostByIdServices.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      oneHost.images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
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
                      "${oneHost.name.en}",
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
                      "${oneHost.subDescription.en}",
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

                    child: Text(
                      "${oneHost.description.en}",
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 100,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
