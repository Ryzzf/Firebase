import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TampilanHome extends StatelessWidget {
  const TampilanHome({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Beranda"
          ),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(), 
            icon: Icon(Icons.logout_outlined)
            )
        ],
      ),
      body: Center(
        child: Text(
          "Selamat Datang ${user?.email ?? "Pengguna"}"
        ),
      ),
    );
  }
}
