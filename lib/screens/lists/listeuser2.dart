import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pfe_front_flutter/screens/views/viewuser.dart';

import '../../../constants.dart';

import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/filliere.dart';
import '../../models/user.dart';
import '../forms/filiereform.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../forms/userform.dart';

class ListUser2 extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  ListUser2({Key? key ,required this.accessToken,required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser2> {
  List<User> usersList = [];
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
  Future<List<User>> fetchUsers() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'scolarites/user_data/surveillant'),headers: headers);
    var users = <User>[];
    for (var u in jsonDecode(response.body)) {
      users.add(User(u['id'], u['nom'], u['prenom'],u['email'],'', u['role'], u['photo'],0,u['typecompte'],u['salle']));
    }
    print(users);
    return users;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'usersuveillant/$id'),headers: headers);
  }

  @override
  void initState() {
    super.initState();
    fetchUsers().then((users) {
      setState(() {
        usersList = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        width: 410,
        // margin: EdgeInsets.symmetric(
        //   // horizontal:100,
        //   vertical: 25,
        // ),
        child: FutureBuilder<List<User>>(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var users = snapshot.data!;
              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height:0 ), // Spacing of 16 pixels between each item
                itemBuilder: (BuildContext context, int index) {
                  var user = users[index];
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
                            await delete(user.id.toString());
                            setState(() {});
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
                        height: isExpanded ? 170.0 : 80.0,
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
                                        image: 'images/users/'+user.photo,
                                      ),
                                      title: Text(
                                        user.prenom+' '+user.nom,
                                        style: TextStyle( fontSize: 17),
                                      ),

                                      subtitle:  isExpanded
                                          ? Text(
                                        "Email : "+user.email+"\nRole: "+user.role+"\nType de Compte: "+user.typecompte+"\nSurveille la Salle : "+user.salle,
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
                                    right: 20,
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
                                              UserForm(
                                                 accessToken: widget.accessToken, id: user.id, nom: user.nom, prenom: user.prenom, email: user.email
                                                , pswd:user.pswd, role: user.role, photo: user.photo, superviseur_id: user.id_sal, typecompte: user.typecompte,
                                                salle: user.salle,
                                                nomfil: widget.nomfil,
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
                    UserForm(id: 0, nom: '', prenom: '', email: '', pswd: '', role: '', photo: '', superviseur_id: 0, accessToken: '', typecompte: '',                                          nomfil: widget.nomfil,
                      nom_user: widget.nom_user,
                      salle: '',
                      photo_user: widget.photo_user,),
                    ),

                  ),
            // ),
          );
        },
        child: Icon(Icons.add),
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