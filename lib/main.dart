import 'package:app_anuncios/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Product Store',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      useMaterial3: false,
    ),
    home: const MainPage(),
  ));
}
