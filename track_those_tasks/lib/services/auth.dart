import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackthosetasks/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;

  User _convertUserFromFirebaseUser(FirebaseUser user) {
    if (user == null) return null;
    currentUser = new User(uuid: user.uid);
    return currentUser;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_convertUserFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _convertUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password

  // register with email & password

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error signin out');
      print(e.toString());
      return null;
    }
  }
}
