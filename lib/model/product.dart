import 'dart:io';

class Product {
  int? id;
  late String title;
  late String description;
  late String price;

  Product(this.title, this.description, this.price);

  Product.fromMap(Map map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price
    };
    return map;
  }

  @override
  String toString() {
    return "Product(id: $id, title: $title, description: $description, price: $price)";
  }
}
