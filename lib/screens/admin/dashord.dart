import 'package:flutter/material.dart';
import 'package:pfe_front_flutter/screens/lists/listdepartement.dart';
import 'package:pfe_front_flutter/screens/lists/listetudiant.dart';
import 'package:pfe_front_flutter/screens/lists/listexamun.dart';
import 'package:pfe_front_flutter/screens/lists/listfiliere.dart';
import 'package:pfe_front_flutter/screens/lists/listsalle.dart';

import '../../bar/masterpageadmin.dart';
import '../lists/listmatiere.dart';
import '../lists/listsemestre.dart';
class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    paint.color = Colors.blueAccent!;
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
class DashBoard extends StatelessWidget {
  late Size size;
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
  DashBoard({required this.accessToken, required this.nomfil,required this.nom_user,required this.photo_user});
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Scaffold(
        body: Stack(
          children: [
            Container(
              child: CustomPaint(
                painter: ShapesPainter(),
                child: Container(
                  height: size.height / 2,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20,),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          width: 200,
                          height: 200,// Vous pouvez ajuster ce nombre pour changer la largeur
                          child: createGridItem(0),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                          width: 200,
                          height: 200,// Vous pouvez ajuster ce nombre pour changer la largeur
                          child: createGridItem(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
  Widget createGridItem(int position) {
    Color? color = Colors.white;
    late Widget icondata;
    late Widget child_widget;
    // Use late to indicate it will be assigned before use
    String label='Années';
    switch (position) {
      case 0:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/students.png'),);
        label='Etudiants';
        child_widget= MasterPage(index: 0,accessToken: accessToken,nomfil: nomfil,                nom_user: nom_user,
          photo_user: photo_user, child: EtudiantHome(  accessToken: accessToken, nomfil:nomfil,                nom_user: nom_user,
            photo_user: photo_user,),);
        break;
      case 1:
        color = Colors.white;
        icondata = CircleAvatar(radius: 30, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/matieres.png'),);
        label='Matieres';child_widget= MasterPage(index: 0,accessToken: accessToken,nomfil: nomfil,                nom_user: nom_user,
          photo_user: photo_user, child: MatiereHome(  accessToken: accessToken,  nomfil: nomfil,                nom_user: nom_user,
            photo_user: photo_user,),);
        break;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
          child: Card(
            elevation: 10,
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.white),
            ),
            child: InkWell(
              onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Selected Item $position")),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => child_widget,
                  ),
                );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icondata,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}