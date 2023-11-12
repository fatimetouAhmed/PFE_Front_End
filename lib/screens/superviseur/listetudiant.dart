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
class EtudiantHome extends StatefulWidget {
  final String accessToken;
  final int id;
  final String nom_user;
  final String photo_user;
  final int id_user;
  EtudiantHome({Key? key, required this.accessToken, required this.id,required this.nom_user,required this.photo_user, required this.id_user}) : super(key: key);


  @override
  State<EtudiantHome> createState() => _EtudiantHomeState();
}

class _EtudiantHomeState extends State<EtudiantHome> {

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
  Future<List<Etudiant>> fetchEtudiants(id_user,id) async {
    var response = await http.get(Uri.parse(baseUrl+'datas/etudiants/$id_user/$id'),);
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
        var date_insecription = DateFormat('yyyy-MM-dd').parse(u['date_inscription']);
        var id_fil=u['id_fil'];
        var filiere=u['filiere'];
        etudiants.add(Etudiant(id, nom, prenom,photo,matricule,genre, date_N,lieu_n,email,telephone,nationalite,date_insecription,id_fil,filiere));
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
    List<Etudiant> matieres = await fetchEtudiants(widget.id_user,widget.id);
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
          future: fetchEtudiants(widget.id_user,widget.id),
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

                  if (etudiant.photo.startsWith("images/notifications")) {
                    avatarWidget = CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(etudiant.photo),
                      backgroundColor: Colors.transparent,
                    );
                  } else if (etudiant.photo.startsWith("/data/")) {
                    File imageFile = File(etudiant.photo); // Créer un objet File
                    if (imageFile.existsSync()) {
                      // Charger et afficher l'image
                      avatarWidget = CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(imageFile),
                        backgroundColor: Colors.transparent,
                      );
                    } else {
                      print("Le fichier image n'existe pas à l'emplacement spécifié.");
                    }
                  } else {
                    avatarWidget = CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("default_image.png"),
                      backgroundColor: Colors.transparent,
                    );
                  }
                  bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                  return  GestureDetector(
                      onTap: () {
                        toggleCardSize(index);
                      },
                      child:ListTile(
                  leading:  Avatar(
                    margin: EdgeInsets.only(right: 20),
                    size: 50,
                    image: 'images/etudiants/'+etudiant.photo,
                  ),
                      trailing:  Text(
                      etudiant.matricule,
                      style: TextStyle( fontSize: 15),
                      ),
                      title: Text(etudiant.prenom+' '+etudiant.nom),
                        subtitle:   isExpanded
                            ? Text(
                          "Email : "+etudiant.email+"\nFiliere: "+etudiant.filiere+"\n Telephone : "+etudiant.telephone.toString(),
                          style: TextStyle( fontSize: 16),
                        ): null,
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

Widget _head() {
  return Stack(
    children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,

            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
      Positioned(
        top: 10,
        left: 37    ,
        child: Container(
          height: 140,
          width: 340,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey,
                offset: Offset(0, 6),
                blurRadius: 12,
                spreadRadius: 6,
              ),
            ],
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total des Etudiants',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      '65',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      )
    ],
  );
}

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