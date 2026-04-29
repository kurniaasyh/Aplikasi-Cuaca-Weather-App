import 'package:flutter/material.dart';
import 'package:flutter_aplikasi_cuaca/pages/search_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // warning text color
          centerTitle: true,
        ),
      ),
      home: const SearchField(),
    );
  }
}
