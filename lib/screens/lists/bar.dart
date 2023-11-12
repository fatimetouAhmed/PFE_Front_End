// import 'dart:js';
//
// import 'package:flutter/material.dart';
// class SideBar extends StatefulWidget {
//   @override
//   _SideBarState createState() => _SideBarState();
// }
//
// class _SideBarState extends State<SideBar> {
//   int index = 0;
//
//   void handleDestinationTap(int selectedIndex) {
//     setState(() {
//       index = selectedIndex;
//     });
//
//     // Perform actions based on the selected index
//     switch (selectedIndex) {
//       case 0:
//       // Action for "Home" tapped
//         print('Home tapped');
//         break;
//       case 1:
//       // Action for "Notifications" tapped
//         print('Notifications tapped');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MasterPage(
//               child: Notifications(),
//             ),
//           ),
//         );
//         break;
//       case 2:
//       // Action for "Historiques" tapped
//         print('Historiques tapped');
//         break;
//       case 3:
//       // Action for "Settings" tapped
//         print('Settings tapped');
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return NavigationBarTheme(
//       data: NavigationBarThemeData(
//         indicatorColor: Colors.blue.shade300,
//         labelTextStyle: MaterialStateProperty.all(
//           TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ),
//       child: NavigationBar(
//         height: 60,
//         backgroundColor: Color(0xFFf1f5fb),
//         selectedIndex: index,
//         onDestinationSelected: handleDestinationTap,
//         destinations: [
//           NavigationDestination(
//             icon: Icon(Icons.home),
//             label: 'home',
//           ),
//           InkWell(
//             onTap: () => handleDestinationTap(1),
//             child: NavigationDestination(
//               icon: Icon(Icons.notification_important),
//               label: 'Notifications',
//             ),
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.history),
//             label: 'Historiques',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
import 'package:pfe_front_flutter/screens/views/viewetudiant.dart';
import '../../../constants.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';
import '../../models/matiere.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http_parser/http_parser.dart'; // Import MediaType class
import 'package:panara_dialogs/panara_dialogs.dart';
import '../forms/etudiantform.dart';
class EtudiantHome extends StatefulWidget {
  final String accessToken;
  final String nom;
  EtudiantHome({Key? key, required this.accessToken, required this.nom}) : super(key: key);


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
  Future<List<Etudiant>> fetchEtudiants(String nom) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/etudiants/$nom'),);
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
    List<Etudiant> matieres = await fetchEtudiants(widget.nom);
    setState(() {
      this.etudiantsList = matieres;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      Scaffold(
        body: Container(
          width: 410,
          // margin: EdgeInsets.symmetric(
          //   // horizontal:100,
          //   vertical: 25,
          // ),
          child: FutureBuilder<List<Etudiant>>(
            future: fetchEtudiants(widget.nom),
            builder: (BuildContext context, AsyncSnapshot<List<Etudiant>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var etudiants = snapshot.data!;
                return ListView.separated(
                  itemCount: etudiants.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height:0 ), // Spacing of 16 pixels between each item
                  itemBuilder: (BuildContext context, int index) {
                    var etudiant = etudiants[index];
                    bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                    return GestureDetector(
                        onTap: () {
                          toggleCardSize(index);
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
                            onTapConfirm: () {
                              Navigator.pop(context);
                            },
                            panaraDialogType: PanaraDialogType.normal,
                          );
                        },
                        // onLongPress: () {
                        //   print('------------------------------------------');
                        //   print('Long press detected');
                        //   print('------------------------------------------');
                        //   showDeleteConfirmationDialog(etudiant.id);
                        // },
                        child: Container(
                          width: 400,
                          height: isExpanded ? 300.0 : 80.0,
                          child: Card(
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ),
                            child:      Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: 7, // Vous pouvez ajuster cette valeur selon vos besoins
                                    right: 10,
                                    child: Container(child: Icon(Icons.arrow_forward_ios,size:15,)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:   Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric( horizontal: 5), // Ajustez les valeurs selon vos besoins
                                        dense: false,
                                        leading:  Avatar(
                                          margin: EdgeInsets.only(right: 20),
                                          size: 50,
                                          image: 'images/etudiants/'+etudiant.photo,
                                        ),
                                        title: Text(
                                          etudiant.matricule,
                                          style: TextStyle( fontSize: 17),
                                        ),

                                        subtitle:  isExpanded
                                            ? Text(
                                          "Nom : "+etudiant.prenom+" "+etudiant.nom+"\nEmail : "+etudiant.email+"\nGenre : " +etudiant.genre+"\nDate_naissance : " +DateFormat('yyyy-MM-dd').format(etudiant.date_N)+"\nLieu_naissance : " +etudiant.lieu_n+"\nDate_Inscription : " +DateFormat('yyyy-MM-dd').format(etudiant.date_insecription)+"\nFiliere : " +etudiant.filiere,
                                          style: TextStyle( fontSize: 16),
                                        ): null,
                                        // trailing: Avatar(
                                        //   margin: EdgeInsets.only(right: 20),
                                        //   size: 50,
                                        //   image: 'images/etudiants/'+etudiant.photo,
                                        // ),
                                      ),
                                    ),
                                  ),
                                  if (isExpanded)
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () {
                                          // Action à effectuer lorsque l'icône est pressée
                                          // Par exemple, afficher un message ou naviguer vers une autre page
                                          print('Icon pressed');
                                        },
                                        child: Container(
                                          child: Icon(Icons.edit, color: Colors.blueAccent),
                                        ),
                                      ),
                                    ),

                                  // SizedBox(width: 20,),
                                ]),
                          ),
                        ));
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: () {
            print("click");
          },
          child: Icon(Icons.add),
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