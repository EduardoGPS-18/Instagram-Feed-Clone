import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthScreenController with ChangeNotifier {
  Future<UserCredential> submitFunction(BuildContext context, String email, String password, bool isSignUp) async {
    UserCredential user;
    if (isSignUp) {
      user = await signUp(email, password);
    } else {
      user = await signIn(email, password);
    }
    return user;
  }

  Future<UserCredential> signIn(String email, String password) async {
    FirebaseAuth fbauth = FirebaseAuth.instance;
    UserCredential res = await fbauth.signInWithEmailAndPassword(email: email, password: password);
    return res;
  }

  Future<UserCredential> signUp(String email, String password) async {
    FirebaseAuth fbauth = FirebaseAuth.instance;
    UserCredential res = await fbauth.createUserWithEmailAndPassword(email: email, password: password);
    return res;
  }
}
