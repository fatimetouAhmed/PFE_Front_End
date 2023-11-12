import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/surveillance.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';

class SurveillanceForm extends StatefulWidget {
  final Surveillance surveillance;
  final String accessToken;
  final String nomfil;
  final String nom_user;
  final String photo_user;
  SurveillanceForm(
      {Key? key,
        required this.surveillance,
        required this.accessToken,
        required this.nomfil,
        required this.nom_user,
        required this.photo_user})
      : super(key: key);

  @override
  _SurveillanceFormState createState() => _SurveillanceFormState();
}

class _SurveillanceFormState extends State<SurveillanceForm> {
  TextEditingController idController = TextEditingController();
  TextEditingController superviseurController = TextEditingController();
  TextEditingController evaluationController = TextEditingController();
  TextEditingController salleController = TextEditingController();
  String? selectedOption1;
  String? selectedOption2;
  String? selectedOption3;
  List<String> surveillantList = [];
  List<String> salleList = [];
  List<String> evaluationList = [];
  List<String> _selectedItems = [];
  List<String> _selectedItemsallles = [];
  Future<List<String>> fetchSalles() async {
    var response = await http.get(Uri.parse(baseUrl+'surveillances/salles/nom'));

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var salle in data) {
        salleList.add(salle['nom'] as String);
      }
    }
    return salleList;
  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: salleList);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }
  String getButtonText() {
    // if(widget.surveillance.salle == [])return 'Select salles';
    if (_selectedItems.isEmpty && widget.surveillance.salle == []) {
      return 'Select salles';
    }
    else if(_selectedItems.isEmpty && widget.surveillance.salle != []){
        return widget.surveillance.salle.join(',');

    }
    else {
      return _selectedItems.join(', ');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();

  }

  Future<void> fetchData() async {
    await fetchNomSurveillances().then((superviseurs) {
      setState(() {
        surveillantList = superviseurs;
        idController.text = widget.surveillance.id.toString();
        superviseurController.text = widget.surveillance.superviseur_id.toString();
        evaluationController.text = widget.surveillance.evaluation_id.toString();
        salleController.text=widget.surveillance.salle_id;
        // if(selectedOption1 =='' && selectedOption2=='' && selectedOption3=='') {
        //   surveillantList[0] ='';
        //   salleList[0] = '';
        //   evaluationList[0] ='';
        // }
        // else{
        //   selectedOption1 = widget.surveillance.superviseur ;
        //   selectedOption2 = widget.surveillance.salle ;
        //   selectedOption3 = widget.surveillance.evaluation ;
        // }
        if (widget.surveillance.superviseur != '') {
          selectedOption1 = widget.surveillance.superviseur;
        } else {
          selectedOption1 = surveillantList.isNotEmpty ? surveillantList[0] : null;
        }
      });
    });


    await fetchSalles().then((salles) {
      salleList = salles;
      setState(() {
        // idController.text = widget.surveillance.id.toString();
        // idController.text = widget.surveillance.id.toString();
        // superviseurController.text = widget.surveillance.superviseur_id.toString();
        // evaluationController.text = widget.surveillance.evaluation_id.toString();
        // salleController.text=widget.surveillance.salle_id;
      });
    });

    await fetchNomEvaluations(widget.nomfil).then((evaluations) {
      evaluationList = evaluations;

      setState(() {
        idController.text = widget.surveillance.id.toString();

        // selectedOption1 = widget.surveillance.superviseur ?? 'select';
        // selectedOption2 = widget.surveillance.salle ?? 'select';
        // selectedOption3 = widget.surveillance.evaluation ?? 'select';
        if (widget.surveillance.evaluation != '') {
          selectedOption3 = widget.surveillance.evaluation;
          superviseurController.text = widget.surveillance.superviseur_id.toString();
          evaluationController.text = widget.surveillance.evaluation_id.toString();
          salleController.text=widget.surveillance.salle_id;
        } else {
          selectedOption3 = evaluationList.isNotEmpty ? evaluationList[0] : null;
        }
      });
    });
  }

  Future<List<String>> fetchNomSurveillances() async {
    var response = await http.get(
      Uri.parse(baseUrl + 'surveillances/surveillances/nom/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var surveillance in data) {
        surveillantList.add(surveillance['prenom'] as String);
      }
    }
    return surveillantList;
  }

  Future<List<String>> fetchNomEvaluations(String nomfil,) async {
    var response = await http.get(
      Uri.parse(baseUrl + 'surveillances/surveillances/evaluations/nom/$nomfil'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      for (var surveillance in data) {
        evaluationList.add(surveillance['type'] as String);
      }
    }
    print('----------------------------------');
    print(evaluationList);
    print('----------------------------------');
    return evaluationList;
  }
  Future<int?> fetchSurveillanceId(String nom) async {
    var response = await http.get(
      Uri.parse(baseUrl+'surveillances/surveillances/$nom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchEvaluationId(String nom) async {
    var response = await http.get(
      Uri.parse(baseUrl+'surveillances/surveillances/evaluations/$nom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<int?> fetchSallesId(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'scolarites/salle/$nom'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}', // Add the authorization token to the headers
      },);

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future<void> save(Surveillance surveillance) async {

    if (surveillance.id == 0) {
      print(surveillance.superviseur_id);
      print(surveillance.salle_id);
      print(surveillance.evaluation_id);
      await http.post(
        Uri.parse(baseUrl + 'surveillances/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          // 'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: jsonEncode(<String, dynamic>{
          'id_sup': surveillance.superviseur_id,
          'id_sal': surveillance.salle_id,
          'id_eval': surveillance.evaluation_id,
        }),
      );
    } else {
      await http.put(
        Uri.parse(baseUrl + 'surveillances/' + surveillance.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_sup': surveillance.superviseur_id,
          'id_sal': surveillance.salle_id,
          'id_eval': surveillance.evaluation_id,
        }),
      );
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
            backgroundContainer(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: 350,
                width: 370,
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
                      SizedBox(height: 15),
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
                                int? id = await fetchSurveillanceId(selectedOption1!);
                                // print(id);
                                superviseurController.text = id.toString();
                              }
                            },
                            items: surveillantList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => surveillantList.map((e) => Text(e)).toList(),
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
                      SizedBox(height: 15),
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
                                int? id = await fetchEvaluationId(selectedOption3!);
                                // print(id);
                                evaluationController.text = id.toString();
                              }
                            },
                            items: evaluationList.map((e) => DropdownMenuItem(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              value: e,
                            )).toList(),
                            selectedItemBuilder: (BuildContext context) => evaluationList.map((e) => Text(e)).toList(),
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
                      ElevatedButton(
                        onPressed: _showMultiSelect,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // elevation: 15.0,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                            width: 300,
                            // height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                color: Color(0xffC5C5C5),
                              ),
                            ),
                            child: Text(
                             'Selected Salles : ' +getButtonText(),
                              style: TextStyle(fontSize: 15,color: Colors.black),
                            ),

                          ),
                        ),
                        // Padding(
                        //   // padding:const EdgeInsets.all(15.0),
                        //   padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 6),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         'Select Salles : ',
                        //         style: TextStyle(fontSize: 16,color: Colors.black),
                        //       ),
                        //       Text(
                        //         getButtonText(),
                        //         style: TextStyle(fontSize: 15,color: Colors.black),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                              int? idDep = int.tryParse(superviseurController.text);
                              int? ideval = int.tryParse(evaluationController.text);
                              salleController.text=MultiSelect.sallesIds!;
                              if (id != null &&
                                  idDep != null &&
                                  ideval != null) {
                                await save(
                                  Surveillance(
                                    id,
                                    idDep,
                                    salleController.text,
                                    ideval,
                                    '',
                                    [],
                                    '',
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MasterPage(
                                      index: 0,
                                      accessToken: widget.accessToken,
                                      nomfil: widget.nomfil,
                                      nom_user: widget.nom_user,
                                      photo_user: widget.photo_user,
                                      child: ListSurveillance(
                                        accessToken: widget.accessToken,
                                        nomfil: widget.nomfil,
                                        nom_user: widget.nom_user,
                                        photo_user: widget.photo_user,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Invalid ID or Department ID"),
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

  Column backgroundContainer(BuildContext context) {
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
                child: Center(
                  child: Text(
                    'Adding',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class MultiSelect extends StatefulWidget {
  final List<String> items;

  static String? sallesIds;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  final List<int> _selectedIds = [];
// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }
  Future<int?> fetchSallesId(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'scolarites/salle/$nom'),
    );

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      return jsonData;
    }

    return null;
  }
// this function is called when the Submit button is tapped
  Future<void> _submit()  async {
    for (var salleNom in _selectedItems) {
      int? salleId = await fetchSallesId(salleNom);
      if (salleId != null) {
        // print('ID de la salle $salleNom : $salleId');
        _selectedIds.add(salleId);
      }
    }
    MultiSelect.sallesIds=_selectedIds.join(';');
    // print(sallesIds);
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Salles'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        // ElevatedButton(
        //   onPressed: _submit,
        //   child: const Text('Submit'),
        // ),
        SizedBox(width: 5,),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 15.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
