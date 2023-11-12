import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pfe_front_flutter/screens/forms/formuser2.dart';
import 'package:pfe_front_flutter/screens/views/viewuser.dart';

import '../../../constants.dart';

import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/filliere.dart';
import '../../models/user.dart';
import '../forms/filiereform.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../forms/userform.dart';

class ListUser extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  ListUser({Key? key ,required this.accessToken,required this.nomfil,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
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
    var response = await http.get(Uri.parse(baseUrl+'scolarites/user_data/'),headers: headers);
    var users = <User>[];
    for (var u in jsonDecode(response.body)) {
      users.add(User(u['id'], u['nom'], u['prenom'],u['email'],'', u['role'], u['photo'],0,'',''));
    }
    print(users);
    return users;
  }

  Future delete(id) async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    await http.delete(Uri.parse(baseUrl+'usersuperviseur/$id'),headers: headers);
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
    return      Scaffold(
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
                        height: isExpanded ? 150.0 : 80.0,
                        child: Card(
                          elevation: 9,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          child:      Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: 27, // Vous pouvez ajuster cette valeur selon vos besoins
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
                                        "Email : "+user.email+"\nRole: "+user.role,
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
                                              UserForm2(
                                                accessToken: widget.accessToken, id: user.id, nom: user.nom, prenom: user.prenom, email: user.email
                                                , pswd:user.pswd, role: user.role, photo: user.photo, superviseur_id: user.id_sal, typecompte: user.typecompte,

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
                    UserForm2(id: 0, nom: '', prenom: '', email: '', pswd: '', role: '', photo: '', superviseur_id: 0, accessToken: '', typecompte: '', nomfil: widget.nomfil,
                    nom_user: widget.nom_user,
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
                      'Total des Superviseurs',
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