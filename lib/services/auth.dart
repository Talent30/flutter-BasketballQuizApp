import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Firebase instance for SginIn
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //read user authentication state
  Future<FirebaseUser> get getUser => _auth.currentUser();

  //listen user state in the app life cycle
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  //anonymous login, return as a Future as firebase user
  Future<FirebaseUser> anonLogin() async {
    //wait for sign anonymously, make a call to firebase to tell firebase to create a user id
    FirebaseUser user = (await _auth.signInAnonymously()).user;
    //firebase database setup a report for the user, to track user progress
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    //if googleSignIn failed
    try {
      //start google sign in page
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      //create an authentication token
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //pass to the GoogleAuthProvider
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //user the credential put user as firebase user
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      updateUserData(user);

      return user;
    } catch (error) {
      return error;
    }
  }

  Future<void> updateUserData(FirebaseUser user) {
    //reference user in the database
    DocumentReference reference = _db.collection('reports').document(user.uid);
    //write user data, merge:true stop firebase override the information
    return reference.setData({
      'uid': user.uid,
      'lastActivity': DateTime.now(),
      'userName': user.displayName ?? 'Guest',
      'userImage': user.photoUrl ??
          'https://ssl.gstatic.com/docs/common/profile/wombat_lg.png'
    }, merge: true);
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
