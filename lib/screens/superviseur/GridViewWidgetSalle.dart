import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:pfe_front_flutter/screens/superviseur/listematierecreneau.dart';
import 'package:pfe_front_flutter/screens/superviseur/listetudiant.dart';

import '../../../bar/masterpagesuperviseur.dart';
import '../../consturl.dart';
import '../../models/filliere.dart';
import '../../models/salle.dart';
import 'GridViewWidgetSemestre.dart';
const double _kItemExtent = 32.0;
class GridViewWidgetSalle extends StatefulWidget {
  // final int id;
  final String accessToken;
  final int id_user;
  final String nom_user;
  final String photo_user;
  const GridViewWidgetSalle({Key? key,required this.accessToken, required this.id_user, required this.nom_user, required this.photo_user}) : super(key: key);
  @override
  State<GridViewWidgetSalle> createState() => _GridViewWidgetFiliereState();
}

class _GridViewWidgetFiliereState extends State<GridViewWidgetSalle> {
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final colors=Colors.blueAccent;
  List<Salle> sallesList = [];
  List<String> epreuveList = [];
  List<String> jourList = [];
  bool isSelect=false;
  bool isSelectEpreuve=false;
  int _selectedEpreve = 0;
  bool isSelectjour=false;
  int _selectedjour = 0;
  Salle? selectedSalle;
  int selectedSalleIndex = -1;
  List<String> choixList = [
    "Etudiants",
    "Epreuves",
  ];
  int id_sal=0;
  int _selectedChoix = 0;
  Future<List<String>> fetchEpreuves() async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'creneau_jours/epreuve'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> epreuves = [];
        for (var u in data) {
          if (u['type'] is String) {
            epreuves.add(u['type']);
          }
        }

