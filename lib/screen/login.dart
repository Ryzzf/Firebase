import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TampilanLogin extends StatefulWidget {
  const TampilanLogin({super.key});

  @override
  State<TampilanLogin> createState() => _TampilanLoginState();
}

class _TampilanLoginState extends State<TampilanLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //mengecek login logout dan status akun
  final _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Login Gagal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman Log in"),
        backgroundColor: const Color.fromARGB(255, 26, 180, 160),
        ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController
              
              ),
            TextField(
              controller: _passwordController
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _login, 
              child: Text("Login")
              ),
          ],
        ),
      ),
    );
  }
}