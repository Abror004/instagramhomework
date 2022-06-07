import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:instagramhomework/controllers/likes_controller.dart';
import 'package:instagramhomework/services/theme_service.dart';

class LikesPage extends StatefulWidget {
  static const String id = "/likes_page";

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<Likes_Controller>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Likes_Controller>(
        init: Likes_Controller(),
        builder: (likesController) {
          likesController.width = MediaQuery.of(context).size.width;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text("Activity",style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
              elevation: 0,
            ),
            body: likesController.isLoading ? Center(child: CircularProgressIndicator(),)
                : likesController.likedPosts.length == 0 ? Center(child: Text("not found liked posts"),)
                : ListView.builder(
              itemCount: likesController.likedPosts.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top on image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipOval(
                                child: likesController.likedPosts[index].imageUser != null ? Image.network(
                                  likesController.likedPosts[index].imageUser!, height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  isAntiAlias: false,)
                                    : Image.asset(
                                    "assets/images/user.png", isAntiAlias: false),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(likesController.likedPosts[index].fullName, style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),),
                                Text(likesController.likedPosts[index].createdDate.substring(0, 16),
                                  style: TextStyle(color: Colors.black),),
                              ],
                            ),
                          ],
                        ),
                        if(likesController.likedPosts[index].isMine)
                          IconButton(
                            onPressed: () {
                              // feedController.deletePost(
                              //     post: likesController.likedPosts[index], context: feedController.context!);
                            },
                            icon: Icon(Icons.more_vert),
                          ),
                      ],
                    ),

                    // image
                    SizedBox(
                      height: likesController.width,
                      width: likesController.width,
                      child: Image.network(
                        likesController.likedPosts[index].postImage,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.green,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),

                    // bottom on image
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                likesController.unliked(postUid: likesController.likedPosts[index].id, index: index);
                              },
                              icon: const Icon(Icons.favorite, color: Colors.red,),
                              iconSize: 30,
                            ),
                            ThemeService.icons(Icon(FontAwesomeIcons.comment),),
                            ThemeService.icons(
                                Icon(CupertinoIcons.paperplane_fill), size: 30.0),
                          ],
                        ),
                        ThemeService.icons(Icon(FontAwesomeIcons.bookmark)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(likesController.likedPosts[index].caption, style: TextStyle(fontSize: 16),),
                    ),
                    Divider(
                      indent: 0,
                      color: Colors.grey,
                      height: 1,
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
  }
}
