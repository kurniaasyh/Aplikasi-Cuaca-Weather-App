//======= IMPORTS (LIBRARY & FILE LAIN) =======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/login_page.dart';
import 'pages/search_field.dart';
import 'firebase_options.dart';

//======= FUNGSI UTAMA (MAIN) =======
void main() async {
  // Memastikan binding Flutter sudah siap sebelum inisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  //======= INISIALISASI FIREBASE =======
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //======= MENJALANKAN APLIKASI =======
  runApp(const MyApp());
}

//======= ROOT WIDGET APLIKASI (STATEFUL) =======
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  //======= FUNGSI AKSES STATE =======
  // Digunakan agar widget anak (child) bisa memanggil fungsi di dalam MyAppState
  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

//======= STATE DARI ROOT WIDGET =======
class MyAppState extends State<MyApp> {
  //======= VARIABEL STATE (TEMA) =======
  bool isDarkMode = false;

  //======= FUNGSI MENGUBAH TEMA (TOGGLE) =======
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    //======= KONFIGURASI APLIKASI UTAMA (MATERIAL APP) =======
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //======= KONFIGURASI TEMA GELAP/TERANG =======
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      //======= PENGECEKAN STATUS LOGIN (ROUTING AWAL) =======
      // Jika user sudah login, arahkan ke SearchField. Jika belum, ke LoginPage
      home: FirebaseAuth.instance.currentUser != null
          ? const SearchField()
          : const LoginPage(),
    );
  }
}
