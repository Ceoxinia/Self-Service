import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  final String x = "";
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: new Text('Liste des demandes'),
          centerTitle: true,
          backgroundColor: Color(0xfffbb448),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        body: StreamBuilder<List<Demande>>(
            stream: readDemandes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went Wrong ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                return ListView();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );

  Stream<List<Demande>> readDemandes() => FirebaseFirestore.instance
      .collection('Demandes')
      .where("uid", isEqualTo: "demande.uid")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Demande.fromJson(doc.data())).toList());
}

class Demande {
  final user = FirebaseAuth.instance.currentUser!;
  String uid;
  final String name;
  final String department;
  final String directeur;
  final String responsable;
  final String SON;

  Demande({
    this.uid = '',
    required this.name,
    required this.department,
    required this.SON,
    required this.directeur,
    required this.responsable,
  });
  Map<String, dynamic> toJson() => {};
  static Demande fromJson(Map<String, dynamic> json) => Demande(
        uid: json['uid'],
        name: json['name'],
        SON: json['SON'],
        directeur: json['directeur'],
        responsable: json['responsable'],
        department: json['departement'],
      );
}
