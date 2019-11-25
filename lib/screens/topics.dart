import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/screens/quiz.dart';
import 'package:quizapp/shared/drawer_nav.dart';

class TopicsScreen extends StatefulWidget {
  @override
  _topicsScreenState createState() => _topicsScreenState();
}

class _topicsScreenState extends State<TopicsScreen> {
  List<String> images = [
    "assets/quiz1.jpg",
    "assets/quiz2.jpg",
  ];

  List<String> des = [
    "Basketball is a team sportoriginated in the United States and is now popular among young people and enthusiasts.",
    "The National Basketball Association is a men's professional basketball league in North America, composed of 30 teams."
  ];

  Widget customCard(String quizName, String image, String des) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30.0,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.blueAccent,
        elevation: 10.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                //  we will pass the quiz name to the other widget class
                // this name will be used to open a particular JSON file
                // for a particular topic
                builder: (context) => GetJson(quizName),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    // changing from 200 to 150 as to look better
                    height: 250,
                    width: 300,
                    child: ClipRect(
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          image,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  quizName,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "Quando",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  des,
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.white, fontFamily: "Alike"),
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Topics')),
      drawer: AppDrawer(),
      body: ListView(
        children: <Widget>[
          customCard("Basketball Quiz", images[0], des[0]),
          customCard("NBA Quiz", images[1], des[1])
        ],
      ),
    );
  }
}
