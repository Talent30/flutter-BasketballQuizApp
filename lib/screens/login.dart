import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/shared/shared.dart';

import '../services/services.dart';

//this StatefulWidget is to determent if user has logged in
class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    //get the current user
    auth.getUser.then(
      (user) {
        //if user logged in go to the topics page
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              width: 200,
              height: 200,
              image: AssetImage(
                "assets/basketball.png",
              ),
            ),
            Text(
              'Quiz Basket',
              //theme of the text
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            Text('How much you know about basketball?',
                textAlign: TextAlign.center),
            LoginButton(
              text: 'LOGIN WITH GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.redAccent,
              loginMethod: auth.googleSignIn,
            ),
            LoginButton(
              text: 'LOGIN AS GUEST',
              icon: FontAwesomeIcons.robot,
              color: Colors.blueGrey,
              loginMethod: auth.anonLogin,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      child: FlatButton.icon(
        padding: EdgeInsets.all(15),
        icon: Icon(icon, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: color,
        onPressed: () async {
          LoadingScreen();
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
