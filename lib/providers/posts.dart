import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedinstagramclone/models/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  get posts => [..._posts];

  Future<void> getNetPosts() async {
    _posts.clear();

    var posts = await FirebaseFirestore.instance.collection('posts').get();
    posts.docs.forEach(
      (post) {
        _posts.add(
          Post(
            name: post["name"],
            icon: post["icon"],
            imageSRC: post["imageSRC"],
            legend: post["legend"],
            date: (post["date"] as Timestamp).toDate(),
            curtidas: post["curtidas"],
            uid: post["uid"],
            userUID: post["userUID"],
          ),
        );
      },
    );
    _posts.sort((post1, post2) => post1.date.isAfter(post2.date) ? -1 : 1);
    notifyListeners();
  }

  void deletePost(Post post, String uid) async {
    var toDeletePost = FirebaseFirestore.instance.collection("posts").doc(post.uid);
    var deletePostProperties = await toDeletePost.get();
    var imageURL = deletePostProperties["imageSRC"];
    var userUID = deletePostProperties["userUID"];

    if (!(userUID == uid)) {
      return;
    } else {
      await toDeletePost.delete();
      await FirebaseStorage.instance.refFromURL(imageURL).delete();

      getNetPosts();
    }
  }

  void changeLike(Post rpost, String uid) async {
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

  void addPost(Post post, String userUID) async {
    FirebaseFirestore fbinstance = FirebaseFirestore.instance;
    var posts = fbinstance.collection("posts");
    var res = await posts.add({
      "name": post.name,
      "icon": post.icon,
      "imageSRC": post.imageSRC,
      "legend": post.legend,
      "date": post.date,
      "userUID": userUID,
      "curtidas": [],
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
      userUID: userUID,
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
