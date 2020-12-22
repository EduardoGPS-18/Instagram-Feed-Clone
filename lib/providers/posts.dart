import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedinstagramclone/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  get posts => [..._posts];

  Future<void> getNetPosts() async {
    this._posts.clear();
    var posts = await FirebaseFirestore.instance.collection('posts').get();
    posts.docs.forEach(
      (element) {
        _posts.add(
          Post(
            name: element["name"],
            icon: element["icon"],
            imageSRC: element["imageSRC"],
            legend: element["legend"],
            date: (element["date"] as Timestamp).toDate(),
            curtidas: element["curtidas"],
            uid: element["uid"],
          ),
        );
      },
    );
    _posts.sort((post1, post2) {
      var d1DepoisD2 = post1.date.isAfter(post2.date);
      return d1DepoisD2 ? -1 : 1;
    });
    notifyListeners();
  }

  void changeCurtiu(Post rpost, String uid) async {
    var post = FirebaseFirestore.instance.collection('posts').doc(rpost.uid);
    var res = await post.get();
    List initialCurts = res.data()["curtidas"];

    if (initialCurts.contains(uid)) {
      initialCurts.remove(uid);
      post.update({"curtidas": initialCurts});
    } else {
      post.update({
        "curtidas": [...initialCurts, uid]
      });
    }

    getNetPosts();
  }

  void addPost(Post post) async {
    FirebaseFirestore fbi = FirebaseFirestore.instance;
    var posts = fbi.collection("posts");
    var res = await posts.add({
      "name": post.name,
      "icon": post.icon,
      "imageSRC": post.imageSRC,
      "legend": post.legend,
      "date": post.date,
      "curtidas": []
    });
    if (res.id == null) {
      return;
    }
    var p = Post(
      name: post.name,
      icon: post.icon,
      imageSRC: post.imageSRC,
      legend: post.legend,
      date: post.date,
      uid: res.id,
      curtidas: [],
    );
    _posts.add(p);
    posts.doc(p.uid).update({"uid": p.uid});

    getNetPosts();
  }

  Post getPostByUID(String uid) {
    return _posts.where((post) => post.uid == uid).toList().first;
  }
}
