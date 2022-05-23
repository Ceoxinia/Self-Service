import 'package:flutter/material.dart';
import 'package:selfservice/widget/notif.dart';

class notifications extends StatelessWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Color(0xfffbb448),
      ),
      body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
        notif("Maroua KHEMISSI", "New", "17/10/2022", "Demande"),
        notif("GUELLAB Serine", "no", "12/10/2022", "Reponse"),
        notif("DEBBAH Halima", "no", "10/10/2022", "Demande"),
        notif("Chouaib KHEMISSI", "no", "09/10/2022", "Reponse"),
      ]),
    );
  }
}
