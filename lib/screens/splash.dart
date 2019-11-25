import 'dart:async';

import 'package:flutter/material.dart';

import '../services/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AuthService auth = AuthService();
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _animation = new CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animation.addListener(() => this.setState(() {}));
    _animationController.forward();
    auth.getUser.then(
      //get user
      (user) {
        //if user not logged in go to login page
        if (user == null) {
          Timer(
            Duration(seconds: 3),
            () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          );
        } else {
          Timer(
            //time duration for the screen, go to main page after
            Duration(seconds: 3),
            () {
              Navigator.of(context).pushReplacementNamed('/topics');
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Text(
          "Quiz Basket",
          style: TextStyle(fontSize: 50, color: Colors.white),
        ),
      ),
    );
  }
}
