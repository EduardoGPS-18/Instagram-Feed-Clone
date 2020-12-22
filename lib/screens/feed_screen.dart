import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/routes.dart';
import 'package:feedinstagramclone/widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<Posts>(context, listen: false).getNetPosts();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Instagram"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(Routes.AUTH_SCREEN);
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {
              Provider.of<Posts>(context, listen: false).getNetPosts();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_box_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () async {
              final res = await ImagesPicker.openCamera(
                pickType: PickType.image,
              );
              Navigator.of(context).pushNamed(
                Routes.ADD_SCREEN,
                arguments: res,
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<Posts>(
        builder: (_, postProvider, child) => ListView.builder(
          itemCount: postProvider.posts.length,
          itemBuilder: (ctx, i) {
            return PostWidget(
              post: postProvider.posts[i],
            );
          },
        ),
      ),
    );
  }
}
