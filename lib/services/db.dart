import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({this.collection});

  updateData(int newValues) async {
    //get current user
    FirebaseUser user = await _auth.currentUser();
    //get user data
    DocumentReference reference = _db.collection('reports').document(user.uid);
    //update userdata merge to not override data
    return await reference
        .setData({'score': FieldValue.increment(newValues)}, merge: true);
  }
}
