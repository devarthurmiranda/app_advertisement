import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_anuncios/model/product.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price;
      _image = widget.product!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publish Your Product'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(width: 1, color: Colors.grey),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 60,
                color: Colors.grey,
              ),
            ),
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                File image = File(pickedFile.path);
                Directory directory = await getApplicationDocumentsDirectory();
                String _localPath = directory.path;

                String uniqueID = UniqueKey().toString();

                final File savedImage =
                    await image.copy('$_localPath/$uniqueID.png');
                setState(
                  () {
                    _image = savedImage;
                  },
                );
              }
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Added this line
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Product product = Product(
                              _titleController.text,
                              _descriptionController.text,
                              _priceController.text,
                              _image,
                            );
                            Navigator.pop(context, product);
                          }
                        },
                        child: const Text('Publish'),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
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
        ],
      ),
    );
  }
}
