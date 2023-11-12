import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/salle.dart';
import '../forms/salleform.dart';

class ListSalle extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;

  ListSalle({Key? key,required this.accessToken,required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  _ListSalleState createState() => _ListSalleState();
}

class _ListSalleState extends State<ListSalle> {
  List<Salle> sallesList = [];
  Map<int, bool> expandedStates = {};
  Color _getAvatarColor(int index) {
    final List<Color> couleurs = [Colors.pinkAccent ,Colors.blueAccent,Colors.purple,Colors.blueGrey, Colors.orange, Colors.pink, Colors.amber, Colors.lightBlue];
    return couleurs[index % couleurs.length];
  }
  String generateShortName(String fullName) {
    if (fullName.isEmpty) {
      return '';
    }

    List<String> words = fullName.split(' ');
    String shortName = '';

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        if (i == 0) {
          // Première lettre du premier mot
          shortName += word[0].toUpperCase();
        } else {
          // Ajoute la première lettre de chaque mot après l'espace
          shortName += word[0].toUpperCase() + word.substring(1);
        }
      }
    }

    return shortName;
  }
  String generateShortName1(String fullName) {
    if (fullName.isEmpty) {
      return '';
    }

    List<String> words = fullName.split(' ');

    // Si vous avez au moins deux mots dans le nom
    if (words.length > 1) {
      // Retourne la première lettre du deuxième mot concaténée avec le reste du deuxième mot
      return words[1][0].toUpperCase() + words[1].substring(1);
    } else {
      // Si le nom a un seul mot ou moins, retourne le nom complet tel quel
      return fullName;
    }
  }

  void toggleCardSize(int index) {
    setState(() {
      if (expandedStates.containsKey(index)) {
        expandedStates[index] = !expandedStates[index]!;
      } else {
        expandedStates[index] = true;
      }
    });
  }
  Future<List<Salle>> fetchSalles() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/salles/'),headers: headers);
    var salles = <Salle>[];
    for (var u in jsonDecode(response.body)) {
      salles.add(Salle(u['id'], u['nom'],''));
    }
    print(salles);
    return salles;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'salles/' + id),headers: headers);
  }

  @override
  void initState() {
    super.initState();
    fetchSalles().then((salles) {
      setState(() {
        sallesList = salles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      // MasterPage(
      // child:
      Scaffold(
        body: Container(
          // margin: EdgeInsets.symmetric(
          //   // horizontal: kDefaultPadding,
          //   vertical: 0,
          // ),
          child: FutureBuilder<List<Salle>>(
            future: fetchSalles(),
            builder: (BuildContext context, AsyncSnapshot<List<Salle>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var salles = snapshot.data!;
                return ListView.separated(
                  itemCount: salles.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 2), // Spacing of 16 pixels between each item
                  itemBuilder: (BuildContext context, int index) {
                    var salle = salles[index];
                    bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                    CircleAvatar avatar = CircleAvatar(
                      radius: 25,
                      backgroundColor: _getAvatarColor(index),
                      child: Text(
                        // salle.nom.isNotEmpty ? salle.nom[0].toUpperCase() : '',
                        generateShortName(salle.nom),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MasterPage(
                                index: 0,accessToken: widget.accessToken,
                                nomfil: widget.nomfil,
                                nom_user: widget.nom_user,
                                photo_user: widget.photo_user,
                                child:
                                SalleForm(
                                  salle: salle,  accessToken: widget.accessToken,
                                  nomfil: widget.nomfil,
                                  nom_user: widget.nom_user,
                                  photo_user: widget.photo_user,

                                ),),

                            ),
                          );
                        },
                        onLongPress: () async {
                          PanaraConfirmDialog.showAnimatedGrow(
                            context,
                            title: "Confirmation",
                            message: "Êtes-vous sûr de bien vouloir supprimer cet élément?",
                            confirmButtonText: "Delete",
                            cancelButtonText: "Annuler",
                            onTapCancel: () {
                              Navigator.pop(context);
                            },
                            onTapConfirm: () async {
                              // print("Delete button clicked");
                              await delete(salle.id.toString());
                              setState(() {});
                              Navigator.pop(context);
                            },
                            panaraDialogType: PanaraDialogType.normal,
                          );
                        },

                        child: Container(
                          width: 400,
                          height: isExpanded ? 120.0 : 80.0,
                          child: Card(
                            margin: EdgeInsets.all(5),
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(2.5)),
                            ),
                            child:      Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Positioned(
                                  //   top: 25, // Vous pouvez ajuster cette valeur selon vos besoins
                                  //   right: 10,
                                  //   child: Container(child: Icon(Icons.arrow_forward_ios,size:20,)),
                                  // ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:   Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric( horizontal: 2), // Ajustez les valeurs selon vos besoins
                                        dense: false,
                                        leading: avatar,
                                        title: Text(
                                          salle.nom,
                                          style: TextStyle( fontSize: 17),
                                        ),

                                        // subtitle:  isExpanded
                                        //     ? Text(
                                        //   "Date fin  : "+DateFormat('yyyy-MM-dd HH:mm').format(examun.date_fin)+"\nMatiere : "+examun.matiere+"\nSalle : " +examun.salle,
                                        //   style: TextStyle( fontSize: 16),
                                        // ): null,
                                        // trailing:
                                        // Avatar(
                                        //   margin: EdgeInsets.only(right: 20),
                                        //   size: 50,
                                        //   image: 'images/etudiants/'+etudiant.photo,
                                        // ),
                                      ),
                                    ),
                                  ),
                                  // if (isExpanded)
                                  //   Positioned(
                                  //     bottom: 10,
                                  //     right: 10,
                                  //     child: InkWell(
                                  //       onTap: () {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => MasterPage(
                                  //               index: 0,accessToken: widget.accessToken,
                                  //               nomfil: widget.nomfil,
                                  //               nom_user: widget.nom_user,
                                  //               photo_user: widget.photo_user,
                                  //               child:
                                  //               SalleForm(
                                  //                 salle: salle,  accessToken: widget.accessToken,
                                  //                 nomfil: widget.nomfil,
                                  //                 nom_user: widget.nom_user,
                                  //                 photo_user: widget.photo_user,
                                  //
                                  //               ),),
                                  //
                                  //           ),
                                  //         );
                                  //       },
                                  //       child: Container(
                                  //         child: Icon(Icons.edit, color: Colors.blueAccent),
                                  //       ),
                                  //     ),
                                  //   ),

                                  // SizedBox(width: 20,),
                                ]),
                          ),
                        )
                    );
                  },
                );
              }
            },
          ),
        ),

        floatingActionButton:  FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MasterPage(
                      index: 0,  accessToken: widget.accessToken,

                      nomfil: widget.nomfil,
                      nom_user: widget.nom_user,
                      photo_user: widget.photo_user,
                      child:
                      SalleForm(salle: Salle(0, '',''),  accessToken: widget.accessToken,                                          nomfil: widget.nomfil,
                        nom_user: widget.nom_user,
                        photo_user: widget.photo_user,
                      ),

                    ),
              ),
              // ),
            );
          },
          child: Icon(Icons.add),
        ),
        // ),
      );
  }
}

// const double kDefaultPadding = 20.0;


