import 'package:flutter/material.dart';
import 'package:flutter_aplikasi_cuaca/pages/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Cuaca"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4facfe),
              Color(0xFF00f2fe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 15,
            shadowColor: Colors.black26,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.cloud, size: 60, color: Colors.blue),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Cari Cuaca",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Masukkan Tempat (Contoh: Jakarta)",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String city = _controller.text.trim();

                        if (city.isNotEmpty) {
                          addHistory(city);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Result(city: city),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Cari Cuaca",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (searchHistory.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: searchHistory.map((city) {
                        return Chip(
                          label: Text(city),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              searchHistory.remove(city);
                              saveHistory();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // 🔹 LOAD dari local storage
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('history') ?? [];
    });
  }

  // 🔹 SIMPAN ke local storage
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', searchHistory);
  }

  // 🔹 Tambah history
  void addHistory(String city) {
    setState(() {
      searchHistory.remove(city);
      searchHistory.insert(0, city);
    });
    saveHistory();
  }

  // 🔹 Hapus history
  void removeHistory(int index) {
    setState(() {
      searchHistory.removeAt(index);
    });
    saveHistory();
  }
}
