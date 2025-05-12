class PlaceModel {
  String name;
  String address;
  String phoneNumber;
  String description;
  String imageUrl;
  String openingHours;
  int price;
  double rating;
  int rateCount;
  int capacity;

  PlaceModel({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.description,
    required this.imageUrl,
    required this.capacity,
    required this.rating,
    required this.openingHours,
    required this.price,
    required this.rateCount,
  });
  

  
  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "phoneNumber": phoneNumber,
    "description": description,
    "imageUrl": imageUrl,
    "capacity": capacity,
    "rating": rating,
    "openingHours": openingHours,
    "price": price,
    "rateCount": rateCount,
  };

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
    name: json["name"],
    address: json["address"],
    phoneNumber: json["phoneNumber"],
    description: json["description"],
    imageUrl: json["imageUrl"],
    capacity: json["capacity"],
    rating: (json["rating"] as num).toDouble(),
    openingHours: json["openingHours"],
    price: json["price"],
    rateCount: json["rateCount"],
  );
  
}