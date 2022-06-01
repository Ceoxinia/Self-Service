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
  final search = null;
  final searchController = TextEditingController();
  List demandes = [];

  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    dynamic results = await readDemande();
    if (results != null) {
      setState(() {
        demandes = results;
      });
    } else {
      print('erreor');
    }
  }

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'format yyyy-mm-jj',
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xfffbb448),
          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: fetchdata,
            )
          ],
        ),
        body: FutureBuilder(
            future: readDemande(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: demandes.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Text(demandes[index]['etat']);
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );

  Future readDemande() async {
    final user = FirebaseAuth.instance.currentUser!;
    List demandes = [];

    final RespoUser = FirebaseFirestore.instance
        .collection('Demande')
        .where('emetteur', isEqualTo: user.uid)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandes.add(element.data()!);
      });
    });

    return demandes;
  }
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
