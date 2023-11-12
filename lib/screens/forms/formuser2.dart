import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../bar/masterpageadmin.dart';
import '../../consturl.dart';
import '../../models/filliere.dart';
import '../../models/user.dart';
import '../lists/listfiliere.dart';
import 'package:quickalert/quickalert.dart';
import 'package:image_picker/image_picker.dart';
import '../lists/listuser.dart';
class UserForm2 extends StatefulWidget {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String pswd;
  final String role;
  final String photo;
  final int superviseur_id;
  final String typecompte;
  final String accessToken;
  final String nomfil;
  final String nom_user;
  final String photo_user;
  UserForm2( {Key? key, required this.id, required this.nom,
    required this.prenom, required this.email, required this.pswd,
    required this.role, required this.photo, required this.superviseur_id,required this.accessToken, required this.typecompte, required this.nomfil, required this.nom_user, required this.photo_user,}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm2> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();
  TextEditingController prenomController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController pswdController = new TextEditingController();
  TextEditingController roleController = new TextEditingController();
  TextEditingController photoController = new TextEditingController();
  TextEditingController superviseur_idController = new TextEditingController();
  TextEditingController compteController = new TextEditingController();
  FocusNode nom = FocusNode();
  FocusNode prenom = FocusNode();
  FocusNode email = FocusNode();
  FocusNode pswd = FocusNode();
  FocusNode role = FocusNode();
  //FocusNode photo = FocusNode();
  String? selectedOption;
  List<String> salleList = [''];
  String selectedSuperviseur='';
  int? fetchedId;
  String? selectedOption2;
  List<String> compteList = [
    "principale",
    "salle"
  ];
  int _selectedcomplete=0;
  int _selectedsuperviseur=0;
  String selectedCompte = "principale";
  int? idSup=0;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  // int? fetchedId;
  @override
  void initState() {
    super.initState();


      setState(() {
        salleList[0] = salleList[0];
        idController.text = this.widget.id.toString();
        nomController.text = this.widget.nom;
        prenomController.text = this.widget.prenom;
        emailController.text = this.widget.email;
        pswdController.text = this.widget.pswd;
        roleController.text = this.widget.role;
        photoController.text = this.widget.photo;
        superviseur_idController.text = this.widget.superviseur_id.toString();

      });

  }

  Future<List<User>> fetchUsers() async {
    var headers = {
      "Authorization": "Bearer ${widget.accessToken}",
    };
    var response = await http.get(Uri.parse(baseUrl+'user_data/'),headers: headers);
    var users = <User>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var nom = u['nom'];
      var prenom = u['prenom'];
      var email = u['email'];
      var role = u['role'];
      var photo=u['photo'];

      if (id != null && nom != null && prenom != null && email != null && role != null && photo != null) {
        users.add(User(id, nom, prenom, email,'', role,photo,0,'',''));
      } else {
        print('Incomplete data for Filiere object');
      }
    }

    // print(filieres);
    return users;
  }

  // Future<List<String>> fetchDepartements() async {
  //   var headers = {
  //     "Authorization": "Bearer ${widget.accessToken}",
  //   };
  //   var response = await http.get(Uri.parse(baseUrl+'nomsuperviseur/'),headers: headers);
  //
  //   if (response.statusCode == 200) {
  //     dynamic data = jsonDecode(response.body);
  //     Set<String> uniqueDepartments = {}; // Using a Set to ensure unique values
  //     for (var department in data) {
  //       uniqueDepartments.add(department['nom'] as String);
  //     }
  //     salleList= uniqueDepartments.toList(); // Convert back to a list
  //   }
  //   return salleList;
  // }


