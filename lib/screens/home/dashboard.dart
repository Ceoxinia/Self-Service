import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class dashboard extends StatelessWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // here you write the codes to input the data into firestor

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        centerTitle: true,
        backgroundColor: Color(0xfffbb448),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          )
        ],
      ),
      body: ListView(children: [
        Text(user.uid),
      ]),
    );
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
