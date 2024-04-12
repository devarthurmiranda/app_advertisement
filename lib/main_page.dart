import 'package:app_anuncios/database/helpers/product_helper.dart';
import 'package:flutter/material.dart';
import 'package:app_anuncios/insert_product_page.dart';
import 'package:app_anuncios/model/product.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> _products = [];
  final ProductHelper _helper = ProductHelper();

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((data) {
      setState(() {
        if (data != null) _products = data;
      });
    });
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        Product? editedProduct = await Navigator.push(
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
                      leading: product.image != null
                          ? CircleAvatar(
                              child: ClipOval(
                                child: Image.file(product.image!),
                              ),
                            )
                          : const SizedBox(),
                      title: Text(_products[index].title),
                      subtitle: Text(_products[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'R\$ ${_products[index].price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onLongPress: () async {
                        final Uri params = Uri(
                            scheme: 'sms',
                            path: '+5511999999999',
                            queryParameters: {
                              'body':
                                  '$_products[index].title - R\$ ${_products[index].price}'
                            });
                        final url = params.toString();
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
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
            Product? savedProduct = await _helper.saveProduct(newProduct!);
            if (savedProduct != null) {
              setState(() {
                _products.add(newProduct);
                const snackbar = SnackBar(content: Text('Product saved!'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            }
          } catch (e) {
            throw Exception('Error saving product: $e');
          }
        },
        child: const Icon(Icons.shopping_bag),
      ),
    );
  }
}
