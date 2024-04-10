import 'package:flutter/material.dart';
import 'package:app_anuncios/model/product.dart';

class InsertProduct extends StatefulWidget {
  final Product? product;
  const InsertProduct({super.key, this.product});

  @override
  State<InsertProduct> createState() => _InsertProductState();
}

class _InsertProductState extends State<InsertProduct> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish Your Product'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Added this line
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Price is required';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Price (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Product product = Product(
                          _titleController.text,
                          _descriptionController.text,
                          _priceController.text,
                        );
                        Navigator.pop(context, product);
                      }
                    },
                    child: const Text('Publish'),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