  // Future<int?> fetchSupervieursId(String nom) async {
  //   var headers = {
  //     "Authorization": "Bearer ${widget.accessToken}",
  //   };
  //   var response = await http.get(Uri.parse(baseUrl+'id_superviseur/$nom'),headers: headers);
  //
  //   if (response.statusCode == 200) {
  //     dynamic jsonData = json.decode(response.body);
  //     print(jsonData);
  //     return jsonData;
  //   }
  //
  //   return null;
  // }
  Future<void> save(
      int id,
      String nom, String prenom, String email, String pswd,
      String role,
      int superviseur_id,String typecompte
      ,File imageFile) async {
    var request;
    if (id == 0) {
      request = http.MultipartRequest('POST', Uri.parse(baseUrl+'registeruser/'));
    }
    else {
      request = http.MultipartRequest('PUT', Uri.parse(baseUrl + 'updateuser/$id'));
    }
    request.fields['user_id'] = id.toString();
    request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
    request.fields['nom'] = nom;
    request.fields['prenom'] = prenom;
    request.fields['email'] = email;
    request.fields['pswd'] = pswd;
    request.fields['role'] = 'superviseur';
    // request.fields['typecompte'] = typecompte;
    request.fields['superviseur_id'] = superviseur_id.toString();
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    print("image path");
    print(imageFile.path);
    var response = await request.send();
    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
    }else {
      print('Error uploading image: ${response.statusCode}');
    }

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [

              background_container(context),
              Positioned(
                top: 70,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  height: 400,
                  width: 340,
                  child: Form(
                    child: Column(
                      children: [
                        Visibility(
                          visible: false,
                          child: TextFormField(
                            decoration: InputDecoration(hintText: 'Entrez id'),
                            controller: idController,
                          ),
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              focusNode: nom,
                              controller: nomController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                labelText: 'nom',
                                labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),// Adjust the spacing between the two fields
                        Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              focusNode: prenom,
                              controller: prenomController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                labelText: 'prenom',
                                labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              focusNode: email,
                              controller: emailController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                labelText: 'email',
                                labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),// Adjust the spacing between the two fields
                        Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              focusNode: pswd,
                              controller: pswdController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                labelText: 'password',
                                labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(width: 2, color: Colors.blueAccent,)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Expanded(
                          child:
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                getImage().then((image) {
                                  if (image != null) {
                                    photoController.text = image.path.toString();
                                    print(image.path);
                                  }
                                });
                              },

                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo), // Icône de la caméra
                                  // SizedBox(width: 8), // Espacement entre l'icône et le texte
                                  // Text('Prendre une photo'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Operation Completed Successfully!',
                              confirmBtnColor: Colors.blueAccent,
                            ).then((value) async {
                              if (value == null) {
                                int? id = int.tryParse(idController.text);
                                int? idSup = int.tryParse(superviseur_idController.text);
                                print(_image!.name) ;
                                print(_image!) ;
                                if (id != null ) {
                                  if(idSup!=null) {
                                    await save(
                                      id,
                                      nomController.text,
                                      prenomController.text,
                                      emailController.text,
                                      pswdController.text,
                                      roleController.text,
                                      idSup,
                                      compteController.text,
                                      File(_image!.path),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MasterPage(index: 0,
                                                accessToken: widget.accessToken
                                                ,
                                                nomfil: widget.nomfil,
                                                nom_user: widget.nom_user,
                                                photo_user: widget.photo_user,
                                                child: ListUser(
                                                  accessToken: widget
                                                      .accessToken,nomfil: widget.nomfil,
                                                  nom_user: widget.nom_user,
                                                  photo_user: widget.photo_user,
                                                ),)
                                      ),
                                    );
                                  }
                                  else {
                                    await save(

                                      id,
                                      nomController.text,
                                      prenomController.text,
                                      emailController.text,
                                      pswdController.text,
                                      roleController.text,
                                      0,
                                      compteController.text,
                                      File(_image!.path),


                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MasterPage(index: 0,
                                                accessToken: widget.accessToken
                                                ,
                                                nomfil: widget.nomfil,
                                                nom_user: widget.nom_user,
                                                photo_user: widget.photo_user,
                                                child: ListUser(
                                                  accessToken: widget
                                                      .accessToken,nomfil: widget.nomfil,
                                                  nom_user: widget.nom_user,
                                                  photo_user: widget.photo_user,
                                                ),)
                                      ),
                                    );
                                  }
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Invalid ID or Superviseur ID"),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            });


                          },

                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blueAccent,
                            ),
                            width: 120,
                            height: 50,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'f',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  }

  Column background_container(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                child:   Center(
                  child: Text(
                    'Adding',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  //   ),
                  //
                  // ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
