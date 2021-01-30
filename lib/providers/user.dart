import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser with ChangeNotifier {
  String name;
  String uid;
  String linkIcon;

  Future<CurrentUser> getCurUser() async {
    var users = await FirebaseFirestore.instance.collection('users').get();
    var curUser = users.docs.where((element) => element["uid"] == FirebaseAuth.instance.currentUser.uid).first;
    linkIcon = curUser["icon"];
    name = curUser["name"];
    uid = curUser["uid"];
    notifyListeners();
    return this;
  }
}
