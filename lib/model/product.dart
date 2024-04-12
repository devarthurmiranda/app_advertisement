import 'dart:io';

class Product {
  int? id;
  late String title;
  late String description;
  late String price;
  late File? image;

  Product(this.title, this.description, this.price, this.image);

  Product.fromMap(Map map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    price = map['price'];
    image = map['imagePath'] != '' ? File(map['imagePath']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imagePath': image?.path
    };
    return map;
  }

  @override
  String toString() {
    return "Product(id: $id, title: $title, description: $description, price: $price, image: $image)";
  }
}
