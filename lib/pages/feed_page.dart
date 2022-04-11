import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/feed_controller.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/services/theme_service.dart';
import 'package:instagramhomework/views/appBar_widget.dart';

class FeedPage extends StatefulWidget {
  static const String id = "/feed_page";

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<FeedController>().apiLoadUser();
    Get.find<FeedController>().apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<FeedController>().context = context;
    Get.find<FeedController>().height = MediaQuery.of(context).size
        .height;
    Get
        .find<FeedController>()
        .width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: appBar(title: "Instagram",
          icon: Icon(FontAwesomeIcons.facebookMessenger, color: Colors.black,)),
      body: GetBuilder<FeedController>(
          init: FeedController(),
          builder: (feedController) {
            return feedController.postLoading && feedController.isLoading
                ? Center(child: CircularProgressIndicator(),)
                : SingleChildScrollView(
              primary: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // members
                  Container(
                    height: feedController.width / 3.3,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: feedController.followings.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // print("image ${feedController.followings[feedController
                          //     .followingsList[index]]!.imageUrl!}\nname ${feedController.followings[feedController
                          //     .followingsList[index]]!.fullName}");
                          if(feedController.followings[feedController
                              .followingsList[index]]!.imageUrl != null) {
                            return members(
                                imageUrl: feedController.followings[feedController
                                    .followingsList[index]]!.imageUrl!,
                                name: feedController.followings[feedController
                                    .followingsList[index]]!.fullName,
                                width: feedController.width,
                                index: index);
                          } else {
                            return members(
                                imageUrl: "",
                                name: feedController.followings[feedController
                                    .followingsList[index]]!.fullName,
                                width: feedController.width,
                                index: index);
                          }
                        }
                    ),
                  ),

                  // posts
                  feedController.isLoading && feedController.postLoading
                      ? Center(
                    child: CircularProgressIndicator(),)
                      : AllPosts(feedController.width),
                ],
              ),
            );
          }
      ),
    );
  }

  // Widget load({required imageUrl, required name, required width, required index}) {
  //   print("image ${imageUrl}\nname ${feedController.followings[feedController
  //       .followingsList[index]]!.fullName}");
  //   return Container();
  // }

  Widget members({required imageUrl, required name, required width, required index}) {
    return index == 0 ? Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: width / 4,
          width: width / 4,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: [
                ClipOval(
                  child: imageUrl == "" ? Image(
                    image: AssetImage("assets/images/user.png"),)
                      : Image(
                    image: NetworkImage(imageUrl),
                    height: (width / 4) - 20,
                    width: (width / 4) - 20,
                    fit: BoxFit.cover,),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    child: Icon(Icons.add, size: 15, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          name, style: TextStyle(color: Colors.black, fontSize: 14),),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: width / 4,
          width: width / 4,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.center,
                colors: [
                  ThemeService.colorThree,
                  ThemeService.colorFour
                ],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(2),
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: imageUrl == "" ? Image
                    .asset("assets/images/user.png") :
                Image.network(imageUrl),
              ),
            ),
          ),
        ),
        Text(
          name, style: TextStyle(color: Colors.black, fontSize: 14),),
      ],
    );
  }

  // for posts
  Widget AllPosts(width) {
    return GetBuilder<FeedController>(
        init: FeedController(),
        builder: (feedController) {
          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: feedController.posts.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return post_widegt(feedController.posts[index], width, index);
                }
            ),
          );
        }
    );
  }

  Widget post_widegt(Post post, width, index) {
    return GetBuilder<FeedController>(
        init: FeedController(),
        builder: (feedController) {
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
                          child: post.imageUser != null ? Image.network(
                            post.imageUser!, height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            isAntiAlias: false,)
                              : Image.asset(
                              "assets/images/user.png", isAntiAlias: false),
                        ),
                      ),
                      // Container(
                      //   height: 40,
                      //   width: 40,
                      //   clipBehavior: Clip.antiAlias,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //   ),
                      //
                      // ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.fullName, style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),),
                          Text(post.createdDate.substring(0, 16),
                            style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ],
                  ),
                  if(post.isMine)
                  IconButton(
                    onPressed: () {
                      feedController.deletePost(
                          post: post, context: feedController.context!);
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),

              // image
              SizedBox(
                height: width,
                width: width,
                child: Image.network(
                  post.postImage,
                  height: width,
                  width: width,
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
                          feedController.changeLiked(index);
                          feedController.likedFunction(index: index);
                        },
                        icon: Icon(post.isLiked ? Icons.favorite : Icons
                            .favorite_border),
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
                child: Text(post.caption, style: TextStyle(fontSize: 16),),
              ),
              Divider(
                indent: 0,
                color: Colors.grey,
                height: 1,
              ),
            ],
          );
        }
    );
  }
}
