//======= IMPORTS (LIBRARY & HALAMAN LAIN) =======
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//======= WIDGET HALAMAN REGISTER (STATEFUL) =======
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//======= STATE DARI HALAMAN REGISTER =======
class _RegisterPageState extends State<RegisterPage> {
  //======= KONTROLER INPUT TEKS =======
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //======= FUNGSI REGISTER DENGAN FIREBASE =======
  Future<void> register() async {
    try {
      // Membuat akun baru di Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //======= UPDATE NAMA PENGGUNA (DISPLAY NAME) =======
      await userCredential.user!.updateDisplayName(
        usernameController.text.trim(),
      );

      if (!mounted) return;

      //======= MENAMPILKAN PESAN SUKSES =======
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Register berhasil"),
        ),
      );

      //======= NAVIGASI KEMBALI KE HALAMAN LOGIN =======
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      //======= PENANGANAN ERROR (ERROR HANDLING) =======
      String message = "";

      // Menentukan pesan error berdasarkan kode error dari Firebase
      if (e.code == 'email-already-in-use') {
        message = "Email sudah digunakan";
      } else if (e.code == 'weak-password') {
        message = "Password minimal 6 karakter";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid";
      } else {
        message = e.message ?? "Register gagal";
      }

      // Menampilkan pesan error
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
                      Icons.person_add,
                      size: 100,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Buat akun baru untuk mulai menggunakan aplikasi",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //======= INPUT USERNAME =======
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15),

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

                    //======= TOMBOL REGISTER =======
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: register, // Memanggil fungsi register
                        child: const Text("Register"),
                      ),
                    ),

                    //======= TOMBOL MENUJU HALAMAN LOGIN =======
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Kembali ke layar sebelumnya (Login)
                      },
                      child: const Text(
                        "Sudah punya akun? Login",
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
