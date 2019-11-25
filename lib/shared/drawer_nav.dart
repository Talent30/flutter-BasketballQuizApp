import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class AppDrawer extends StatelessWidget {
  final AuthService auth = AuthService();
  Future getRank() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('reports').getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Drawer(
      elevation: 1.5,
      child: Column(
        children: <Widget>[
          if (user != null)
            new UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? 'Guest'),
              accountEmail: Text(user.email ?? 'Welcome'),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    //get user info
                    image: NetworkImage(user.photoUrl ??
                        'https://ssl.gstatic.com/docs/common/profile/wombat_lg.png'),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text('User Profile'),
                  leading: Icon(Icons.supervised_user_circle),
                  onTap: () {
                    //go to profile screen
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  title: Text('Rank'),
                  leading: Icon(FontAwesomeIcons.sortAmountUp),
                  onTap: () {
                    //go to rank screen
                    Navigator.pushNamed(context, '/rank');
                  },
                ),
              ],
            ),
          ),
          new Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('About App'),
                      leading: Icon(Icons.info_outline),
                      onTap: () async {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    ListTile(
                      title: Text('Log Out'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () async {
                        await auth.signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
