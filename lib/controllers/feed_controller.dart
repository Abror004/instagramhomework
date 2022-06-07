import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/other_models.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/file_service.dart';
import 'package:instagramhomework/services/required_service2.dart';
import 'package:instagramhomework/services/utils.dart';

class FeedController extends GetxController{
  double height = 0.0;
  double width = 0.0;
  bool isLoading = false;
  bool postLoading = false;
  List<User> followings = [];
  Map followingList = {};
  List<Post> posts = [];
  BuildContext? context;
  User user = User.isEmpty();

  // for load user
  Future<void> apiLoadUser() async {
    isLoading = true;
    update();
    await DataService2.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User infoUser) {
    user = infoUser;
    followings.remove(user);
    followings = [user] + followings;
    isLoading = false;
    update();
  }

  Future<void> apiLoadFeeds() async {
    postLoading = true;
    update();
    posts.clear();
    followings.clear();
    List data = await DataService2.loadFeeds();
    followings = data[0] as List<User>;
    posts = data[1] as List<Post>;
    for(int i=0; i<followings.length; i++) {
      followingList[followings[i].uid] = followings[i].imageUrl;
    }

    for(var x in posts) {
      print("\nuid: ${x.uid}\nfullName: ${x.fullName}\nimageUser: ${x.imageUser}\ncaption: ${x.caption}\npostImage: ${x.postImage}\npostImageId: ${x.postImageId}\nisLiked: ${x.isLiked}\nisMine: ${x.isMine}\nid: ${x.id}");
    }
    update();
  }


  // Future _loadFeeds({required String userUid}) async {
  //   followings.value[userUid] = (await Service.loadUser(uid: userUid));
  //   // await Service.loadThisUserPosts(userUid: userUid).then((posts) => _apiLoadFeeds2(posts));
  //   // print("2 tugadi");
  // }
  //
  // Future<void> _apiLoadFeeds2(List<Post> loadPosts,User user) async {
  //   for(var post in loadPosts) {
  //     post = (await checkLiked(post: post));
  //     if(user.imageUrl != null) {
  //       post.imageUser = user.imageUrl;
  //     }
  //   }
  //   posts.addAll(loadPosts);
  //   print("postlar olindi");
  // }
  //
  // void _followingsImages({required String userUid,required String imageUrl,required String fullname}) {
  //   FeedUsers user = FeedUsers(uid: userUid, fullname: fullname);
  //   if(imageUrl != null) {
  //     user.imageUrl = imageUrl;
  //   }
  //   followings[userUid] = user;
  // }

  // for delete feeds
  void deletePost({required Post post,required BuildContext context}) async {
    bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do yu want to remove this post?", false);
    if(result) {
      FileService.deletePostImage(id: post.postImageId);
      await Service2.removePost(postUid: post.id);
      apiLoadFeeds();
    }
  }

  // for liked posts
  void likedFunction({required index,required postUid}) async {
    // bool liked = posts[index].isLiked;
    // while(liked != !posts[index].isLiked) {
    //   liked = await DataService.storeLiked(postUid: PostUid(uid: posts[index].id), liked: liked);
    // }
    posts[index].isLiked = !posts[index].isLiked;
    update();
    posts[index].isLiked = await DataService2.storeLiked(postUid: OnlyUid(uid: posts[index].id), liked: posts[index].isLiked);
    update();
  }
}