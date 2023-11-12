import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pfe_front_flutter/screens/login/login_page.dart';

import '../screens/login_screen.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String nom_user;
  String photo_user;
   CustomAppBar({Key? key,required this.nom_user,required this.photo_user}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(30),
          // color: Colors.blueAccent,
        ),
        height: 200,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('images/users/'+photo_user),
                ),
                SizedBox(width: 5,),
                Text(nom_user, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  fontSize: 20
                )),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(accessToken: '', nomfil: '',),
                  ),
                );
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      automaticallyImplyLeading: false,
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    title: Text('Dashboard'),
    actions: <Widget>[
      IconButton(
        icon: SvgPicture.asset("assets/icons/notification.svg"),
        onPressed: () {},
      ),
    ],
  );
}
