import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final tugas = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void tambahtugas() {
    //Membaca akun yang login terbaru
    final user = auth.currentUser;
    // kondisi ada akun dan data tidak kosong
    if (user != null && tugas.text.isNotEmpty) {
      firestore
      .collection('users')
      .doc(user.uid)
      .collection('TodoList')
      .add({
        'Tugas': tugas.text,
        'CreateAt': Timestamp.now(),
      });
      tugas.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Beranda"
          ),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('TodoList')
                  .orderBy('CreateAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(
                    "data kosong")
                    );
                }

                final doc = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.note),
                        title: Text(doc[index]['Tugas']),
                        trailing: IconButton(
                          onPressed: () => doc[index].reference.delete(),
                          icon: Icon(Icons.delete_forever),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tugas,
                    decoration: InputDecoration(
                      labelText: "Masukan tugas"
                      ),
                  ),
                ),

                IconButton(
                  onPressed: tambahtugas, 
                  icon: Icon(Icons.send)
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}