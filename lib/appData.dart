// import 'package:flutter_app/model/categorie.dart';

// const categorieData = [
//   Categorie(
//     id: 'c1',
//     title: 'الآثار',
//     imgUrl: 'https://images.unsplash.com/photo-1549880338-65ddcdfd017b',
//   ),
//   Categorie(
//     id: 'c2',
//     title: 'الشواطئ',
//     imgUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
//   ),
//   Categorie(
//     id: 'c3',
//     title: 'الجبال',
//     imgUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
//   ),

//   Categorie(
//     id: 'c6',
//     title: 'الأنهار',
//     imgUrl: 'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
//   ),
//   Categorie(
//     id: 'c7',
//     title: 'البحيرات',
//     imgUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
//   ),
//   Categorie(
//     id: 'c8',
//     title: 'الغابات',
//     imgUrl: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
//   ),
//   Categorie(
//     id: 'c9',
//     title: 'الكهوف',
//     imgUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7',
//   ),
//   Categorie(
//     id: 'c10',
//     title: 'الجزر',
//     imgUrl: 'https://images.unsplash.com/photo-1504457046789-9c1d8b7981e1',
//   ),
//   Categorie(
//     id: 'c11',
//     title: 'القرى الريفية',
//     imgUrl: 'https://images.unsplash.com/photo-1562422551-06f0c2f07516',
//   ),
//   Categorie(
//     id: 'c12',
//     title: 'المدن القديمة',
//     imgUrl: 'https://images.unsplash.com/photo-1504197885-5e77f5289cdd',
//   ),
//   Categorie(
//     id: 'c13',
//     title: 'الأسواق الشعبية',
//     imgUrl: 'https://images.unsplash.com/photo-1603727721167-c3e4c5b62fd3',
//   ),
//   Categorie(
//   id: 'c14',
//   title: 'المنتجعات',
//   imgUrl: 'https://cdn.pixabay.com/photo/2016/11/29/09/08/beach-1867271_1280.jpg',
// ),
// Categorie(
//   id: 'c15',
//   title: 'المرتفعات',
//   imgUrl: 'https://cdn.pixabay.com/photo/2016/09/12/20/32/mountains-1667285_1280.jpg',
// ),
// Categorie(
//   id: 'c16',
//   title: 'السواحل الصخرية',
//   imgUrl: 'https://cdn.pixabay.com/photo/2018/04/07/16/49/rocks-3291684_1280.jpg',
// ),
// Categorie(
//   id: 'c17',
//   title: 'المتاحف',
//   imgUrl: 'https://cdn.pixabay.com/photo/2016/01/19/17/50/louvre-1149413_1280.jpg',
// ),
// Categorie(
//   id: 'c18',
//   title: 'القصور',
//   imgUrl: 'https://cdn.pixabay.com/photo/2017/02/01/22/02/palace-2034926_1280.jpg',
// ),
// Categorie(
//   id: 'c19',
//   title: 'المعابد',
//   imgUrl: 'https://cdn.pixabay.com/photo/2018/10/01/21/00/temple-3712541_1280.jpg',
// ),
// Categorie(
//   id: 'c20',
//   title: 'الحدائق الوطنية',
//   imgUrl: 'https://cdn.pixabay.com/photo/2015/06/19/21/24/avenue-815297_1280.jpg',
// ),

// ];
import 'package:dio/dio.dart';
import 'package:flutter_app/model/categorie.dart';

class CategorieService {
  final String apiUrl = 'http://192.168.1.5:3001/host';

  Future<List<Categorie>> fetchCategories() async {
    try {
      // استخدام Dio لجلب البيانات
      final response = await Dio().get(apiUrl); // استخدم Dio بدلاً من http

      if (response.statusCode == 200) {
        // print("response1 $response");
        // إذا كانت الاستجابة ناجحة
        List<dynamic> data = response.data; // بيانات الـ API
        return data.skip(3).map((item) => Categorie.fromJson(item)).toList();
      } else {
        print("error");
        throw Exception('فشل في تحميل البيانات');
      }
    } catch (e) {
      print("error ");
      throw Exception('حدث خطأ: $e');
    }
  }
}
