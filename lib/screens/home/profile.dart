import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfservice/widget/profileinfo.dart';
import 'package:selfservice/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// still didn't finish the UI and make the secretaire / responsable / personel /directeur difference
class utilisateur extends StatefulWidget {
  utilisateur({Key? key}) : super(key: key);

  @override
  State<utilisateur> createState() => _utilisateurState();
}

class User {
  String uid;
  final String name;
  final String department;
  final String directeur;
  final String responsable;
  final String SON;

  User({
    this.uid = '',
    required this.name,
    required this.department,
    required this.SON,
    required this.directeur,
    required this.responsable,
  });
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'SON': SON,
        'directeur': directeur,
        'responsable': responsable,
        'department': department,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'],
        name: json['name'],
        SON: json['SON'],
        directeur: json['directeur'],
        responsable: json['responsable'],
        department: json['departement'],
      );
}

class _utilisateurState extends State<utilisateur> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile D'utilisateur"),
          centerTitle: true,
          backgroundColor: Color(0xfffbb448),
        ),
        body: StreamBuilder<List<User>>(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went Wrong ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                return ListView(
                  children: users.map(info).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );
  String getInitials(String bankAccountName) => bankAccountName.isNotEmpty
      ? bankAccountName
          .trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join()
      : '';
  Widget info(User user) {
    return Column(children: <Widget>[
      CircleAvatar(
        backgroundColor: Color(0xffe46b10),
        child: Text(getInitials(user.name), style: TextStyle(fontSize: 30)),
        minRadius: 30,
        maxRadius: 50,
      ),
      Center(
          child: ListTile(
        title: Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.SON,
        ),
      ))
    ]);
  }

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('Users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
