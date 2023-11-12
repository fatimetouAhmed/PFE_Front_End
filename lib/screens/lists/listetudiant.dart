import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import 'package:pfe_front_flutter/screens/views/viewetudiant.dart';
import '../../../constants.dart';
import '../../bar/masterpageadmin2.dart';
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
  final String nomfil;
  final String nom_user;
  final String photo_user;
  EtudiantHome({Key? key, required this.accessToken, required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);


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
  Future<List<Etudiant>> fetchEtudiants(String nomfil) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/etudiants/$nomfil'),);
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

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'matieres/' + id),headers: headers);
  }
  @override
  void initState() {
    super.initState();
    loadEtudiants();

  }

  Future<void> loadEtudiants() async {
    List<Etudiant> matieres = await fetchEtudiants(widget.nomfil);
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
          future: fetchEtudiants(widget.nomfil),
          builder: (BuildContext context, AsyncSnapshot<List<Etudiant>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var etudiants = snapshot.data!;
             return ListView.builder(
               padding: EdgeInsets.symmetric(vertical: 30), // Ajustez les valeurs en conséquence
               itemCount: etudiants.length,
               physics: BouncingScrollPhysics(),
               itemBuilder: (context, index) {
                 var etudiant = etudiants[index];
                 return Column(
                   children: [
                     GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => MasterPage2(
                               index: 0,
                               accessToken: widget.accessToken,
                               nomfil: widget.nomfil,
                               nom_user: widget.nom_user,
                               photo_user: widget.photo_user,
                               child: ViewEtudiant(
                                 accessToken: widget.accessToken,
                                 id: etudiant.id,
                                 nomfil: widget.nomfil,
                               ),
                             ),
                           ),
                         );
                       },
                       child: Padding(
                         padding: EdgeInsets.symmetric(vertical: 8), // Ajustez la valeur en conséquence
                         child: ListTile(
                           leading: CircleAvatar(
                             radius: 37,
                             backgroundImage: AssetImage('images/etudiants/' + etudiant.photo),
                           ),
                           title: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 etudiant.matricule,
                                 style: TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                 ),
                               ),
                               Text(
                                 etudiant.filiere,
                                 style: TextStyle(
                                   fontSize: 13,
                                   fontWeight: FontWeight.w500,
                                   color: Colors.grey,
                                 ),
                               ),
                             ],
                           ),
                           subtitle: Text(
                             etudiant.prenom,
                             style: TextStyle(
                               fontSize: 13,
                               fontWeight: FontWeight.w500,
                               color: Colors.grey,
                             ),
                           ),
                         ),
                       ),
                     ),
                     Divider(
                       color: Colors.grey.withOpacity(0.2),
                       height: 0.2,
                       thickness: 1,
                     ),
                   ],
                 );

               },
             );



            }
          },
        ),
      );
  }
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