import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
import 'package:pfe_front_flutter/bar/masterpagesurveillant.dart';
import 'package:pfe_front_flutter/screens/lists/listsemestre.dart';
import 'package:quickalert/quickalert.dart';
import '../../consturl.dart';
import '../../models/etudiant.dart';
import '../../models/pv.dart';
import '../../models/semestre.dart';
import '../lists/listetudiant.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'home.dart';
import 'notifications.dart'; // Import MediaType class

class PvForm extends StatefulWidget {
  final int id;
  final String description;
  final String nni;
  final int tel;
  final String photo;
  final String accessToken;
  final int id_user;
  final String nom_user;
  final String photo_user;

  PvForm({Key? key, required this.id,required this.nom_user,required this.photo_user,
    required this.accessToken, required this.description, required this.nni, required this.tel, required this.photo, required this.id_user}) : super(key: key);

  @override
  _PvFormState createState() => _PvFormState();
}

class _PvFormState extends State<PvForm> {

  TextEditingController idController = new TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nniController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController photoController = new TextEditingController();
  TextEditingController id_suvController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController nomController = new TextEditingController();
  FocusNode description = FocusNode();
  FocusNode nom = FocusNode();
  FocusNode type = FocusNode();
  FocusNode id_suv = FocusNode();
  FocusNode nni = FocusNode();
  // FocusNode photo = FocusNode();
  FocusNode tel = FocusNode();

  List<String> pvList = [];
  XFile? _image;
  final colors=Colors.blueAccent;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      idController.text = this.widget.id.toString();
      descriptionController.text = this.widget.description;
      nniController.text = this.widget.nni;
      telController.text = this.widget.tel.toString();
      photoController.text = this.widget.photo.toString();
    });

  }
  
  Future<void> save( int id, String nom, String type,int id_surv, String description,
      String nni,
      int tel,File imageFile) async {
    var request;
    if (id == 0) {
      request = http.MultipartRequest('POST', Uri.parse(baseUrl + 'api/pv'));
    }
    // else {
    //   request = http.MultipartRequest('PUT', Uri.parse(baseUrl+'etudiants/'+id.toString()));
    // }
    //print("Image path: ${imageFile.path}");
    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse(baseUrl+'api/pv'),
    // );
    request.headers['Authorization'] = 'Bearer ${widget.accessToken}';
    request.fields['nom'] = nom;
    request.fields['type'] = type;
    request.fields['id_surv'] = id_surv.toString();
    request.fields['description'] = description;
    request.fields['nni'] = nni;
    request.fields['tel'] = tel.toString();
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [

            background_container(context),
            Positioned(
              top: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height:500,
                width: 370,
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
                      Visibility(
                        visible: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            focusNode: id_suv,
                            controller: id_suvController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              labelText: 'Surveillance',
                              labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 2, color: colors,)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
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
                                borderSide: BorderSide(width: 2, color: colors,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          focusNode: description,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'description',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: colors,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          focusNode: nni,
                          controller: nniController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'NNI',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: colors,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          focusNode: tel,
                          controller: telController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'Telephone',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: colors,)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          focusNode: type,
                          controller: typeController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            labelText: 'Type',
                            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2, color: colors,)),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            getImage().then((_) => photoController.text=_image!.path.toString());
                            print(_image!.path) ;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,), // Icône de la caméra
                              // SizedBox(width: 8), // Espacement entre l'icône et le texte
                              // Text('Prendre une photo'),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Operation Completed Successfully!',
                            confirmBtnColor: colors,
                          ).then((value) async {
                            if (value == null) {
                              int? id = int.tryParse(idController.text);
                              int? idtel=int.tryParse(telController.text);
                              id_suvController.text=widget.id_user.toString();
                              int? id_surv = int.tryParse(id_suvController.text);
                              if (id != null && idtel != null && id_surv!=null) {
                                String imagePath = photoController.text; // Chemin du fichier image
                                File imageFile = File(imagePath);
                                print(_image!.name) ;
                                print(_image!) ;
                                print(photoController.text) ;
                                await save(
                                  id,
                                  nomController.text,
                                  typeController.text,
                                  id_surv,
                                  descriptionController.text,
                                    nniController.text,
                                    idtel,
                                  File(_image!.path),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>MasterPageSurveillant( index: 0,  accessToken: widget.accessToken
                                        ,id: widget.id_user,
                                        nom_user: widget.nom_user,
                                        photo_user: widget.photo_user,
                                        child: NotificationsSurveillant(accessToken: widget.accessToken, id: widget.id_user,),)
                                  ),
                                );

                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text("Invalid ID or Department ID"),
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
                            color:Colors.blueAccent,
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

                      SizedBox(height: 25),
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
          height: 240,
          decoration: BoxDecoration(
            color: colors,
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