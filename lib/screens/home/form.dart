import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:selfservice/service/ascii_cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// when the infos are valide we send them to the database and as a notification too
class form extends StatefulWidget {
  const form({Key? key}) : super(key: key);

  @override
  State<form> createState() => _formState();
}

class Demande {
  String id;
  final user = FirebaseAuth.instance.currentUser!;

  final String emetteur;

  final String etat;
  final String wilaya;
  final String commune;
  final String detail;
  final String dateS;
  final String heureS;
  final String heureR;
  final String motif;

  Demande({
    this.id = '',
    required this.etat,
    required this.wilaya,
    required this.commune,
    required this.detail,
    required this.dateS,
    required this.heureS,
    required this.heureR,
    required this.motif,
    required this.emetteur,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'emetteur': user.uid,
        'etat': etat,
        'dateS': dateS,
        'heureR': heureR,
        'heureS': heureS,
        'motif': motif,
        'detail': detail,
        'commune': commune,
        'wilaya': wilaya,
      };
  static Demande fromJson(Map<String, dynamic> json) => Demande(
        id: json['id'],
        etat: json['SON'],
        wilaya: json['directeur'],
        commune: json['responsable'],
        detail: json['departement'],
        dateS: json['departement'],
        heureS: json['departement'],
        motif: json['departement'],
        heureR: json['departement'],
        emetteur: json['emetteur'],
      );
}

class _formState extends State<form> {
  String dropdownvalue = 'Motif';

  // List of items in our dropdown menu
  var items = [
    'Motif',
    'Personelle',
    'Travail',
  ];
  String? countryId;
  String? stateId;
  List<dynamic> states = [];
  bool heureSo = true;
  bool heureRe = true;
  bool dateS = true;
  DateTime? selectedDate;
  DateTime? selectedheureS;
  DateTime? selectedheureR;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference demandes =
        FirebaseFirestore.instance.collection('demandes');

