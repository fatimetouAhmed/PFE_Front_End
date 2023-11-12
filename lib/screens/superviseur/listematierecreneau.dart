import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import 'package:pfe_front_flutter/screens/views/viewetudiant.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';
import '../../models/matiere.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType class
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../settings/babs_component_settings_group.dart';
import '../../settings/babs_component_settings_item.dart';
import '../forms/etudiantform.dart';
class MatiereCreneau extends StatefulWidget {
  final String accessToken;
  final int id;
  final String nom_user;
  final String photo_user;
  final int id_user;
  final String libelle;
  MatiereCreneau({Key? key, required this.accessToken, required this.id,required this.nom_user,required this.photo_user, required this.id_user, required this.libelle}) : super(key: key);


  @override
  State<MatiereCreneau> createState() => _EtudiantHomeState();
}

class _EtudiantHomeState extends State<MatiereCreneau> {

  List<Etudiant> etudiantsList = [];
  Map<int, bool> expandedStates = {};
  void toggleCardSize(int index) {
    setState(() {
      if (expandedStates.containsKey(index)) {
        expandedStates[index] = !expandedStates[index]!;
      } else {
        expandedStates[index] = true;
      }
    });
  }
  Future<List<Etudiant>> fetchMatieres(libelle,id) async {
    var response = await http.get(Uri.parse(baseUrl+'creneau_jours/jour/$libelle/$id'),);
    var etudiants = <Etudiant>[];
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List) {
      for (var u in jsonResponse) {
        var libelle = u['libelle'];
        var heure_debut = DateFormat('HH:mm:ss').parse(u['heure_debut']);
        var heure_fin =DateFormat('HH:mm:ss').parse(u['heure_fin']);

        etudiants.add(Etudiant(id, libelle, '','','','', heure_debut,'','',0,'',heure_fin,0,''));
      }
    } else {
      print("La réponse JSON ne contient pas une liste d'étudiants.");
    }

    return etudiants;
  }


  @override
  void initState() {
    super.initState();
    loadEtudiants();

  }

  Future<void> loadEtudiants() async {
    List<Etudiant> matieres = await fetchMatieres(widget.libelle,widget.id);
    setState(() {
      this.etudiantsList = matieres;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
        // backgroundColor: Colors.white,
        body: FutureBuilder<List<Etudiant>>(
          future: fetchMatieres(widget.libelle,widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Etudiant>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var etudiants = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: etudiants.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var etudiant = etudiants[index];
                  // Widget avatarWidget;
                  Widget avatarWidget = CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                  );

                  bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                  return  GestureDetector(
                      onTap: () {
                        toggleCardSize(index);
                      },
                      child:ListTile(
                        leading:  Avatar(
                          margin: EdgeInsets.only(right: 20),
                          size: 50,
                          image: 'images/creneau.png',
                        ),
                        trailing:
                        Text(DateFormat('HH:mm').format(etudiant.date_N)+' '+DateFormat('HH:mm').format(etudiant.date_insecription)),
                        title: Text(
                          etudiant.nom,
                          style: TextStyle( fontSize: 15),
                        ),
                        // subtitle:   isExpanded
                        //     ? Text(
                        //   "Email : "+etudiant.email+"\nFiliere: "+etudiant.filiere+"\n Telephone : "+etudiant.telephone.toString(),
                        //   style: TextStyle( fontSize: 16),
                        // ): null,
                      )

                  );
                },
              );

            }
          },
        ),
      );
  }
}

// const double kDefaultPadding = 20.0;


class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}