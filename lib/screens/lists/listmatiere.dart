import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import 'package:pfe_front_flutter/screens/views/viewmatiere.dart';
import '../../../constants.dart';
import '../../bar/masterpageadmin2.dart';
import '../../consturl.dart';
import '../../models/matiere.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class MatiereHome extends StatefulWidget {
  final String accessToken;
final String nomfil;
   String nom_user;
  String photo_user;
  MatiereHome({Key? key, required this.accessToken, required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);


  @override
  State<MatiereHome> createState() => _MatiereHomeState();
}

class _MatiereHomeState extends State<MatiereHome> {

  List<Matiere> matieresList = [];
  Map<int, bool> expandedStates = {};
  // final List<Color> couleurs = [Colors.pinkAccent ,Colors.blueAccent,Colors.purple,Colors.blueGrey, Colors.orange];
  void toggleCardSize(int index) {
    setState(() {
      if (expandedStates.containsKey(index)) {
        expandedStates[index] = !expandedStates[index]!;
      } else {
        expandedStates[index] = true;
      }
    });
  }
  Color _getAvatarColor(int index) {
    final List<Color> couleurs = [Colors.pinkAccent ,Colors.blueAccent,Colors.purple,Colors.blueGrey, Colors.orange, Colors.pink, Colors.amber, Colors.lightBlue];
    return couleurs[index % couleurs.length];
  }

  Future<List<Matiere>> fetchMatieres(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/matieres/$nom'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Matiere> matieres = [];

      for (var matiere in jsonResponse) {
        matieres.add(Matiere(
          matiere['id'],
          matiere['libelle'],
          matiere['nbr_heure'],
          matiere['credit'],
          matiere['filiere'],
        ));
      }

      return matieres;
    } else {
      throw Exception('Failed to load data from API');
    }
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
    fetchMatieres(widget.nomfil).then((matieres) {
      setState(() {
        this.matieresList = matieres;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      // backgroundColor: Colors.white,
      body: FutureBuilder<List<Matiere>>(
        future: fetchMatieres(widget.nomfil),
        builder: (BuildContext context, AsyncSnapshot<List<Matiere>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var matieres = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 30),
              itemCount: matieres.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var matiere = matieres[index];

                // Créez un avatar avec une couleur basée sur l'index
                CircleAvatar avatar = CircleAvatar(
                  radius: 30,
                  backgroundColor: _getAvatarColor(index),
                  child: Text(
                    matiere.libelle.isNotEmpty ? matiere.libelle[0].toUpperCase() : '',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );

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
                              child: ViewMatiere(
                                accessToken: widget.accessToken,
                                id: matiere.id,
                                nomfil: widget.nomfil,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: avatar,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                matiere.libelle,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                matiere.filiere,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Crédit : "+matiere.credit.toString(),
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
                      height: 0.5,
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
                      'Total des Matieres',
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
