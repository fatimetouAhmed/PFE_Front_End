import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';

import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../forms/etudiantform.dart';
class ViewEtudiant extends StatefulWidget {
  final String accessToken;
final int id;
  String nomfil;
  ViewEtudiant({Key? key, required this.accessToken, required this.id, required this.nomfil,
   // required this.accessToken
  }) : super(key: key);


  @override
  State<ViewEtudiant> createState() => _ViewEtudiantState();
}

class _ViewEtudiantState extends State<ViewEtudiant> {

  List<Etudiant> etudiantsList = [Etudiant(0, '', '', '', '','', DateTime.parse('0000-00-00 00:00:00'), '', '',0,'', DateTime.parse('0000-00-00 00:00:00'),0,'')];

  Future<List<Etudiant>> fetchEtudiants(nom,id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'annees/etudiants/$nom/$id'),
        headers: headers
    );
    var etudiants = <Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List) {
      for (var u in jsonResponse) {
        var id = u['id'];
        var nom = u['nom'];
        var prenom = u['prenom'];
        var photo = u['photo'];
        var matricule = u['matricule'];
        var genre= u['genre'];
        var date_N = DateFormat('yyyy-MM-dd').parse(u['date_N']);
        var lieu_n = u['lieu_n'];
        var email = u['email'];
        var telephone = u['telephone'];
        var nationalite = u['nationalite'];
        var date_insecription = DateFormat('yyyy-MM-dd').parse(u['date_insecription']);
        var id_fil=u['id_fil'];
        var filiere=u['filiere'];
        etudiants.add(Etudiant(id, nom, prenom,photo,matricule,genre, date_N,lieu_n,email,telephone,nationalite,date_insecription,id_fil,filiere));
      }
    } else {
      print("La réponse JSON ne contient pas une liste d'étudiants.");
    }

    return etudiants;
  }
  //
  // Future delete(id) async {
  //   var headers = {
  //     "Authorization": "Bearer ${widget.accessToken}",
  //   };
  //   await http.delete(Uri.parse(baseUrl+'matieres/' + id),headers: headers);
  // }
  @override
  void initState() {
    super.initState();
    //etudiantsList.add(Etudiant(0, '', '', '', '', DateTime.parse('0000-00-00 00:00:00'), '', '',0,'', DateTime.parse('0000-00-00 00:00:00'))); // Add this line if you still need to add null to the list
    fetchEtudiants(widget.nomfil,widget.id.toString()).then((etudiants) {
      setState(() {
        this.etudiantsList = etudiants;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
         backgroundColor: Colors.white,

        body:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35,),
              InkWell(
                  onTap: () {
                    // navigateSecondPage(EditImagePage());
                  },

                  child:
                  CircleAvatar(
                    backgroundImage: AssetImage('images/etudiants/${etudiantsList[0].photo}'),
                    radius: 100,
                  ),
                  // CircleAvatar(
                  //   radius: 75,
                  //   backgroundColor: null,
                  //   child: CircleAvatar(
                  //     child: ClipOval(
                  //                 child: Image.asset('images/etudiants/${etudiantsList[0].photo}',height: 150,width: 150,fit: BoxFit.cover,),
                  //               ),
                  //     radius: 70,
                  //   ),
                  // )
              ),
              SizedBox(height: 7,),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Espace à gauche du texte "Matricule"
                        Text(
                          'Matricule',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38), // Espace à gauche du conteneur
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Espace à gauche du matricule
                          Text(
                            etudiantsList[0].matricule,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                            'Nom et prenom',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Spacer à gauche
                          Text(
                            etudiantsList[0].prenom+" "+etudiantsList[0].nom,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38),// Spacer à gauche
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Spacer à gauche
                          Text(
                            etudiantsList[0].email,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                            'Date de naissance',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Spacer à gauche
                          Text(
                            DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_N),
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Lieu de Naissance',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [// Spacer à gauche
                          Text(
                            etudiantsList[0].lieu_n,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Nationalité',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Spacer à gauche
                          Text(
                            etudiantsList[0].nationalite,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Genre',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [// Spacer à gauche
                          Text(
                            etudiantsList[0].genre,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Telephone',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [// Spacer à gauche
                          Text(
                            etudiantsList[0].telephone.toString(),
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Date d inscription',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    SizedBox(height: 1),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [ // Spacer à gauche
                          Text(
                            DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_insecription),
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 38), // Spacer à gauche
                        Text(
                          'Filiere',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ), // Espacement entre 'Matricule' et le conteneur suivant
                      ],
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      margin: EdgeInsets.only(left: 38,right: 38),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [// Spacer à gauche
                          Text(
                            etudiantsList[0].filiere,
                            style: TextStyle(fontSize: 18, height: 1.4),
                          ),
                          // Ajoutez un Spacer ou un SizedBox si nécessaire pour l'espacement à droite
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: ListView(
        //     children: [
        //       // user card
        //
        //       CircleAvatar(
        //         radius: 70,
        //         child: ClipOval(
        //           child: Image.asset('images/etudiants/${etudiantsList[0].photo}',height: 150,width: 150,fit: BoxFit.cover,),
        //         ),
        //       ),
        //       SizedBox(height: 20,),
        //
        // Expanded(child: Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
        //       gradient: LinearGradient(
        //           begin: Alignment.topRight,
        //           end: Alignment.bottomLeft,
        //         colors: [Colors.blueAccent, Colors.blueAccent],
        //         // colors: [Colors.black54,Color.fromRGBO(0, 41, 102, 1)]
        //       )
        //   ),
        //   child:
        //       SettingsGroup(
        //         settingsGroupTitle: '',
        //         items: [
        //
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: Icons.near_me,
        //             title: etudiantsList[0].nom,
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:etudiantsList[0].prenom,
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.delete_solid,
        //             title: etudiantsList[0].email,
        //             titleStyle: TextStyle(
        //               // color: Colors.red,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:etudiantsList[0].genre,
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:etudiantsList[0].lieu_n,
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //
        //             title: DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_N),
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:etudiantsList[0].telephone.toString(),
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:etudiantsList[0].nationalite,
        //           ),
        //           SettingsItem(
        //             onTap: () {},
        //             // icons: CupertinoIcons.repeat,
        //             title:DateFormat('yyyy-MM-dd').format(etudiantsList[0].date_insecription),
        //           ),
        //
        //
        //         ],
        //       ),
        // )
        // )
        //     ],
        //   ),
        // ),
      );

  }
}

