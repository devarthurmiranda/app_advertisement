import 'dart:io';

class Product {
  int? id;
  late String title;
  late String description;
  late String price;
  File? image;

  Product(this.title, this.description, this.price, this.image);

  Product.fromMap(Map map) {
    id = map['id'];
    title = map['title'] ?? 'Default Title';
    description = map['description'] ?? 'Default Description';
    price = map['price'] ?? '0';
    image = map['imagePath'] != null && map['imagePath'] != ''
        ? File(map['imagePath'])
        : null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imagePath': image?.path
    };
  }

  @override
  String toString() {
    return "Product(id: $id, title: $title, description: $description, price: $price, image: $image)";
  }
}
