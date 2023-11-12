import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/examun.dart';
import 'package:quickalert/quickalert.dart';
import '../../utils.dart';
import '../lists/listexamun.dart';
import 'package:intl/intl.dart';
class ExamunForm extends StatefulWidget {
  final Examun examun;
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  ExamunForm({Key? key, required this.examun,required this.accessToken,required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  _ExamunFormState createState() => _ExamunFormState();
}

class _ExamunFormState extends State<ExamunForm> {
  DateTime dateTime = DateTime.now();
  TextEditingController idController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController heure_debController =new TextEditingController();
  TextEditingController heure_finController = new TextEditingController();
  TextEditingController id_matController = new TextEditingController();
  TextEditingController id_salController = new TextEditingController();
  TextEditingController id_jourController = new TextEditingController();
  FocusNode type = FocusNode();
  FocusNode id_mat = FocusNode();
  FocusNode heure_deb = FocusNode();
  FocusNode heure_fin = FocusNode();
  FocusNode id_sal = FocusNode();
  FocusNode id_jour = FocusNode();
  String? selectedOption1;
  String? selectedOption2;
  String? selectedOption3;
  String? selectedOption4;
  List<String> matiereList = [];
  List<String> salleList = [];
  List<String> jourList = [];
  List<String> typeList = [
    "Devoir",
    "Examun",
    "Session",
  ];
  @override
  void initState() {
    super.initState();
    fetchMatieres(widget.nomfil).then((_) {
      setState(() {
        if (widget.examun.salle != '' && widget.examun.matiere!='' &&  widget.examun.type!=null &&  widget.examun.jour!=''&& widget.examun.date_deb!=DateTime.parse('0000-00-00 00:00:00') && widget.examun.date_fin!=DateTime.parse('0000-00-00 00:00:00')) {
          selectedOption1=widget.examun.matiere;
          selectedOption3=widget.examun.jour;
          selectedOption4=widget.examun.type;
          selectedOption2 = salleList.contains(widget.examun.salle) ? widget.examun.salle : (salleList.isNotEmpty ? salleList[0] : null);
          heure_debController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_deb);
          heure_finController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_fin);
        } else {
          selectedOption2 = salleList.isNotEmpty ? salleList[0] : null;
          selectedOption1 = matiereList.isNotEmpty ? matiereList[0] : null;
          selectedOption3 = jourList.isNotEmpty ? jourList[0] : null;
          selectedOption4 = typeList.isNotEmpty ? typeList[0] : null;
          heure_debController.text = DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
          heure_finController.text = DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);

        }
        idController.text = this.widget.examun.id.toString();
        typeController.text = this.widget.examun.type.toString();
        id_salController.text = this.widget.examun.id_sal.toString();
        id_matController.text = this.widget.examun.id_mat.toString();
        id_jourController.text=this.widget.examun.id_jour.toString();
      });
    });
    fetchSalles().then((_) {
      setState(() {
        if (widget.examun.salle != '' && widget.examun.matiere!='' &&  widget.examun.type!=null &&  widget.examun.jour!=''&& widget.examun.date_deb!=DateTime.parse('0000-00-00 00:00:00') && widget.examun.date_fin!=DateTime.parse('0000-00-00 00:00:00')) {
          selectedOption1=widget.examun.matiere;
          selectedOption3=widget.examun.jour;
          selectedOption4=widget.examun.type;
          selectedOption2 = salleList.contains(widget.examun.salle) ? widget.examun.salle : (salleList.isNotEmpty ? salleList[0] : null);
          heure_debController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_deb);
          heure_finController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_fin);
        } else {
          selectedOption2 = salleList.isNotEmpty ? salleList[0] : null;
          selectedOption1 = matiereList.isNotEmpty ? matiereList[0] : null;
          selectedOption4 = typeList.isNotEmpty ? typeList[0] : null;
          selectedOption3 = jourList.isNotEmpty ? jourList[0] : null;
          heure_debController.text = this.widget.examun.date_deb.toString();
          heure_finController.text = this.widget.examun.date_fin.toString();
        }
        idController.text = this.widget.examun.id.toString();
        typeController.text = this.widget.examun.type.toString();
        id_salController.text = this.widget.examun.id_sal.toString();
        id_matController.text = this.widget.examun.id_mat.toString();
        id_jourController.text=this.widget.examun.id_jour.toString();
      });
    });
    fetchJours().then((_) {
      setState(() {
        if (widget.examun.salle != ''  && widget.examun.matiere!='' &&  widget.examun.type!=null &&  widget.examun.jour!='' && widget.examun.date_deb!=DateTime.parse('0000-00-00 00:00:00') && widget.examun.date_fin!=DateTime.parse('0000-00-00 00:00:00')) {
          selectedOption1=widget.examun.matiere;
          selectedOption3=widget.examun.jour;
          selectedOption4=widget.examun.type;
          selectedOption2 = salleList.contains(widget.examun.salle) ? widget.examun.salle : (salleList.isNotEmpty ? salleList[0] : null);
          heure_debController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_deb);
          heure_finController.text=DateFormat('MM/dd/yyyy HH:mm:ss').format(widget.examun.date_fin);
        } else {
          selectedOption2 = salleList.isNotEmpty ? salleList[0] : null;
          selectedOption1 = matiereList.isNotEmpty ? matiereList[0] : null;
          selectedOption3 = jourList.isNotEmpty ? jourList[0] : null;
          selectedOption4 = typeList.isNotEmpty ? typeList[0] : null;
          heure_debController.text = this.widget.examun.date_deb.toString();
          heure_finController.text = this.widget.examun.date_fin.toString();
        }
        idController.text = this.widget.examun.id.toString();
        typeController.text = this.widget.examun.type.toString();
        id_salController.text = this.widget.examun.id_sal.toString();
        id_matController.text = this.widget.examun.id_mat.toString();
        id_jourController.text=this.widget.examun.id_jour.toString();
      });
    });
  }

  Future<List<Examun>> fetchSemestre_Etudians() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'examuns/'),headers: headers);
    var examuns = <Examun>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var type= u['type'];
      var heure_deb= u['date_deb'];
      var heure_fin = u['date_fin'];
      var id_mat = u['id_mat'];
      var id_sal = u['id_sal'];
      var matiere = u['matiere'];
      var salle = u['salle'];
      var id_jour= u['id_jour'];
      var jour = u['jour'];
      if (id != null && type!= null && heure_deb!= null && heure_fin!= null && id_mat != null && id_sal!= null ) {
        examuns.add(Examun(id,type,heure_deb,heure_fin, id_mat, id_sal,matiere,salle,id_jour,jour));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return examuns;
  }

  Future<void> fetchMatieres(String nomfil) async {

    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/matieres/$nomfil'),headers: headers);

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var matiere in data) {
        matiereList.add(matiere['libelle'] as String);
      }
    }
    print(matiereList);
  }
  Future<List<String>> fetchSalles() async {
    var response = await http.get(Uri.parse(baseUrl + 'annees/salles/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        salleList.add(salle['nom'] as String);
      }
    }
    return salleList;
  }
  Future<List<String>> fetchJours() async {
    var response = await http.get(Uri.parse(baseUrl + 'scolarites/jours/'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        jourList.add(salle['libelle'] as String);
      }
    }
    return jourList;
  }
  Future<int?> fetchMatieresId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/matiere/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchSallesId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/salle/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchJoursId(String nom) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/jour/$nom'),headers: headers);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(Examun examun) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
      'Content-Type': 'application/json;charset=UTF-8',
    };

    if (examun.id == 0) {
      try {
        var response = await http.post(
          Uri.parse(baseUrl + 'scolarites/'),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            'type': examun.type,
            'date_debut': examun.date_deb.toIso8601String() + 'Z', // Utilisez toIso8601String()
            'date_fin': examun.date_fin.toIso8601String() + 'Z',
            'id_sal': examun.id_sal.toString(),
            'id_mat': examun.id_mat.toString(),
            'id_jour': examun.id_jour.toString(),
          }),
        );

        if (response.statusCode == 200) {
          // La requête a réussi
          print("Requête réussie");
        } else {
          // La requête a échoué
          print("La requête a échoué avec le code d'état: ${response.statusCode}");
          print(response.body);
        }
      } catch (e) {
        print("Erreur: $e");
      }
    } else {
      try {
        var response = await http.put( // Utiliser la méthode PUT pour mettre à jour
          Uri.parse(baseUrl + 'scolarites/${examun.id}'), // Utiliser la route correcte
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            'type': examun.type,
            'date_debut': examun.date_deb.toIso8601String() + 'Z',
            'date_fin': examun.date_fin.toIso8601String() + 'Z',
            'id_sal': examun.id_sal.toString(),
            'id_mat': examun.id_mat.toString(),
            'id_jour': examun.id_jour.toString(),
          }),
        );

        if (response.statusCode == 200) {
          print("Requête réussie");
        } else {
          print("La requête a échoué avec le code d'état: ${response.statusCode}");
          print(response.body);
        }
      } catch (e) {
        print("Erreur: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [

            background_container(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 590,
                width: 340,
                child: Form(
                  child: Column(
                    children: [
                      Visibility(
                        visible: false,
                        child: TextFormField(
                          decoration: InputDecoration(hintText: 'Entrez id'),
                          controller: idController,
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption4,
                            onChanged: (String? newValue) async {
                              print(selectedOption4);
                              setState(() {
                                selectedOption4 = newValue!;
                              });

                              if (selectedOption4 != null) {
                                print(selectedOption4!);
                                typeController.text = selectedOption4!;
                              }
                            },
                            items: typeList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => typeList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                selectedOption4 ?? 'select',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),
                          ),

                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: heure_deb,
                          controller: heure_debController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'heure_deb',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: ()  =>Utils.showSheet(
                            context,
                            child: buildDateTimePicker(),
                            onClicked: () {
                              final value =
                              DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
                              setState(() {
                                heure_debController.text = value; //set output date to TextField value.
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.datetime,
                          focusNode: heure_fin,
                          controller: heure_finController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'heure_fin',
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                          ),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () =>Utils.showSheet(
                            context,
                            child: buildDateTimePicker(),
                            onClicked: () {
                              final value =
                              DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime);
                              setState(() {
                                heure_finController.text = value; //set output date to TextField value.
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption1,
                            onChanged: (String? newValue) async {
                              print(selectedOption1);
                              setState(() {
                                selectedOption1 = newValue!;
                              });

                              if (selectedOption1 != null) {
                                int? id = await fetchMatieresId(selectedOption1!);
                                print(id);
                                id_matController.text = id.toString();
                              }
                            },
                            items: matiereList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => matiereList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                selectedOption1 ?? 'select',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),

                          ),

                        ),
                      ),
                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption2,
                            onChanged: (String? newValue) async {
                              print(selectedOption2);
                              setState(() {
                                selectedOption2 = newValue!;
                              });

                              if (selectedOption2 != null) {
                                int? id = await fetchSallesId(selectedOption2!);
                                print(id);
                                id_salController.text = id.toString();
                              }
                            },
                            items: salleList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => salleList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                selectedOption2 ?? 'select',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),

                          ),

                        ),
                      ),
                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Color(0xffC5C5C5),
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: selectedOption3,
                            onChanged: (String? newValue) async {
                              print(selectedOption3);
                              setState(() {
                                selectedOption3 = newValue!;
                              });

                              if (selectedOption3 != null) {
                                int? id = await fetchJoursId(selectedOption3!);
                                print(id);
                                id_jourController.text = id.toString();
                              }
                            },
                            items: jourList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => jourList.map((e) => Text(e)).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                selectedOption3 ?? 'select',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            underline: Container(),
                          ),

                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Operation Completed Successfully!',
                            confirmBtnColor: Colors.blueAccent,
                          ).then((value) async {
                            if (value == null) {
                              int? id = int.tryParse(idController.text);
                              int? idMat = int.tryParse(id_matController.text);
                              int? idSal = int.tryParse(id_salController.text);
                              int? idJour = int.tryParse(id_salController.text);
                              DateTime heureDebut = DateFormat('MM/dd/yyyy HH:mm:ss').parse(heure_debController.text);
                              DateTime heureFin = DateFormat('MM/dd/yyyy HH:mm:ss').parse(heure_finController.text);
                              if (id != null && idMat != null && idSal != null && idJour!=null) {
                                try {
                                  // var formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(heure_finController.text));

                                  print(heure_finController.text);
                                } catch (e) {
                                  print("Erreur lors de la conversion de la date : $e");
                                }
                                await save(
                                  Examun(
                                    id,
                                    typeController.text,
                                      heureDebut,

                                      heureFin,
                                    idMat,
                                    idSal,
                                    '',
                                    '',
                                      idJour,
                                    ''
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPage( index: 0,  accessToken: widget.accessToken
                                        ,nomfil: widget.nomfil,
                                        nom_user: widget.nom_user,
                                        photo_user: widget.photo_user,
                                        child:  ListExamun(  accessToken: widget.accessToken, nomfil:widget.nomfil,                nom_user: widget.nom_user,
                                          photo_user: widget.photo_user,
                                        ),)
                                  ),
                                );

                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Invalid ID or Etudiant ID or Semestre ID"),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          });
                        },

                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent,
                          ),
                          width: 120,
                          height: 50,
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'f',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                child:   Center(
                  child: Text(
                    'Adding',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  //   ),
                  //
                  // ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget buildDateTimePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      initialDateTime: dateTime,
      mode: CupertinoDatePickerMode.dateAndTime,
      minimumDate: DateTime(DateTime.now().year, 2, 1),
      maximumDate: DateTime.now(),
      use24hFormat: true,
      onDateTimeChanged: (dateTime) =>
          setState(() => this.dateTime = dateTime),
    ),
  );
}
