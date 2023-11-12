// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pfe_front_flutter/screens/forms/semestre_etudiant.dart';
// import 'package:pfe_front_flutter/screens/views/viewsemestrematiere.dart';
// import '../../../constants.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import '../../bar/masterpageadmin.dart';
// import '../../bar/masterpageadmin2.dart';
// import '../../consturl.dart';
// import '../../models/semestre_etudiant.dart';
// import '../../models/semestresmatieres.dart';
// import '../forms/semestre_matiereform.dart';
//
// class ListSemestre_Matiere extends StatefulWidget {
//   final String accessToken;
//
//   ListSemestre_Matiere({Key? key,required this.accessToken}) : super(key: key);
//
//   @override
//   _ListSemestre_MatiereState createState() => _ListSemestre_MatiereState();
// }
//
// class _ListSemestre_MatiereState extends State<ListSemestre_Matiere> {
//   List<SemestresMatieres> semestre_matieresList = [];
//
//   Future<List<SemestresMatieres>> fetchSemestre_Matieres() async {
//     var headers = {
//       "Authorization": "Bearer ${widget.accessToken}",
//     };
//     var response = await http.get(Uri.parse(baseUrl+'semestresmatieres/read'),headers: headers);
//     var semestre_matieres = <SemestresMatieres>[];
//     var jsonResponse = jsonDecode(response.body);
//
//     for (var u in jsonResponse) {
//       var id = u['id'];
//       var id_sem = u['id_sem'];
//       var id_mat = u['id_mat'];
//       var matiere = u['matiere_libelle'];
//       var semestre = u['semestre'];
//
//       if (id != null && id_sem != null && id_mat!= null && matiere != null && semestre != null) {
//         semestre_matieres.add(SemestresMatieres(id, id_sem, id_mat,matiere,semestre));
//       }
//       // else {
//       //   print('Incomplete data for Semestre Matiere object');
//       // }
//     }
//     return semestre_matieres;
//   }
//
//   Future delete(id) async {
//     var headers = {
//       "Authorization": "Bearer ${widget.accessToken}",
//     };
//     await http.delete(Uri.parse(baseUrl+'semestresmatieres/' + id),headers: headers);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSemestre_Matieres().then((semestre_matiere) {
//       setState(() {
//         semestre_matieresList = semestre_matiere;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return      SafeArea(
//       child: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: SizedBox(height: 340, child: _head()),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Smestres Matieres',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 19,
//                             color: Colors.black,
//                           ),
//                         ),
//
//                         ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     MasterPage(
//                                       index: 0,accessToken: widget.accessToken,
//                                       child:
//                                       Semestre_MatiereForm(semestre_matiere: SemestresMatieres(0,0,0,'',''),  accessToken: widget.accessToken
//                                       ),
//                                     ),
//                               ),
//                               // ),
//                             );
//                           },
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 40.0,
//                             semanticLabel: 'Add',
//                             weight: 600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: kDefaultPadding / 2),
//                   Container(
//                     height: MediaQuery.of(context).size.height - 370,
//                     child:Scaffold(
//                       body: Container(
//                         margin: EdgeInsets.symmetric(
//                           horizontal: kDefaultPadding,
//                           vertical: kDefaultPadding / 2,
//                         ),
//                         child: FutureBuilder<List<SemestresMatieres>>(
//                           future: fetchSemestre_Matieres(),
//                           builder: (BuildContext context, AsyncSnapshot<List<SemestresMatieres>> snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             } else if (snapshot.hasError) {
//                               return Center(child: Text('Error: ${snapshot.error}'));
//                             } else {
//                               var semestre_matieres = snapshot.data!;
//                               return ListView.separated(
//                                 itemCount: semestre_matieres.length,
//                                 separatorBuilder: (BuildContext context, int index) =>
//                                     SizedBox(height: 16), // Spacing of 16 pixels between each item
//                                 itemBuilder: (BuildContext context, int index) {
//                                   var semestre_matiere = semestre_matieres[index];
//                                   return InkWell(
//                                     child: Stack(
//                                       alignment: Alignment.bottomCenter,
//                                       children: <Widget>[
//                                         Container(
//                                           height: 136,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(22),
//                                             color: Colors.blueAccent,
//                                             boxShadow: [kDefaultShadow],
//                                           ),
//                                           child: Container(
//                                             margin: EdgeInsets.only(right: 10),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.circular(22),
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           bottom: 0,
//                                           left: 0,
//                                           child: SizedBox(
//                                             height: 136,
//                                             width: size.width - 100,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Spacer(),
//                                                 Padding(
//                                                   padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         semestre_matiere.semestres,
//                                                         style: Theme.of(context).textTheme.button,
//                                                       ),
//                                                       SizedBox(width: 8),
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) => MasterPage(
//                                                                 index: 0,accessToken: widget.accessToken,
//                                                                 child:
//                                                                 Semestre_MatiereForm(
//                                                                     semestre_matiere: semestre_matiere,  accessToken: widget.accessToken
//
//                                                                 ),),
//
//                                                             ),
//                                                           );
//                                                         },
//                                                         child: Icon(
//                                                           Icons.edit,
//                                                           color: Colors.blueAccent,
//                                                           size: 24.0,
//                                                           semanticLabel: 'Edit',
//                                                         ),
//                                                       ),
//                                                       GestureDetector(
//                                                         onTap: () async {
//                                                           Alert(
//                                                             context: context,
//                                                             type: AlertType.warning,
//                                                             title: "Confirmation",
//                                                             desc: "Are you sure you want to delete this item?",
//                                                             buttons: [
//                                                               DialogButton(
//                                                                 child: Text(
//                                                                   "Cancel",
//                                                                   style: TextStyle(color: Colors.white, fontSize: 18),
//                                                                 ),
//                                                                 onPressed: () {
//                                                                   print("Cancel button clicked");
//                                                                   Navigator.pop(context);
//                                                                 },
//                                                                 color: Colors.red,
//                                                                 radius: BorderRadius.circular(20.0),
//                                                               ),
//                                                               DialogButton(
//                                                                 child: Text(
//                                                                   "Delete",
//                                                                   style: TextStyle(color: Colors.white, fontSize: 18),
//                                                                 ),
//                                                                 onPressed: () async {
//                                                                   await delete(semestre_matiere.id.toString());
//                                                                   setState(() {});
//                                                                   Navigator.push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                       builder: (context) => MasterPage(
//                                                                         index: 0,accessToken: widget.accessToken,
//                                                                         child: ListSemestre_Matiere(accessToken: widget.accessToken),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                                 color: Colors.blueAccent,
//                                                                 radius: BorderRadius.circular(20.0),
//                                                               ),
//                                                             ],
//                                                           ).show();
//                                                         },
//                                                         child: Icon(
//                                                           Icons.delete,
//                                                           color: Colors.red,
//                                                           size: 24.0,
//                                                           semanticLabel: 'Delete',
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Spacer(),
//                                                 Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: kDefaultPadding * 1.5,
//                                                     vertical: kDefaultPadding / 4,
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.blueAccent,
//                                                     borderRadius: BorderRadius.only(
//                                                       bottomLeft: Radius.circular(22),
//                                                       topRight: Radius.circular(22),
//                                                     ),
//                                                   ),
//                                                   child: IconButton(
//                                                     icon: Icon(
//                                                       Icons.remove_red_eye_outlined,
//                                                       size: 30, // Taille de l'icône
//                                                       color: Colors.white, // Couleur de l'icône
//                                                     ),
//                                                     onPressed: () {
//                                                       print(semestre_matiere.id);
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) => MasterPage(
//                                                             index: 0,  accessToken: widget.accessToken,
//                                                             child:
//                                                             ViewSemestreMatiere(  accessToken: widget.accessToken, id: semestre_matiere.id,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       // ),
//     );
//   }
// }
//
//
// Widget _head() {
//   return Stack(
//     children: [
//       Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 240,
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 35,
//                   left: 340,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(7),
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       color: Color.fromRGBO(250, 250, 250, 0.1),
//                       child: Icon(
//                         Icons.notification_add_outlined,
//                         size: 30,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 35, left: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Gestion des Semestre Matieres',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       Positioned(
//         top: 140,
//         left: 37    ,
//         child: Container(
//           height: 140,
//           width: 340,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blueGrey,
//                 offset: Offset(0, 6),
//                 blurRadius: 12,
//                 spreadRadius: 6,
//               ),
//             ],
//             color: Colors.blueAccent,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total des Semestre Matieres',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Icon(
//                       Icons.more_horiz,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 7),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15),
//                 child: Row(
//                   children: [
//                     Text(
//                       '65',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 25),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 13,
//                           backgroundColor: Colors.blueAccent,
//                           child: Icon(
//                             Icons.arrow_downward,
//                             color: Colors.white,
//                             size: 19,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 13,
//                           backgroundColor: Colors.blueAccent,
//                           child: Icon(
//                             Icons.arrow_upward,
//                             color: Colors.white,
//                             size: 19,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 6),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '15',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 17,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       '50',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 17,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       )
//     ],
//   );
// }
