import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfe_front_flutter/screens/superviseur/pv.dart';
import '../screens/superviseur/GridViewWidgetSalle.dart';
import '../screens/superviseur/notifications.dart';
import 'package:http/http.dart' as http;

import 'appbar.dart';

class MasterPageSupeurviseur extends StatefulWidget {

  late final Widget child;
  final String accessToken;
  final int index;
  final int id;
  String nom_user;
  String photo_user;
  MasterPageSupeurviseur({
    Key? key,
    required this.child,
    required this.accessToken,
    required this.index, required this.id,required this.nom_user,required this.photo_user
  }) : super(key: key);

  @override
  _MasterPageSupeurviseurState createState() => _MasterPageSupeurviseurState();
}

class _MasterPageSupeurviseurState extends State<MasterPageSupeurviseur> {
  late Widget _currentWidget ;
  // = Notifications(accessToken: ''); // Set a default value
  int _currentIndex = 0;
  Color defaultColor=Colors.blueAccent;
  @override
  void initState(){
    super.initState();
    _currentWidget=this.widget.child;
    _currentIndex=this.widget.index;
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _currentWidget = this.widget.child;
  //   _currentIndex = this.widget.index;
  // }

  Future<int> fetchCountNotifications() async {
    try {
      var headers = {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Bearer ${widget.accessToken}",
      };
      var response = await http.get(
        Uri.parse('http://192.168.186.113:8000/notifications/nb_notifications_no_read/'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        int count = jsonData as int;
        return count;
      } else {
        // Handle error scenarios, such as when the API call fails
        print('API Error: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Exception during API call: $e');
      return 0;
    }
  }

  void handleDestinationTap(int selectedIndex) {
    setState(() {
      _currentIndex = selectedIndex;
      switch (selectedIndex) {
        case 0:
          _currentWidget =GridViewWidgetSalle(accessToken: widget.accessToken, id_user:widget.id, nom_user: widget.nom_user, photo_user: widget.photo_user ,);
          break;
        case 1:
          _currentWidget = NotificationsSuperviseur(accessToken: widget.accessToken, id: widget.id,);
          break;
       case 2:
         _currentWidget = PvHomeSuperviseur(accessToken: widget.accessToken, id:widget.id,);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => LoginPage(accessToken: widget.accessToken, nomfil: '',),
          //   ),
          // );
        default:
        // Handle default case or leave empty if not needed
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer:NavBar(accessToken:widget.accessToken,),
      appBar: CustomAppBar(nom_user: widget.nom_user, photo_user: widget.photo_user,),
      body:  _currentWidget,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: _currentIndex == 0 ? Colors.white : defaultColor),
          Icon(Icons.notification_important, size: 30, color: _currentIndex == 1 ? Colors.white : defaultColor),
          Icon(Icons.home_mini_outlined,size: 30, color: _currentIndex == 2 ? Colors.white : defaultColor),
          // // Icon(Icons.monitor, size: 30, color: _currentIndex == 3 ? Colors.white : defaultColor),
          // Icon(Icons.info_rounded, size: 30, color: _currentIndex == 3 ? Colors.white : defaultColor),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) => handleDestinationTap(index),
        letIndexChange: (index) => true,
      ),
    );
  }
}
