// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pfe_front_flutter/bar/masterpageadmin.dart';
// import 'package:pfe_front_flutter/screens/forms/addmatiereform.dart';
// import '../../../constants.dart';
// import '../../consturl.dart';
// import '../../models/etudiant.dart';
//
// import '../../models/pv.dart';
// import '../../models/user.dart';
// import '../../settings/babs_component_settings_group.dart';
// import '../../settings/babs_component_settings_item.dart';
// import '../forms/etudiantform.dart';
// class ViewPv extends StatefulWidget {
//   final String accessToken;
//   final int id;
//   ViewPv({Key? key, required this.accessToken, required this.id,
//     // required this.accessToken
//   }) : super(key: key);
//
//
//   @override
//   State<ViewPv> createState() => _ViewPvState();
// }
//
// class _ViewPvState extends State<ViewPv> {
//
//   List<Pv> pvsList = [Pv(0, '', '', '', '','',DateTime.parse('0000-00-00 00:00:00'))];
//
//   Future<List<Pv>> fetchPvs(id) async {
//     var headers = {
//       "Authorization": "Bearer ${widget.accessToken}",
//     };
//     var response = await http.get(Uri.parse(baseUrl+'pv/'+id),headers: headers);
//     var pvs = <Pv>[];
//     for (var u in jsonDecode(response.body)) {
//       pvs.add(Pv(u['id'], u['photo'], u['description'],u['nni'], u['tel'].toString(), u['surveillant'],DateFormat('yyyy-MM-dd').parse(u['date_pv'])));
//     }
//
//     return pvs;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPvs(widget.id.toString()).then((users) {
//       setState(() {
//         this.pvsList = users;
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return
//       Scaffold(
//         //  backgroundColor: Colors.white.withOpacity(.94),
//         body:
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: ListView(
//             children: [
//               // user card
//
//               CircleAvatar(
//                 radius: 70,
//                 child: ClipOval(
//                   child: Image.asset('images/pv/${pvsList[0].photo}',height: 150,width: 150,fit: BoxFit.cover,),
//                 ),
//               ),
//               SizedBox(height: 20,),
//               Expanded(child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),),
//                     gradient: LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomLeft,
//                       colors: [Colors.blueAccent, Colors.blueAccent],
//                       // colors: [Colors.black54,Color.fromRGBO(0, 41, 102, 1)]
//                     )
//                 ),
//                 child:
//                 SettingsGroup(
//                   settingsGroupTitle: '',
//                   items: [
//                     SettingsItem(
//                       onTap: () {},
//                       // icons: Icons.near_me,
//                       title:'Description   :    '+pvsList[0].description,
//                     ),
//                     SettingsItem(
//                       onTap: () {},
//                       // icons: CupertinoIcons.repeat,
//                       title:'NNI   :    '+pvsList[0].nni,
//                     ),
//                     SettingsItem(
//                       onTap: () {},
//                       // icons: CupertinoIcons.delete_solid,
//                       title:'telephone   :    '+ pvsList[0].tel,
//                       titleStyle: TextStyle(
//                         // color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SettingsItem(
//                       onTap: () {},
//                       // icons: CupertinoIcons.repeat,
//                       title:'Surveillant   :    '+pvsList[0].surveillant,
//                     ),
//                     SettingsItem(
//                       onTap: () {},
//                       // icons: CupertinoIcons.repeat,
//                       title:'Date Pv   :    '+DateFormat('yyyy-MM-dd').format(pvsList[0].date_pv),
//                     ),
//                   ],
//                 ),
//               )
//               )
//             ],
//           ),
//         ),
//       );
//
//   }
// }
//
