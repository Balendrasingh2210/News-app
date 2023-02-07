import 'dart:convert';

class CategoryModel {
  static List<Category> categories = [];
}

class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"],
      name: map["name"],
      imageUrl: map["imageUrl"],
    );
  }

  toMap() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
      };
}
