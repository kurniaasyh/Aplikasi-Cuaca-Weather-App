import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Tracking Cuaca",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            children: [
              TextField(decoration: InputDecoration(hintText: "Pasuruan")),
            ],
          ),
        ),
      ),
    );
  }
}
