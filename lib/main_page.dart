import 'package:flutter/material.dart';
import 'package:app_anuncios/insert_product_page.dart';
import 'package:app_anuncios/model/product.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everything Store'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Added this line
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: 80,
              height: 80,
              child: const Image(
                image: AssetImage('images/homePageImgOne.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Your Publications',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              // Wrapped ListView with Expanded to occupy remaining space
              child: ListView.separated(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  Product product = _products[index];
                  return Dismissible(
                    key: Key(product.title),
                    background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.edit, color: Colors.white)),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        Product editedProduct = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InsertProduct(
                              product: _products[index],
                            ),
                          ),
                        );
                        if (editedProduct != null) {
                          setState(() {
                            _products[index] = editedProduct;
                          });
                        }
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        return true;
                      }
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        setState(() {
                          _products.removeAt(index);
                        });
                      }
                    },
                    child: ListTile(
                        leading: const Image(
                          image: AssetImage('images/product.png'),
                          width: 50,
                          height: 50,
                        ),
                        title: Text(_products[index].title),
                        subtitle: Text(_products[index].description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'R\$ ${_products[index].price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Product? newProduct = await Navigator.push<Product?>(
              context,
              MaterialPageRoute(builder: (context) => const InsertProduct()),
            );
            if (newProduct != null) {
              setState(() {
                _products.add(newProduct);
              });
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.shopping_bag),
      ),
    );
  }
}
