import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/routes.dart';
import 'package:feedinstagramclone/widgets/post_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  RefreshController _ptrc = RefreshController();
  @override
  Widget build(BuildContext context) {
    Provider.of<Posts>(context, listen: false).getNetPosts();
    return SmartRefresher(
      controller: _ptrc,
      onRefresh: () async {
        await Provider.of<Posts>(context, listen: false).getNetPosts();
        _ptrc.refreshCompleted();
      },
      child: Scaffold(
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
              icon: Icon(
                Icons.add_box_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () async {
                final res = await ImagePicker().getImage(source: ImageSource.camera);
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
      ),
    );
  }
}
