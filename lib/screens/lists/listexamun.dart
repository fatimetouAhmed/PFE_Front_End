import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/models/examun.dart';
import 'package:pfe_front_flutter/screens/views/viewexamun.dart';
import '../../../constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../bar/masterpageadmin.dart';
import '../../bar/masterpageadmin2.dart';
import '../../consturl.dart';
import '../forms/examunform.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
class ListExamun extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  ListExamun({Key? key,required this.accessToken, required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  _ListExamunState createState() => _ListExamunState();
}

class _ListExamunState extends State<ListExamun> {
  List<Examun> examunList = [];
  Map<int, bool> expandedStates = {};
  Color _getAvatarColor(int index) {
    final List<Color> couleurs = [Colors.pinkAccent ,Colors.blueAccent,Colors.purple,Colors.blueGrey, Colors.orange, Colors.pink, Colors.amber, Colors.lightBlue];
    return couleurs[index % couleurs.length];
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
  Future<List<Examun>> fetchExamuns(String nomfil) async {

    var response = await http.get(Uri.parse(baseUrl+'scolarites/evaluations/$nomfil'));
    var examuns = <Examun>[];
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse is List) {
      for (var u in jsonResponse) {
        // print(u['heure_deb']);
        // print(u['heure_fin']);

        var heureDeb = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_deb']);
        var heureFin = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(u['heure_fin']);

        examuns.add(Examun(
            u['id'],
            u['type'],
            heureDeb,
            heureFin,
            u['id_mat'],
            u['id_sal'],
            u['matiere'],
            u['salle'],
          u['id_jour'],
          u['jour'],
        ));
      }
    }
    else {
      print("La réponse JSON ne contient pas une liste d'examuns.");
    }
    print(examuns);
    return examuns;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    print(id);
    await http.delete(Uri.parse(baseUrl+'scolarites/' + id),headers: headers);
  }

  @override
  void initState() {
    super.initState();
    fetchExamuns(widget.nomfil).then((examun) {
      setState(() {
        examunList = examun;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return    Scaffold(
      body: Container(
        // margin: EdgeInsets.symmetric(
        //   // horizontal: kDefaultPadding,
        //   vertical: 0,
        // ),
        child: FutureBuilder<List<Examun>>(
          future: fetchExamuns(widget.nomfil),
          builder: (BuildContext context, AsyncSnapshot<List<Examun>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var examuns = snapshot.data!;
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20),
                itemCount: examuns.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox.shrink(),
                itemBuilder: (BuildContext context, int index) {
                  var examun = examuns[index];
                  bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                  // Créez un avatar avec une couleur basée sur l'index
                  CircleAvatar avatar = CircleAvatar(
                    radius: 24,
                    backgroundColor: _getAvatarColor(index),
                    child: Text(
                      examun.type.isNotEmpty ? examun.type[0].toUpperCase() : '',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  );
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
                          await delete(examun.id.toString());
                          setState(() {});
                          Navigator.pop(context);
                        },
                        panaraDialogType: PanaraDialogType.normal,
                      );
                    },
                    child: Container(
                      width: 400,
                      height: isExpanded ? 170.0 : 90.0,
                      child: Card(
                        margin: EdgeInsets.all(5),
                        elevation: 9,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5)),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 28,
                              right: 10,
                              child: Container(child: Icon(Icons.arrow_forward_ios, size: 20)),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  dense: false,
                                  leading: avatar,
                                  title:
                                  Text(
                                    examun.type,
                                    style: TextStyle(fontSize: 17),
                                  ),

                                  subtitle: isExpanded
                                      ? Text(
                                      "Date Debut  : " + DateFormat('yyyy-MM-dd HH:mm').format(examun.date_deb) + "\nDate fin  : " + DateFormat('yyyy-MM-dd HH:mm').format(examun.date_fin) + "\nMatiere : " + examun.matiere + "\nSalle : " + examun.salle,
                                    style: TextStyle(fontSize: 16),
                                  )
                                      : null,
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
                                          index: 0,
                                          accessToken: widget.accessToken,
                                          nomfil: widget.nomfil,
                                          nom_user: widget.nom_user,
                                          photo_user: widget.photo_user,
                                          child: ExamunForm(
                                            examun: examun,
                                            accessToken: widget.accessToken,
                                            nomfil: widget.nomfil,
                                            nom_user: widget.nom_user,
                                            photo_user: widget.photo_user,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Icon(Icons.edit, color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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
                    ExamunForm(examun: Examun(0, '', DateTime.parse('0000-00-00 00:00:00'),DateTime.parse('0000-00-00 00:00:00'), 0, 0,'','',0,''),  accessToken: widget.accessToken, nomfil: widget.nomfil,                nom_user: widget.nom_user,
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
