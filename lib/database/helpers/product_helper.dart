import 'package:app_anuncios/database_helper.dart';
import 'package:app_anuncios/model/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductHelper {
  static final String tableName = 'product';
  static final String idColumn = 'id';
  static final String titleColumn = 'title';
  static final String descriptionColumn = 'description';
  static final String priceColumn = 'price';

  static String get createScript {
    return "CREATE TABLE ${tableName}($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $titleColumn TEXT NOT NULL, $descriptionColumn TEXT NOT NULL, $priceColumn TEXT NOT NULL );";
  }

  Future<Product?> saveProduct(Product product) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      product.id = await db.insert(tableName, product.toMap());
      return product;
    }
    return null;
  }

  Future<List<Product>?> getAll() async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;
    List<Map> returnedProducts = await db.query(tableName,
        columns: [idColumn, titleColumn, descriptionColumn, priceColumn]);
    List<Product> products = List.empty(growable: true);

    for (Map product in returnedProducts) {
      products.add(Product.fromMap(product));
    }

    return products;
  }

  Future<Product?> getById(int id) async {
    Database? db = await DatabaseHelper().db;

    if (db == null) return null;

    List<Map> returnedProduct = await db.query(tableName,
        columns: [idColumn, titleColumn, descriptionColumn, priceColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    return Product.fromMap(returnedProduct.first);
  }

  Future<int?> editProduct(Product product) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db.update(tableName, product.toMap(),
        where: '$idColumn = ?', whereArgs: [product.id]);
  }

  Future<int?> deleteProduct(Product product) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db
        .delete(tableName, where: '$idColumn = ?', whereArgs: [product.id]);
  }
}
