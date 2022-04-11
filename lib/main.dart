import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/pages/feed_page.dart';
import 'package:instagramhomework/pages/home_page.dart';
import 'package:instagramhomework/pages/likes_page.dart';
import 'package:instagramhomework/pages/profile_page.dart';
import 'package:instagramhomework/pages/search_page.dart';
import 'package:instagramhomework/pages/signin_page.dart';
import 'package:instagramhomework/pages/signup_page.dart';
import 'package:instagramhomework/pages/splash_page.dart';
import 'package:instagramhomework/pages/upload_page.dart';
import 'package:instagramhomework/services/getx_service/di_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DIService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: const SplashPage(),
    //   routes: {
    //     Home_Page.id: (context) => Home_Page(),
    //     FeedPage.id: (context) => FeedPage(),
    //     SearchPage.id: (context) => SearchPage(),
    //     UploadPage.id: (context) => UploadPage(),
    //     LikesPage.id: (context) => LikesPage(),
    //     ProfilePage.id: (context) => ProfilePage(),
    //     SignUpPage.id: (context) => SignUpPage(),
    //     SignInPage.id: (context) => SignInPage(),
    //   },
    // );
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SplashPage(),
      routes: {
        Home_Page.id: (context) => Home_Page(),
        FeedPage.id: (context) => FeedPage(),
        SearchPage.id: (context) => SearchPage(),
        UploadPage.id: (context) => UploadPage(),
        LikesPage.id: (context) => LikesPage(),
        ProfilePage.id: (context) => ProfilePage(),
        SignUpPage.id: (context) => SignUpPage(),
        SignInPage.id: (context) => SignInPage(),
      },
    );
  }
}

