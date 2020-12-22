import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedinstagramclone/models/post_model.dart';
import 'package:feedinstagramclone/providers/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPostScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final img = ModalRoute.of(context).settings.arguments as List<Media>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Publicação"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 34,
            ),
            onPressed: () async {
              var users =
                  await FirebaseFirestore.instance.collection("users").get();
              var curUser = users.docs.where((element) {
                return element["uid"] == FirebaseAuth.instance.currentUser.uid;
              }).first;
              var fbs = await FirebaseStorage.instance
                  .ref(
                    curUser["uid"] +
                        "/images/" +
                        Random.secure()
                            .nextDouble()
                            .toString()
                            .replaceAll('.', "") +
                        Random.secure()
                            .nextDouble()
                            .toString()
                            .replaceAll('.', "") +
                        ".jpeg",
                  )
                  .putFile(
                    File(img[0].path),
                  );
              String imgUrl = await fbs.ref.getDownloadURL();
              Provider.of<Posts>(context, listen: false).addPost(Post(
                name: curUser["username"],
                imageSRC: imgUrl,
                legend: _controller.text,
                date: DateTime.now(),
                icon: "https://loremflickr.com/150/150",
              ));

              Navigator.pop(context);
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Container(
        width: double.infinity,
        height: 100,
        child: Form(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(img[0].path)),
                  ),
                ),
                height: 100,
                width: 100,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Legenda..."),
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