    final detailController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text('Demande', textScaleFactor: 1),
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                    )),
                    backgroundColor: Color.fromARGB(255, 255, 220, 178),
                    expandedHeight: 240,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(
                        'assets/head.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
            body: Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Après avoir rempli ce formulaire, La réponse de votre demande vous sera transmise par mail",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -0.5),
                      ),
                    ),

                    Container(
                      margin:
                          const EdgeInsets.only(left: 25, top: 15, bottom: 8),
                      child: Text("Votre Directeur",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 213, 213),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 18,
                                  color: Colors.black45,
                                  spreadRadius: -8)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(
                            "",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        )),

                    //if respo or secrt
                    Container(
                      margin:
                          const EdgeInsets.only(left: 25, top: 15, bottom: 10),
                      child: Text("Votre Responsable",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 213, 213),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 18,
                                  color: Colors.black45,
                                  spreadRadius: -8)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(
                            "DERRASCHOCK Abdeldjalil",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        )),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 15),
                      child: Text("Date de Sortie",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 245, 245),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black45,
                                      spreadRadius: -8)
                                ],
                                borderRadius: BorderRadius.circular(16)),
                            child: TextButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(const Duration(hours: 72)),
                                      maxTime: DateTime.now(),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    selectedDate = date;
                                    this.dateS = false;
                                    setState(() {});
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.fr);
                                },
                                child: ListTile(
                                  title: dateS
                                      ? Text(
                                          'Date de Sortie',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 106, 104, 104)),
                                        )
                                      : Text(
                                          selectedDate
                                              .toString()
                                              .substring(0, 11),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 106, 104, 104)),
                                        ),
                                  trailing: Icon(Icons.calendar_today,
                                      color: Colors.orange),
                                )))),

                    Container(
                      child: Text("Heure de Sortie",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 245, 245),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black45,
                                        spreadRadius: -8)
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: TextButton(
                                  onPressed: () {
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        onChanged: (heureS) {
                                      print('change $heureS in time zone ' +
                                          heureS.timeZoneOffset.inHours
                                              .toString());
                                    }, onConfirm: (heureS) {
                                      print('confirm $heureS');
                                      selectedheureS = heureS;
                                      this.heureSo = false;
                                      setState(() {});
                                    }, currentTime: selectedDate);
                                  },
                                  child: ListTile(
                                    title: heureSo
                                        ? Text(
                                            "Heure Sortie",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 106, 104, 104)),
                                          )
                                        : Text(
                                            selectedheureS
                                                .toString()
                                                .substring(10, 16),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 106, 104, 104)),
                                          ),
                                    trailing: Icon(Icons.schedule,
                                        color: Colors.orange),
                                  ))),
                          Container(
                              width: MediaQuery.of(context).size.width / 2 - 30,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 245, 245),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black45,
                                        spreadRadius: -8)
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: TextButton(
                                  onPressed: () {
                                    DatePicker.showTime12hPicker(context,
                                        showTitleActions: true,
                                        onChanged: (heureR) {
                                      print('change $heureR in time zone ' +
                                          heureR.timeZoneOffset.inHours
                                              .toString());
                                    }, onConfirm: (heureR) {
                                      print('confirm $heureR');
                                      selectedheureR = heureR;
                                      this.heureRe = false;
                                      setState(() {});
                                    }, currentTime: selectedDate);
                                  },
                                  child: ListTile(
                                    title: heureRe
                                        ? Text(
                                            "Heure Reto",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 106, 104, 104)),
                                          )
                                        : Text(
                                            selectedheureR
                                                .toString()
                                                .substring(10, 16),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 106, 104, 104)),
                                          ),
                                    trailing: Icon(Icons.schedule,
                                        color: Colors.orange),
                                  ))),
                        ]),

                    Container(
                      margin: const EdgeInsets.only(left: 25, bottom: 15),
                      child: Text("Wilaya",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 248, 245, 245),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  color: Colors.black45,
                                  spreadRadius: -8)
                            ],
                            borderRadius: BorderRadius.circular(16)),
                        child: FormHelper.dropDownWidget(
                          context,
                          "Wilaya",
                          this.countryId,
                          wilaya,
                          (onChangedVal) {
                            this.countryId = onChangedVal;
                            this.states = algeria_cites
                                .where((stateItem) =>
                                    stateItem["wilaya_code"] == onChangedVal)
                                .toList();
                            this.stateId = null;
                            setState(() {});
                          },
                          (onValidateVal) {},
                          borderColor: Color.fromARGB(255, 248, 245, 245),
                          borderFocusColor: Color.fromARGB(255, 248, 245, 245),
                          borderRadius: 20,
                          optionValue: "wilaya_code",
                          optionLabel: "wilaya_name",
                          paddingBottom: 16.0,
                          paddingTop: 16.0,
                          paddingLeft: 8.0,
                          paddingRight: 8.0,
                          borderWidth: 0.0,
                        )),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 25, bottom: 15),
                      child: Text("Commune",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 248, 245, 245),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  color: Colors.black45,
                                  spreadRadius: -8)
                            ],
                            borderRadius: BorderRadius.circular(16)),
                        child: FormHelper.dropDownWidget(
                          context,
                          "Commune",
                          this.stateId,
                          this.states,
                          (onChangedVal) {
                            this.stateId = onChangedVal;
                          },
                          (onValidateVal) {},
                          optionValue: "commune_name",
                          optionLabel: "commune_name",
                          paddingBottom: 16.0,
                          paddingTop: 16.0,
                          paddingLeft: 8.0,
                          paddingRight: 8.0,
                          borderColor: Color.fromARGB(255, 248, 245, 245),
                          borderFocusColor: Color.fromARGB(255, 248, 245, 245),
                        )),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 16),
                      child: Text("Motif",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 18),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 248, 245, 245),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 12,
                                      color: Colors.black45,
                                      spreadRadius: -8)
                                ],
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ))),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 16),
                      child: Text("Details",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 18),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 248, 245, 245),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 12,
                                  color: Colors.black45,
                                  spreadRadius: -8)
                            ],
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextField(
                            controller: detailController,
                            maxLines: 8, //or null
                            decoration: InputDecoration.collapsed(
                                hintText: "veuillez fournir les details ici"),
                          ),
                        )),

                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate() &&
                            !dateS &&
                            !heureRe &&
                            !heureSo &&
                            !selectedheureR!.isBefore(selectedheureS!) &&
                            detailController.text.trim() != null &&
                            dropdownvalue != "Motif") {
                          creerDemande(
                              'en attente',
                              countryId!,
                              stateId!,
                              selectedheureS.toString()!,
                              selectedheureR.toString()!,
                              selectedDate.toString()!,
                              dropdownvalue,
                              detailController.text.trim());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Votre demande a ete envoyee')),
                          );
                        } else {
                          if (dateS ||
                              heureRe ||
                              heureSo ||
                              detailController.text.trim() == null ||
                              dropdownvalue == "Motif") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Veuillez remplire toutes les champs')),
                            );
                          } else {
                            if (selectedheureR!.isBefore(selectedheureS!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Erreur dans l'heure")),
                              );
                            }
                          }
                        }
                        ;
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xfffbb448),
                                  Color(0xfff7892b)
                                ])),
                        child: Text(
                          'Valider',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  Future creerDemande(String etat, String wilaya, String Commune, String HeureS,
      String HeureR, String dateS, String motif, String detail) async {
    // Call the user's CollectionReference to add a new user
    final docUser = FirebaseFirestore.instance.collection('Demande').doc();
    final demande = Demande(
      id: docUser.id,
      etat: etat,
      wilaya: wilaya,
      commune: Commune,
      heureR: HeureR,
      heureS: HeureS,
      dateS: dateS,
      motif: motif,
      detail: detail,
      emetteur: user.uid,
    );
    final json = demande.toJson();
    await docUser.set(json);
  }
}
