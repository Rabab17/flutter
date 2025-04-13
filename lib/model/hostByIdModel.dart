// To parse this JSON data, do
//
//     final hostByIdModel = hostByIdModelFromJson(jsonString);

import 'dart:convert';

HostByIdModel hostByIdModelFromJson(String str) =>
    HostByIdModel.fromJson(json.decode(str));

String hostByIdModelToJson(HostByIdModel data) => json.encode(data.toJson());

class HostByIdModel {
  Description name;
  Description description;
  Description subDescription;
  HouseRules houseRules;
  Location location;
  String id;
  String ownerId;
  int phone;
  List<String> images;
  int averageRating;
  int reviewCount;
  bool approved;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  bool isDisabled;

  HostByIdModel({
    required this.name,
    required this.description,
    required this.subDescription,
    required this.houseRules,
    required this.location,
    required this.id,
    required this.ownerId,
    required this.phone,
    required this.images,
    required this.averageRating,
    required this.reviewCount,
    required this.approved,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isDisabled,
  });

  factory HostByIdModel.fromJson(Map<String, dynamic> json) => HostByIdModel(
    name: Description.fromJson(json["name"]),
    description: Description.fromJson(json["description"]),
    subDescription: Description.fromJson(json["subDescription"]),
    houseRules: HouseRules.fromJson(json["HouseRules"]),
    location: Location.fromJson(json["location"]),
    id: json["_id"],
    ownerId: json["ownerId"],
    phone: json["phone"],
    images: List<String>.from(json["images"].map((x) => x)),
    averageRating: json["AverageRating"],
    reviewCount: json["ReviewCount"],
    approved: json["approved"],
    createdAt: DateTime.parse(json["CreatedAt"]),
    updatedAt: DateTime.parse(json["UpdatedAt"]),
    v: json["__v"],
    isDisabled: json["isDisabled"],
  );

  Map<String, dynamic> toJson() => {
    "name": name.toJson(),
    "description": description.toJson(),
    "subDescription": subDescription.toJson(),
    "HouseRules": houseRules.toJson(),
    "location": location.toJson(),
    "_id": id,
    "ownerId": ownerId,
    "phone": phone,
    "images": List<dynamic>.from(images.map((x) => x)),
    "AverageRating": averageRating,
    "ReviewCount": reviewCount,
    "approved": approved,
    "CreatedAt": createdAt.toIso8601String(),
    "UpdatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "isDisabled": isDisabled,
  };
}

class Description {
  String en;
  String ar;

  Description({required this.en, required this.ar});

  factory Description.fromJson(Map<String, dynamic> json) =>
      Description(en: json["en"], ar: json["ar"]);

  Map<String, dynamic> toJson() => {"en": en, "ar": ar};
}

class HouseRules {
  Cancellation cancellation;
  bool noSmoking;
  bool noPets;
  bool noParties;
  String checkInTime;
  String checkOutTime;
  int pricePerNight;

  HouseRules({
    required this.cancellation,
    required this.noSmoking,
    required this.noPets,
    required this.noParties,
    required this.checkInTime,
    required this.checkOutTime,
    required this.pricePerNight,
  });

  factory HouseRules.fromJson(Map<String, dynamic> json) => HouseRules(
    cancellation: Cancellation.fromJson(json["Cancellation"]),
    noSmoking: json["NoSmoking"],
    noPets: json["NoPets"],
    noParties: json["NoParties"],
    checkInTime: json["CheckInTime"],
    checkOutTime: json["CheckOutTime"],
    pricePerNight: json["PricePerNight"],
  );

  Map<String, dynamic> toJson() => {
    "Cancellation": cancellation.toJson(),
    "NoSmoking": noSmoking,
    "NoPets": noPets,
    "NoParties": noParties,
    "CheckInTime": checkInTime,
    "CheckOutTime": checkOutTime,
    "PricePerNight": pricePerNight,
  };
}

class Cancellation {
  Description policy;
  bool refundable;
  int deadlineDays;

  Cancellation({
    required this.policy,
    required this.refundable,
    required this.deadlineDays,
  });

  factory Cancellation.fromJson(Map<String, dynamic> json) => Cancellation(
    policy: Description.fromJson(json["Policy"]),
    refundable: json["Refundable"],
    deadlineDays: json["DeadlineDays"],
  );

  Map<String, dynamic> toJson() => {
    "Policy": policy.toJson(),
    "Refundable": refundable,
    "DeadlineDays": deadlineDays,
  };
}

class Location {
  Description address;
  Description city;
  Description country;

  Location({required this.address, required this.city, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: Description.fromJson(json["Address"]),
    city: Description.fromJson(json["city"]),
    country: Description.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "Address": address.toJson(),
    "city": city.toJson(),
    "country": country.toJson(),
  };
}
