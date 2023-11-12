import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pfe_front_flutter/models/surveillance.dart';
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../forms/surveillanceform.dart';
class ListSurveillance extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  ListSurveillance({Key? key, required this.accessToken, required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);
  @override
  State<ListSurveillance> createState() => _ListSurveillanceState();
}

class _ListSurveillanceState extends State<ListSurveillance> {
  List<Surveillance> surveillancetsList = [];
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
  Future<List<Surveillance>> fetchSurveillances(String nomfil) async {
    var response = await http.get(Uri.parse(baseUrl+'scolarites/Surveillances/$nomfil'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch surveillances.');
    }

    var jsonList = jsonDecode(response.body);

    if (jsonList is List) {
      var surveillances = <Surveillance>[];
      for (var u in jsonList) {
        var surveillantId = u['id_sup'];
        var salleList = u['salle'];
        if (salleList != null && surveillantId != null) {
          List<String> salles = salleList.cast<String>(); // Convert dynamic list to List<String>
          surveillances.add(Surveillance(
              u['id'], u['id_sup'], u['id_sal'], u['id_eval'], u['superviseur'], salles, u['evaluation']
          ));
        } else {
          print('Les données ne sont pas correctes');
        }
      }
      return surveillances;
    } else {
      throw Exception('Invalid JSON format: Expected a list of surveillances.');
    }
  }


  Future<int?> fetchSuperviseurId() async {
    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/current_user_id/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    }

    return null;
  }
  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'surveillances/$id'),headers: headers);
  }
  int id=0;
  @override
  void initState() {
    super.initState();
    fetchSurveillances(widget.nomfil); // Call the async method to fetch data
  }
  //
  // Future<void> fetchData() async {
  //   int id = await fetchSuperviseurId() as int;
  //   print(id);
  //   print(widget.accessToken);
  //   fetchSurveillances(widget.nomDep,widget.nomNiv).then((surveillances) {
  //     setState(() {
  //       surveillancetsList = surveillances;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        child: FutureBuilder<List<Surveillance>>(
          future: fetchSurveillances(widget.nomfil),
          builder: (BuildContext context, AsyncSnapshot<List<Surveillance>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var surveillances = snapshot.data!;
              return ListView.separated(
                itemCount: surveillances.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 2), // Spacing of 16 pixels between each item
                itemBuilder: (BuildContext context, int index) {
                  var surveillance = surveillances[index];
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
                          onTapConfirm: () async {
                            // print("Delete button clicked");
                            await delete(surveillance.id.toString());
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
                                      leading: Text(
                                        surveillance.superviseur,
                                        style: TextStyle( fontSize: 17),
                                      ),
                                      title: Text(
                                        surveillance.evaluation,
                                        style: TextStyle( fontSize: 17),
                                      ),

                                      subtitle:  isExpanded
                                          ? Text(
                                        "Salles: "+surveillance.salle.join(', '),
                                        style: TextStyle( fontSize: 16),
                                      ): null,
                                      // trailing:
                                      // Avatar(
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MasterPage(
                                              index: 0,accessToken: widget.accessToken,
                                              nomfil: widget.nomfil,
                                              nom_user: widget.nom_user,
                                              photo_user: widget.photo_user,
                                              child:
                                              SurveillanceForm(
                                                surveillance: surveillance, accessToken: widget.accessToken,        nomfil: widget.nomfil,
                                                nom_user: widget.nom_user,
                                                photo_user: widget.photo_user,
                                                                                                            ),),

                                          ),
                                        );
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
                    SurveillanceForm(      nomfil: widget.nomfil,
                    nom_user: widget.nom_user,
                    photo_user: widget.photo_user,surveillance: Surveillance(0,0,'',0,'',[],''), accessToken: widget.accessToken,),
                    ),

            ));

        },
        child: Icon(Icons.add),
      ),
      // ),
    );
  }
}
