// class Categorie {
// final String id;
// final String title;
// final String imgUrl;

// const Categorie({ required this.id,required this.imgUrl, required this.title});


// }
class Categorie {
  final String id;
  // final String title;
  final String name; // وصف الموديل
  final String imgUrl; // الصورة
 final String  description; // الصورة
  // كونستراكتور
  const Categorie({
    required this.id,
    
    // required this.title,

    required this.name,
    required this.imgUrl,
    required this.description
  });

  // منطق التحويل من JSON إلى الكائن
  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['_id'], // تأكد من أن الـ API يعيد id بشكل صحيح
      // title: json['name']['en'], // تعديل الحقل بناءً على الحقول المتاحة في الـ API
      name: json['name']['en'], // تعديل الوصف بناءً على الحقول المتاحة في الـ API
      imgUrl: json['images'][0], // إذا كنت ترغب في استخدام الصورة الأولى في الـ API
      description:json['description']['en']
    );
  }
}


