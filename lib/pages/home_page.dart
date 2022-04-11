import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/home_controller.dart';
import 'package:instagramhomework/pages/feed_page.dart';
import 'package:instagramhomework/pages/likes_page.dart';
import 'package:instagramhomework/pages/profile_page.dart';
import 'package:instagramhomework/pages/search_page.dart';
import 'package:instagramhomework/pages/upload_page.dart';

class Home_Page extends StatefulWidget {
  static const String id = "home_Page";

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  PageController pageController = PageController();
  Home_Controller home_controller = Home_Controller();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            FeedPage(),
            SearchPage(),
            UploadPage(),
            LikesPage(),
            ProfilePage(),
          ],
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            home_controller.selectPage(index);
          },
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: home_controller.currentPage.value,
          backgroundColor: Colors.white54,
          activeColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.add_box)),
            BottomNavigationBarItem(icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ],
          onTap: (index) {
            pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
