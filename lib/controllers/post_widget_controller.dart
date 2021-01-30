import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidgetController {
  Future<void> deletePost(BuildContext context, PostWidget widget) async {
    Provider.of<Posts>(context, listen: false).deletePost(
      widget.post,
      FirebaseAuth.instance.currentUser.uid,
    );
  }

  Future<void> changeLike(BuildContext context, PostWidget widget) async {
    Provider.of<Posts>(context, listen: false).changeLike(
      widget.post,
      FirebaseAuth.instance.currentUser.uid,
    );
  }
}