        return epreuves;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchJours(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'creneau_jours/joureupreve/$nom'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> jours = [];
        for (var u in data) {
          if (u['libelle'] is String) {
            jours.add(u['libelle']);
          }
        }
        return jours;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
  Future<List<Salle>> fetchSalles(id) async {
    var headers = {
      "Content-Type": "application/json; charset=utf-8",
       "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'datas/salle/$id'),headers: headers);
    var data = utf8.decode(response.bodyBytes);
    var departements = <Salle>[];
    for (var u in jsonDecode(data)) {// Adjust the date format here
      departements.add(Salle(u['id'],u['nom'],u['surveillant']));
    }
    return departements;
  }

  @override
  void initState() {
    super.initState();
    fetchSalles(widget.id_user).then((fileres) {
      setState(() {
        sallesList = fileres;
      });
    });
  }

  void _onSubmit(BuildContext context) {
    if (choixList[_selectedChoix]=='Etudiants') {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) =>MasterPageSupeurviseur(child:
         EtudiantHome(id: id_sal, accessToken: widget.accessToken, nom_user: widget.nom_user, photo_user: widget.photo_user, id_user: widget.id_user,),
           accessToken: widget.accessToken, index: 0, id:widget.id_user, nom_user: widget.nom_user, photo_user: widget.photo_user,),
      ),  // Replace AutrePage() with the name of your other page.
       );
    }
    else{
      if(isSelectjour==true){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>MasterPageSupeurviseur(child:
         MatiereCreneau(id: id_sal, accessToken: widget.accessToken, nom_user: widget.nom_user, photo_user: widget.photo_user, id_user: widget.id_user, libelle: jourList[_selectedjour],),
            accessToken: widget.accessToken, index: 0, id:widget.id_user, nom_user: widget.nom_user, photo_user: widget.photo_user,),
          ),  // Replace AutrePage() with the name of your other page.
        );
      }
    }

  }
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:FutureBuilder<List<Salle>>(
          future: fetchSalles(widget.id_user),
          builder: (BuildContext context, AsyncSnapshot<List<Salle>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var filieres = snapshot.data!;

              return GridView.builder(
                itemCount: filieres.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(40, 0, 40,0),
                    // padding: const EdgeInsets.symmetric(horizontal: 60.0,vertical: 40,top),
                    // padding: const EdgeInsets.only(left: 60, right: 60,top:0,),

                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,// Ajout de cette ligne
                        children: [
                          // Icon(
                          //   Icons.room_preferences_outlined,
                          //   size: 34,
                          //   color: colors.withOpacity(0.9),
                          // ),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('images/salles.jpg'),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedSalleIndex == index) {
                                  selectedSalleIndex = -1;
                                  id_sal = 0;
                                } else {
                                  selectedSalleIndex = index;
                                  id_sal = filieres[index].id;
                                }
                              });
                            },
                            child: Text(
                              filieres[index].nom,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),

                          Text(
                            filieres[index].nom_surveillant,
                            style: TextStyle(fontSize: 18),
                          ),
                          Visibility(
                            visible: selectedSalleIndex == index,
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Choix : ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () =>
                                          _showDialog(
                                            CupertinoPicker(
                                              magnification: 1.22,
                                              squeeze: 1.2,
                                              useMagnifier: true,
                                              itemExtent: _kItemExtent,
                                              scrollController: FixedExtentScrollController(
                                                initialItem: _selectedChoix,
                                              ),
                                              onSelectedItemChanged: (
                                                  int selectedItem) {
                                                setState(() {
                                                  _selectedChoix = selectedItem;
                                                  fetchEpreuves().then((nom) {
                                                    setState(() {
                                                      epreuveList = nom;
                                                    });
                                                  });
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                choixList.length,
                                                    (int index) {
                                                  return Center(
                                                      child: Text(
                                                          choixList[index]));
                                                },
                                              ),
                                            ),
                                          ),
                                      child: Text(
                                        _selectedChoix < choixList.length
                                            ? choixList[_selectedChoix]
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:selectedSalleIndex == index && choixList[_selectedChoix]=='Epreuves',
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Epreuve : ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    CupertinoButton(
                                      // padding: EdgeInsets.,
                                      onPressed: () =>
                                          _showDialog(
                                            CupertinoPicker(
                                              magnification: 1.22,
                                              squeeze: 1.2,
                                              useMagnifier: true,
                                              itemExtent: _kItemExtent,
                                              scrollController: FixedExtentScrollController(
                                                initialItem: _selectedEpreve,
                                              ),
                                              onSelectedItemChanged: (
                                                  int selectedItem) {
                                                setState(() {
                                                  _selectedEpreve = selectedItem;
                                                  isSelectEpreuve=true;
                                                  fetchJours(epreuveList[_selectedEpreve]).then((nom) {
                                                    setState(() {
                                                      jourList = nom;
                                                    });
                                                  });
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                epreuveList.length,
                                                    (int index) {
                                                  return Center(
                                                      child: Text(
                                                          epreuveList[index]));
                                                },
                                              ),
                                            ),
                                          ),
                                      child: Text(
                                        _selectedEpreve < epreuveList.length
                                            ? epreuveList[_selectedEpreve]
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: selectedSalleIndex == index && isSelectEpreuve == true ,
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Jour : ',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    CupertinoButton(
                                      // padding: EdgeInsets.zero,
                                      onPressed: () =>
                                          _showDialog(
                                            CupertinoPicker(
                                              magnification: 1.22,
                                              squeeze: 1.2,
                                              useMagnifier: true,
                                              itemExtent: _kItemExtent,
                                              scrollController: FixedExtentScrollController(
                                                initialItem: _selectedjour,
                                              ),
                                              onSelectedItemChanged: (
                                                  int selectedItem) {
                                                setState(() {
                                                  _selectedjour = selectedItem;
                                                  isSelectjour=true;
                                                });
                                              },
                                              children: List<Widget>.generate(
                                                jourList.length,
                                                    (int index) {
                                                  return Center(
                                                      child: Text(
                                                          jourList[index]));
                                                },
                                              ),
                                            ),
                                          ),
                                      child: Text(
                                        _selectedjour < jourList.length
                                            ? jourList[_selectedjour]
                                            : '',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(  visible: selectedSalleIndex == index,
                            child:  CupertinoButton(
                              // padding: EdgeInsets.zero,
                              child: Text(
                                'Suivant',
                                style: TextStyle(fontSize: 19.0),
                              ),
                              onPressed: () => _onSubmit(context),

                            ),),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
              );

            }}),);
  }

}
