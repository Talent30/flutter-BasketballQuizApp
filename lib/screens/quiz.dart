import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp/screens/result.dart';

class GetJson extends StatelessWidget {
  String Quizname;

  GetJson(this.Quizname);

  String assetToLoad;

  setAsset() {
    if (Quizname == "Basketball Quiz") {
      assetToLoad = "assets/basketball.json";
    } else {
      assetToLoad = "assets/nbaQuiz.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setAsset();
    // TODO: implement build
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(assetToLoad),
      builder: (context, snapshot) {
        List mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        } else {
          //pass data to the quiz screen
          return quizPage(myData: mydata);
        }
      },
    );
  }
}

class quizPage extends StatefulWidget {
  var myData;

  //ge data
  quizPage({Key key, @required this.myData}) : super(key: key);

  @override
  _quizpageState createState() => _quizpageState(myData);
}

class _quizpageState extends State<quizPage> {
  Color colorShow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;

  //score
  int marks = 0;
  //question count
  int i = 1;
  //timer
  int timer = 15;
  String showTimer = "15";
  //button color
  Map<String, Color> btnColor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent
  };

  //stop timer
  bool cancelTime = false;
  var mydata;

  _quizpageState(this.mydata);

  void nextQuestion() {
    cancelTime = false;
    timer = 15;
    setState(() {
      //if quiz is not finished
      if (i < 5) {
        //go to next one
        i++;
      } else {
        //finish
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => resultPage(marks: marks),
          ),
        );
      }
      btnColor["a"] = Colors.indigoAccent;
      btnColor["b"] = Colors.indigoAccent;
      btnColor["c"] = Colors.indigoAccent;
      btnColor["d"] = Colors.indigoAccent;
    });
    gameTimer();
  }

  void checkAnswer(String k) {
    //check the answer in the json file
    if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
      //update the marks
      marks = marks + 5;
      colorShow = right;
    } else {
      colorShow = wrong;
    }
    setState(
      () {
        btnColor[k] = colorShow;
        cancelTime = true;
      },
    );
    Timer(Duration(seconds: 1), nextQuestion);
  }

  @override
  void initState() {
    //get timer ready
    gameTimer();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void gameTimer() async {
    //time count down
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextQuestion();
          //if the cancel is true cancel the timmer start a new one
        } else if (cancelTime == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  showImage(String imagePath) {
    if (imagePath != "null") {
      return Container(
        child: Container(
          // changing  to look better
          height: 300,
          width: 300,
          child: ClipRect(
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage(imagePath),
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: Container(
          //  to look better
          child: ClipRect(),
        ),
      );
    }
  }

  Widget choiceButton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: MaterialButton(
        onPressed: () => checkAnswer(k),
        child: Text(
          mydata[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          maxLines: 1,
        ),
        color: btnColor[k],
        splashColor: Colors.indigoAccent[700],
        highlightColor: Colors.indigoAccent[700],
        minWidth: 200,
        height: 45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  mydata[0][i.toString()],
                  style: TextStyle(fontSize: 18),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(15),
              ),
            ),
            Expanded(
              child: showImage(mydata[3][i.toString()].toString()),
              flex: 3,
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    choiceButton('a'),
                    choiceButton('b'),
                    choiceButton('c'),
                    choiceButton('d')
                  ],
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(showTimer),
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Quizstart"),
            content: Text("You cannot quite the quiz at this stage"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }
}
