import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/shared/loader.dart';

import '../services/services.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  //if user does not have any score record
  String score(String score) {
    if (score == "null") {
      return "Your score is: 0";
    } else {
      return "Your score is: " + score.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    //access fireBase userdata
    return StreamBuilder(
        stream: Firestore.instance
            .collection("reports")
            .document(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(user.photoUrl ??
                              'https://ssl.gstatic.com/docs/common/profile/wombat_lg.png'),
                        ),
                      ),
                    ),
                    Text(user.displayName ?? 'Guest'),
                    //print user score
                    Text(score(snapshot.data['score'].toString())),
                  ],
                ),
              ),
            );
          }
        });
  }
}
