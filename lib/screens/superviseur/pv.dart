import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pfe_front_flutter/models/pv.dart';
import '../../consturl.dart';

class PvHomeSuperviseur extends StatefulWidget {
  String accessToken;
  int id;
  PvHomeSuperviseur({Key? key, required this.accessToken,required this.id}) : super(key: key);


  @override
  State<PvHomeSuperviseur> createState() => _PvHomeState();
}

class _PvHomeState extends State<PvHomeSuperviseur> {

  List<Pv> pvsList = [];
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
  Future<List<Pv>> fetchPvs(id) async {

    var response = await http.get(Uri.parse(baseUrl+'scolarites/pv/superviseur/$id'));
    var pvs = <Pv>[];
    var jsonResponse = jsonDecode(response.body);

    for (var u in jsonResponse) {
      var id = u['id'];
      var photo = u['photo'];
      var nom = u['nom'];
      var description= u['description'];
      var date_pv = DateFormat('yyyy-MM-dd').parse(u['date_pv']);
      var nni = u['nni'];
      var tel = u['tel'].toString();
      var surveillant = u['surveillant'];
      var type = u['type'];
      var etat = u['etat'];
      pvs.add(Pv(id,nom, photo, description,nni,tel,surveillant,date_pv,type,etat));
    }
    return pvs;
  }
Future update(id) async {
    await http.put(Uri.parse(baseUrl+'scolarites/pv/' + id));
  }
  Future updaterefuser(id) async {
    await http.put(Uri.parse(baseUrl+'scolarites/pv/refuser/' + id));
  }
  @override
  void initState() {
    super.initState();
    fetchPvs(widget.id).then((pv) {
      setState(() {
        this.pvsList = pv;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        width: 410,
        child: FutureBuilder<List<Pv>>(
          future: fetchPvs(widget.id),
          builder: (BuildContext context, AsyncSnapshot<List<Pv>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var pvs = snapshot.data!;
              return ListView.separated(
                itemCount: pvs.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height:0 ), // Spacing of 16 pixels between each item
                itemBuilder: (BuildContext context, int index) {
                  var pv = pvs[index];
                  bool isExpanded = expandedStates.containsKey(index) ? expandedStates[index]! : false;
                  return GestureDetector(
                      onTap: () {
                        toggleCardSize(index);
                      },
                      child: Container(
                        width: 400,
                        height: isExpanded ? 300.0 : 120.0,
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
                                        image: 'images/pv/'+pv.photo,
                                      ),
                                      title: Text(
                                        pv.nom,
                                        style: TextStyle( fontSize: 17),
                                      ),

                                      subtitle:  isExpanded
                                          ? Text(
                                        "NNi : "+pv.nni+"\nTelephone : " +pv.tel+"\nNom : "+pv.nom+"\nType : " +pv.type+"\nDescription : " +pv.description+"\nEtat : " +pv.etat,
                                        style: TextStyle( fontSize: 16),
                                      ): null,
                                      trailing:  Text(
                                        DateFormat('yyyy-MM-dd HH:mm').format(pv.date_pv) ,
                                        style: TextStyle( fontSize: 17),
                                      ),
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
                                    right: 80,
                                    child: InkWell(
                                      onTap: () {
                                        PanaraConfirmDialog.showAnimatedGrow(
                                          context,
                                          title: "Confirmation",
                                          message: "Êtes-vous sûr de bien vouloir accepter  cet procès verbals?",
                                          confirmButtonText: "Accepter",
                                          cancelButtonText: "Annuler",
                                          onTapCancel: () {
                                            Navigator.pop(context);
                                          },
                                          onTapConfirm: () async {
                                            // print("Delete button clicked");
                                            await update(pv.id.toString());
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          panaraDialogType: PanaraDialogType.normal,
                                        );
                                      },
                                      child: Container(
                                        child: Text("Accepter",style: TextStyle(color: Colors.blueAccent),),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 15,),
                                if (isExpanded)
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        PanaraConfirmDialog.showAnimatedGrow(
                                          context,
                                          title: "Confirmation",
                                          message: "Êtes-vous sûr de bien vouloir refuser  cet procès verbals?",
                                          confirmButtonText: "Refuser",
                                          cancelButtonText: "Annuler",
                                          onTapCancel: () {
                                            Navigator.pop(context);
                                          },
                                          onTapConfirm: () async {
                                            // print("Delete button clicked");
                                            await updaterefuser(pv.id.toString());
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          panaraDialogType: PanaraDialogType.normal,
                                        );
                                      },
                                      child: Container(
                                        child: Text("Refuser",style: TextStyle(color: Colors.red),),
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
    );

  }
}

// const double kDefaultPadding = 20.0;


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