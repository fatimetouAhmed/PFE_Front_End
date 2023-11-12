import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_front_flutter/bar/masterpagesuperviseur.dart';
import 'package:pfe_front_flutter/screens/admin/dashbordAnne.dart';
import 'package:pfe_front_flutter/screens/admin/stats.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/screens/lists/listetudiant.dart';
import 'package:pfe_front_flutter/screens/lists/listeuser2.dart';
import 'package:pfe_front_flutter/screens/lists/listexamun.dart';
import 'package:pfe_front_flutter/screens/lists/listmatiere.dart';
import 'package:pfe_front_flutter/screens/lists/listpv.dart';
import 'package:pfe_front_flutter/screens/lists/listsalle.dart';
import 'package:pfe_front_flutter/screens/lists/listsurveillant.dart';
import 'package:pfe_front_flutter/screens/lists/listuser.dart';
import 'package:pfe_front_flutter/screens/login/login_page.dart';

import 'package:pfe_front_flutter/screens/login_screen.dart';
import 'package:pfe_front_flutter/screens/superviseur/GridViewWidgetSalle.dart';
import 'package:pfe_front_flutter/screens/surveillant/notifications.dart';
import 'bar/masterpageadmin.dart';
import 'bar/masterpageadmin2.dart';
import 'bar/masterpagesurveillant.dart';
import 'notification_manager/notification_manager.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  runApp(MyApp(accessToken:'', nomfil: '',));
}


class MyApp extends StatelessWidget {
  String accessToken;
  String nomfil;
  MyApp({Key? key,required this.accessToken,required this.nomfil}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:
      MasterPage2(index: 0,accessToken: '',nomfil:  'Informatique de gestion', nom_user: '',photo_user: '',
        child:
        PvHome(  accessToken:  '', nomfil: 'Informatique de gestion',),
      ),)
      //  LoginPage(accessToken: '', nomfil: '',),)
    ;

  }
}

