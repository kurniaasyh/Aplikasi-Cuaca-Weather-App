//======= IMPORTS (LIBRARY & HALAMAN LAIN) =======
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search_field.dart';
import 'register_page.dart';

//======= WIDGET HALAMAN LOGIN (STATEFUL) =======
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//======= STATE DARI HALAMAN LOGIN =======
class _LoginPageState extends State<LoginPage> {
  //======= KONTROLER INPUT TEKS =======
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //======= FUNGSI LOGIN DENGAN FIREBASE =======
  Future<void> login() async {
    try {
      // Menjalankan fungsi login dari Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      //======= NAVIGASI KE HALAMAN PENCARIAN (BERHASIL) =======
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SearchField()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      //======= PENANGANAN ERROR (ERROR HANDLING) =======
      String message = "";

      // Menentukan pesan error berdasarkan kode error yang diterima dari Firebase
      if (e.code == 'user-not-found') {
        message = "Email belum terdaftar";
      } else if (e.code == 'wrong-password') {
        message = "Password salah";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid";
      } else {
        message = e.message ?? "Login gagal";
      }

      // Menampilkan pesan error di layar menggunakan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //======= TAMPILAN ANTARMUKA (UI) =======
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        //======= DESAIN LATAR BELAKANG (GRADIENT) =======
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            //======= KOTAK FORM (CARD) =======
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //======= LOGO & TEKS HEADER =======
                    const Icon(
                      Icons.cloud,
                      size: 100,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Masuk untuk melihat cuaca terkini",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //======= INPUT EMAIL =======
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),

                    const SizedBox(height: 15),

                    //======= INPUT PASSWORD =======
                    TextField(
                      controller: passwordController,
                      obscureText: true, // Menyembunyikan teks sandi
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //======= TOMBOL LOGIN =======
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          //======= VALIDASI INPUT KOSONG =======
                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Email dan password wajib diisi",
                                ),
                              ),
                            );
                            return;
                          }

                          // Memanggil fungsi login jika validasi lolos
                          login();
                        },
                        child: const Text("Login"),
                      ),
                    ),

                    //======= TOMBOL MENUJU HALAMAN REGISTER =======
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Belum punya akun? Register",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
