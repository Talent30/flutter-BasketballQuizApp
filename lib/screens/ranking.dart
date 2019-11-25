import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/shared/loader.dart';

class RankPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ranking'),
      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future getRank() async {
    //initial the database get data
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('reports')
        .orderBy('score', descending: true)
        .getDocuments();

    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: FutureBuilder(
        future: getRank(),
        builder: (_, snapshot) {
          //while waiting for the database return a loading screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return new Container(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 55,
                                height: 55,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data[index].data['userImage']
                                        .toString(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Text(
                                snapshot.data[index].data['userName']
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Container(
                            child: Text(
                              'Score: ' +
                                  snapshot.data[index].data['score'].toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                //title: Text(snapshot.data[index].data['score'].toString()),
              },
            );
          }
        },
      ),
    );
  }
}
