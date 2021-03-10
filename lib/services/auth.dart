import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/models/userData.dart';
import 'package:dating_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // create user obj based on firebase user
  User _userFromFirebaseUser(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges()
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      auth.UserCredential result = await _auth.signInAnonymously();
      auth.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).setUserData(
        uid: user.uid,
        isNewUser: true,
        lid: 'null',
        name: 'new member',
        gender: 'Male',
        age: 2003,
        height: 180,
        wantToBePaired: true,
        wantToBePairedRandomly: true,
        avatarUrl: 'https://image.freepik.com/free-icon/important-person_318-10744.jpg',
        hairLength: 'Short',
        hairColor: 'Brown',
        cigarettes: 'I prefer not to say',
        alcohol: 'I prefer not to say',
        position: GeoPoint(52.22, 21.01),
        interests: [true, true, true, true, true, true, true, true, true],
        isPositionUpdated: false,
        isUserProfileUpdated: false,
        isLoverProfileUpdated: false,
        politics: "Other",
        pairedDate: 1577833200000,
      );
      await DatabaseService(uid: user.uid).setLoverData(
        gender: 'Female',
        ageMin: 18,
        ageMax: 120,
        heightMin: 160,
        heightMax: 180,
        hairColor: 'Brown',
        hairLength: 'Short',
        cigarettes: 'I prefer not to say',
        alcohol: 'I prefer not to say',
        distance: 500,
        interests: [true, true, true, true, true, true, true, true, true],
        haveAvatar: false,
        politics: "Other",
      );
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
        print("Google user sign out");
        await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign in with google
  Future signInWithGoogle() async{
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      auth.UserCredential authResult = await _auth.signInWithCredential(credential);
      auth.User user = authResult.user;
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      bool isNewUser = authResult.additionalUserInfo.isNewUser;
      if (isNewUser) {
        await DatabaseService(uid: user.uid).setUserData(
          uid: user.uid,
          isNewUser: true,
          lid: 'null',
          name: '${user.displayName}',
          gender: 'Male',
          age: 2003,
          height: 180,
          wantToBePaired: true,
          wantToBePairedRandomly: true,
          avatarUrl: 'https://image.freepik.com/free-icon/important-person_318-10744.jpg',
          hairLength: 'Short',
          hairColor: 'Brown',
          cigarettes: 'I prefer not to say',
          alcohol: 'I prefer not to say',
          position: GeoPoint(52.22, 21.01),
          interests: [true, true, true, true, true, true, true, true, true],
          isPositionUpdated: false,
          isUserProfileUpdated: false,
          isLoverProfileUpdated: false,
          politics: "Other",
          pairedDate: 1577833200000,
        );
        await DatabaseService(uid: user.uid).setLoverData(
          gender: 'Female',
          ageMin: 18,
          ageMax: 120,
          heightMin: 160,
          heightMax: 180,
          hairColor: 'Brown',
          hairLength: 'Short',
          cigarettes: 'I prefer not to say',
          alcohol: 'I prefer not to say',
          distance: 500,
          interests: [true, true, true, true, true, true, true, true, true],
          haveAvatar: false,
          politics: "Other",
        );
      }
      return user;
    } catch (error) {
      return null;
    }
  }



}