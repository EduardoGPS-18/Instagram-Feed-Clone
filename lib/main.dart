import 'package:feedinstagramclone/providers/posts.dart';
import 'package:feedinstagramclone/providers/user.dart';
import 'package:feedinstagramclone/routes.dart';
import 'package:feedinstagramclone/screens/add_post_screen.dart';
import 'package:feedinstagramclone/screens/auth_screen.dart';
import 'package:feedinstagramclone/screens/feed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => Posts(),
            ),
            ChangeNotifierProvider(
              create: (_) => CurrentUser(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            initialRoute: FirebaseAuth.instance.currentUser == null ? Routes.AUTH_SCREEN : Routes.MAIN_SCREEN,
            routes: {
              Routes.AUTH_SCREEN: (ctx) => AuthScreen(),
              Routes.MAIN_SCREEN: (ctx) => FeedScreen(),
              Routes.ADD_SCREEN: (ctx) => AddPostScreen(),
            },
          ),
        );
      },
    );
  }
}
