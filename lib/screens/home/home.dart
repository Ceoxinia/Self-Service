import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:selfservice/screens/home/dashboard.dart';
import 'package:selfservice/screens/home/form.dart';
import 'package:selfservice/screens/home/history.dart';
import 'package:selfservice/screens/home/notification.dart';
import 'package:selfservice/screens/home/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 0;

  final screens = [
    dashboard(),
    notifications(),
    form(),
    history(),
    utilisateur(),
  ];
  final directeur_screens = [
    dashboard(),
    notifications(),
    history(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xfffbb448),
        buttonBackgroundColor: Color(0xffe46b10),
        height: 60,
        animationDuration: Duration(
          milliseconds: 200,
        ),
        index: index, //.. default start position for icon
        animationCurve: Curves.bounceInOut,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle_outlined,
            size: 30,
            color: Colors.white,
          ),
        ],

        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
