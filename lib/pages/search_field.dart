import 'package:flutter/material.dart';
import 'package:flutter_aplikasi_cuaca/pages/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_aplikasi_cuaca/pages/login_page.dart';
import 'package:flutter_aplikasi_cuaca/main.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Cuaca"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              MyApp.of(context).isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              MyApp.of(context).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 15,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ICON
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cloud,
                            size: 70,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // WELCOME
                      Center(
                        child: Text(
                          "Selamat datang, ${user?.displayName ?? 'User'}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // TITLE
                      const Center(
                        child: Text(
                          "Cari Cuaca",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SEARCH FIELD
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Masukkan kota...",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.location_city,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
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
                          child: const Text(
                            "Cari Cuaca",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // HISTORY TITLE
                      if (searchHistory.isNotEmpty) ...[
                        const Text(
                          "History Pencarian",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // HISTORY WRAP
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: searchHistory.take(10).map((city) {
                            return Chip(
                              backgroundColor: Colors.blue.shade50,
                              label: Text(
                                city,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
        ),
      ),
    );
  }

  // 🔹 LOAD FIRESTORE
  Future<void> loadHistory() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('time', descending: true)
        .get();

    setState(() {
      searchHistory =
          snapshot.docs.map((doc) => doc['city'].toString()).toList();
    });
  }

  // 🔹 SAVE LOCAL
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'history',
      searchHistory,
    );
  }

  // 🔹 ADD HISTORY
  void addHistory(String city) async {
    setState(() {
      searchHistory.remove(city);

      searchHistory.insert(0, city);
    });

    saveHistory();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('history')
            .add({
          'city': city,
          'time': Timestamp.now(),
        });

        debugPrint(
          "BERHASIL SIMPAN FIRESTORE",
        );
      } catch (e) {
        debugPrint(
          "ERROR FIRESTORE: $e",
        );
      }
    }
  }

  // 🔹 REMOVE HISTORY
  void removeHistory(int index) {
    setState(() {
      searchHistory.removeAt(index);
    });

    saveHistory();
  }
}
