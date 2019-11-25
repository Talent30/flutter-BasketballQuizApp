import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/screens/profile.dart';
import 'package:quizapp/screens/splash.dart';

import 'screens/about.dart';
import 'screens/login.dart';
import 'screens/ranking.dart';
import 'screens/topics.dart';
import 'services/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //provider will make user global to get the data
      providers: [
        StreamProvider<FirebaseUser>.value(stream: AuthService().user)
      ],
      child: MaterialApp(
        // Named Routes
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/topics': (context) => TopicsScreen(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen(),
          '/rank': (context) => RankPageState()
        },

        // Theme
        theme: ThemeData(
          fontFamily: 'Product Sans',
          brightness: Brightness.light,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 20),
            body2: TextStyle(fontSize: 18),
            button: TextStyle(
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
            headline: TextStyle(fontWeight: FontWeight.bold),
            subhead: TextStyle(color: Colors.black),
          ),
          buttonTheme: ButtonThemeData(),
        ),
      ),
    );
  }
}
