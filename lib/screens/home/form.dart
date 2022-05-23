import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:selfservice/service/ascii_cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// when the infos are valide we send them to the database and as a notification too
class form extends StatefulWidget {
  const form({Key? key}) : super(key: key);

  @override
  State<form> createState() => _formState();
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

  @override
  Widget build(BuildContext context) {
    final detailController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Demande de bon de sortie'),
          centerTitle: true,
          backgroundColor: Color(0xfffbb448),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 15, bottom: 8),
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
                        "BELLAZOUG Zahir",
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    )),

                //if respo or secrt
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
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
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 15),
                  child: Text("Date de Sortie",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                                  maxTime: DateTime.now(), onChanged: (date) {
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
                                      selectedDate.toString().substring(0, 11),
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 106, 104, 104)),
                                    ),
                              trailing: Icon(Icons.calendar_today),
                            )))),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text("Heure de Sortie",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                              DatePicker.showTime12hPicker(context,
                                  showTitleActions: true, onChanged: (heureS) {
                                print('change $heureS in time zone ' +
                                    heureS.timeZoneOffset.inHours.toString());
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
                                      "Veuillez choisir l'heure de sortie",
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
                              trailing: Icon(Icons.schedule),
                            )))),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text("Heure de Retour",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                              DatePicker.showTime12hPicker(context,
                                  showTitleActions: true, onChanged: (heureR) {
                                print('change $heureR in time zone ' +
                                    heureR.timeZoneOffset.inHours.toString());
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
                                      "Veuillez choisir l'heure de retour",
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
                              trailing: Icon(Icons.schedule),
                            )))),

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
                  margin: const EdgeInsets.only(top: 15, left: 25, bottom: 15),
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
                      optionValue: "id",
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 18),
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
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255)
                                ])),
                        child: Text(
                          'Reintialiser',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 140, 0)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate() &&
                            !dateS &&
                            !heureRe &&
                            !heureSo &&
                            !selectedheureR!.isBefore(selectedheureS!) &&
                            detailController.text.trim() != null &&
                            dropdownvalue != "Motif") {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
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
                )
              ],
            )));
  }
}
