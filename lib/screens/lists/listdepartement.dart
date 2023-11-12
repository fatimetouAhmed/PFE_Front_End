// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
// import 'package:pfe_front_flutter/screens/forms/departementform.dart';
// import '../../../constants.dart';
// import '../../consturl.dart';
// import '../../models/departement.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// class ListDepartement extends StatefulWidget {
//   final String accessToken;
//
//   ListDepartement({Key? key,required this.accessToken}) : super(key: key);
//
//   @override
//   State<ListDepartement> createState() => _ListDepartementState();
// }
//
// class _ListDepartementState extends State<ListDepartement> {
//   List<Departement> departementsList = [];
//
//   Future<List<Departement>> fetchDepartements() async {
//     var headers = {
//       "Authorization": "Bearer ${widget.accessToken}",
//     };
//     var response = await http.get(Uri.parse(baseUrl+'departements/'),headers: headers);
//     var departements = <Departement>[];
//     for (var u in jsonDecode(response.body)) {
//       departements.add(Departement(u['id'], u['nom']));
//     }
//     // print(departements);
//     return departements;
//   }
//
//   Future delete(id) async {
//     var headers = {
//       "Authorization": "Bearer ${widget.accessToken}",
//     };
//     await http.delete(Uri.parse(baseUrl+'departements/' + id),headers: headers);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDepartements().then((departements) {
//       setState(() {
//         departementsList = departements;
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return
//       // MasterPage(
//       // child:
//       SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: SizedBox(height: 190, child: _head()),
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Departements',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 19,
//                               color: Colors.black,
//                             ),
//                           ),
//
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MasterPage(
//                                         index: 0,
//                                         child:
//                                         DepartementForm(departement: Departement(0, ''),accessToken: widget.accessToken),accessToken: widget.accessToken,
//                                       ),
//                                 ),
//                                 // ),
//                               );
//                             },
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.white,
//                               size: 40.0,
//                               semanticLabel: 'Add',
//                               weight: 600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: kDefaultPadding / 2),
//                     Container(
//                       height: MediaQuery.of(context).size.height - 370,
//                       child:                    Scaffold(
//                         body: Container(
//                           margin: EdgeInsets.symmetric(
//                             horizontal: kDefaultPadding,
//                             vertical: kDefaultPadding / 2,
//                           ),
//                           child: FutureBuilder<List<Departement>>(
//                             future: fetchDepartements(),
//                             builder: (BuildContext context, AsyncSnapshot<List<Departement>> snapshot) {
//                               if (snapshot.connectionState == ConnectionState.waiting) {
//                                 return Center(child: CircularProgressIndicator());
//                               } else if (snapshot.hasError) {
//                                 return Center(child: Text('Error: ${snapshot.error}'));
//                               } else {
//                                 var departements = snapshot.data!;
//                                 return ListView.separated(
//                                   itemCount: departements.length,
//                                   separatorBuilder: (BuildContext context, int index) =>
//                                       SizedBox(height: 16), // Spacing of 16 pixels between each item
//                                   itemBuilder: (BuildContext context, int index) {
//                                     var departement = departements[index];
//                                     return InkWell(
//                                       child: Stack(
//                                         alignment: Alignment.bottomCenter,
//                                         children: <Widget>[
//                                           Container(
//                                             height: 136,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(22),
//                                               color: Colors.blueAccent,
//                                               boxShadow: [kDefaultShadow],
//                                             ),
//                                             child: Container(
//                                               margin: EdgeInsets.only(right: 10),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius: BorderRadius.circular(22),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             bottom: 0,
//                                             left: 0,
//                                             child: SizedBox(
//                                               height: 136,
//                                               width: size.width - 100,
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Spacer(),
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                                                     child: Row(
//                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                           departement.nom,
//                                                           style: Theme.of(context).textTheme.button,
//                                                         ),
//                                                         SizedBox(width: 8),
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             Navigator.push(
//                                                               context,
//                                                               MaterialPageRoute(
//                                                                 builder: (context) => MasterPage(
//                                                                   index: 0,
//                                                                   child:
//                                                                 DepartementForm(
//                                                                   departement: departement,accessToken: widget.accessToken
//                                                                 ),
//                                                                     accessToken:widget.accessToken ,),),
//                                                             );
//                                                           },
//                                                           child: Icon(
//                                                             Icons.edit,
//                                                             color: Colors.blueAccent,
//                                                             size: 24.0,
//                                                             semanticLabel: 'Edit',
//                                                           ),
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () async {
//                                                             Alert(
//                                                               context: context,
//                                                               type: AlertType.warning,
//                                                               title: "Confirmation",
//                                                               desc: "Are you sure you want to delete this item?",
//                                                               buttons: [
//                                                                 DialogButton(
//                                                                   child: Text(
//                                                                     "Cancel",
//                                                                     style: TextStyle(color: Colors.white, fontSize: 18),
//                                                                   ),
//                                                                   onPressed: () {
//                                                                     print("Cancel button clicked");
//                                                                     Navigator.pop(context);
//                                                                   },
//                                                                   color: Colors.red,
//                                                                   radius: BorderRadius.circular(20.0),
//                                                                 ),
//                                                                 DialogButton(
//                                                                   child: Text(
//                                                                     "Delete",
//                                                                     style: TextStyle(color: Colors.white, fontSize: 18),
//                                                                   ),
//                                                                   onPressed: () async {
//                                                                     await delete(departement.id.toString());
//                                                                     setState(() {});
//                                                                     Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                         builder: (context) => MasterPage(
//                                                                           index: 0,
//                                                                           child: ListDepartement(accessToken: widget.accessToken),accessToken: widget.accessToken,
//                                                                         ),
//                                                                       ),
//                                                                     );
//                                                                   },
//                                                                   color: Colors.blueAccent,
//                                                                   radius: BorderRadius.circular(20.0),
//                                                                 ),
//                                                               ],
//                                                             ).show();
//                                                           },
//                                                           child: Icon(
//                                                             Icons.delete,
//                                                             color: Colors.red,
//                                                             size: 24.0,
//                                                             semanticLabel: 'Delete',
//                                                           ),
//                                                         ),
//
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Spacer(),
//                                                   Container(
//                                                     padding: EdgeInsets.symmetric(
//                                                       horizontal: kDefaultPadding * 1.5,
//                                                       vertical: kDefaultPadding / 4,
//                                                     ),
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.blueAccent,
//                                                       borderRadius: BorderRadius.only(
//                                                         bottomLeft: Radius.circular(22),
//                                                         topRight: Radius.circular(22),
//                                                       ),
//                                                     ),
//                                                     child: Text(
//                                                       departement.id.toString(),
//                                                       style: Theme.of(context).textTheme.button,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         // ),
//       );
//   }
// }
//
// // const double kDefaultPadding = 20.0;
//
// Widget _head() {
//   return Stack(
//     children: [
//       Column(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 80,
//
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//           ),
//         ],
//       ),
//       Positioned(
//         top: 10,
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
//               SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Total des Departements',
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
//
//             ],
//           ),
//         ),
//       )
//     ],
//   );
// }
//
