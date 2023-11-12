import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pfe_front_flutter/screens/surveillant/addpv.dart';
import '../screens/surveillant/notifications.dart';
import 'package:http/http.dart' as http;

import 'appbar.dart';

class MasterPageSurveillant extends StatefulWidget {
  late final Widget child;
  final String accessToken;
  final int index;
  final int id;
  String nom_user;
  String photo_user;
  MasterPageSurveillant({
    Key? key,
    required this.child,
    required this.accessToken,
    required this.index, required this.id,required this.nom_user,required this.photo_user
  }) : super(key: key);

  @override
  _MasterPageSurveillantState createState() => _MasterPageSurveillantState();
}

class _MasterPageSurveillantState extends State<MasterPageSurveillant> {
 late Widget _currentWidget ; // Set a default value
  int _currentIndex = 0;
 Color defaultColor=Colors.blueAccent;
  final colors=Colors.blueAccent;
  @override
  void initState() {
    super.initState();
    _currentWidget = this.widget.child;
    _currentIndex = this.widget.index;
  }

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
          // _currentWidget = CameraScreen(accessToken: widget.accessToken);
          _currentWidget = NotificationsSurveillant(accessToken: widget.accessToken, id: widget.id,);
          break;
        case 1:
          _currentWidget = PvForm(accessToken: widget.accessToken, id: 0, description: '', nni: '', tel: 0, photo: '', id_user: widget.id,                nom_user: widget.nom_user,
            photo_user: widget.photo_user,);
          break;
      // case 2:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LoginScreen(accessToken: widget.accessToken),
      //     ),
      //   );
      //
      //   break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: CustomAppBar(),
      body: Container(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: CustomAppBar(nom_user: widget.nom_user,photo_user: widget.photo_user,),
          body: _currentWidget,
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       // StackWidgetFiliere(id: widget.id,)
          //       Stack(
          //         children: [
          //           Container(
          //             decoration: BoxDecoration(
          //               // borderRadius: BorderRadius.circular(30),
          //               color: colors,
          //             ),
          //             height: 200,
          //             child:
          //             ListTile(
          //               contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          //               title: Text('Hello Ahad!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //                   color: Colors.white
          //               )),
          //               subtitle: Text('Good Morning', style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                   color: Colors.white54
          //               )),
          //               trailing: const CircleAvatar(
          //                 radius: 30,
          //                 backgroundImage: AssetImage('images/image2.jpg'),
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(top: 130.0),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(30),
          //                   color: Colors.white
          //               ),
          //               height: 500,
          //               child: widget.child,
          //               // color: Colors.white,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          bottomNavigationBar:  CurvedNavigationBar(
            index: _currentIndex,
            height: 60.0,
            items: <Widget>[
              Icon(Icons.notification_important,size: 30, color: _currentIndex == 0 ? Colors.white : defaultColor),
              Icon(Icons.add, size: 30, color: _currentIndex == 1 ? Colors.white : defaultColor),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) => handleDestinationTap(index),
            letIndexChange: (index) => true,
          ),


        ),
      ),

    );
  }
}
