import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/providers/user.dart';
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
  int _currentIndex = 0;
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
            // IconButton(
            //   icon: Icon(Icons.exit_to_app),
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //     Navigator.of(context).pushReplacementNamed(Routes.AUTH_SCREEN);
            //     setState(() {});
            //   },
            // ),
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
        body: Column(
          children: [
            Flexible(
              flex: 10,
              child: Consumer<Posts>(
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
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.new_releases_outlined,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      size: 32,
                    ),
                    onPressed: () {},
                  ),
                  FutureBuilder(
                    future: Provider.of<CurrentUser>(context).getCurUser(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                              backgroundImage: NetworkImage(Provider.of<CurrentUser>(context).linkIcon),
                            );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
