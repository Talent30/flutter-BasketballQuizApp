import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/services/db.dart';

class resultPage extends StatefulWidget {
  int marks;

  resultPage({Key key, @required this.marks}) : super(key: key);

  @override
  _resultPageState createState() => _resultPageState(marks);
}

class _resultPageState extends State<resultPage> {
  //list of images for different result
  List<String> images = [
    "assets/bad.png",
    "assets/good.png",
    "assets/best.png"
  ];
  @override
  String message;
  String image;

  List L = [];

//show different result page base on the score
  void initState() {
    if (marks < 10) {
      image = images[0];
      message = "You should try hard..\n" + "You scored $marks";
    } else if (marks < 15) {
      image = images[1];
      message = "You can do better\n" + "You scored $marks";
    } else {
      image = images[2];
      message = "You did very well\n" + "You scored $marks";
    }
    super.initState();
  }

  int marks;

  _resultPageState(this.marks);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Result",
          ),
          //disable the return button on the app bar
          automaticallyImplyLeading: false),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Material(
              elevation: 5,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(image),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Center(
                        child: Text(message),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    //once user finished upload user marks
                    UserData().updateData(marks);
                    //back to topic screen
                    Navigator.of(context).pushReplacementNamed('/topics');
                  },
                  borderSide:
                      BorderSide(width: 5.0, color: Colors.indigoAccent),
                  splashColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
