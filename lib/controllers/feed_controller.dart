import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/other_models.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service.dart';
import 'package:instagramhomework/services/file_service.dart';
import 'package:instagramhomework/services/required_service.dart';
import 'package:instagramhomework/services/utils.dart';

class FeedController extends GetxController{
  double height = 0.0;
  double width = 0.0;
  bool isLoading = false;
  bool postLoading = false;
  List<String> followingsList = [];
  Map<String,User>  followings = {};
  List<Post> posts = [];
  BuildContext? context;
  User user = User(fullName: "", email: "", password: "");

  // for load user
  Future<void> apiLoadUser() async {
    isLoading = true;
    update();
    await DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User infoUser) {
    user = infoUser;
    if(followingsList.contains(user.uid)) {
      followingsList.remove(user.uid);
      followingsList = [user.uid]+followingsList;
    } else {
      followingsList = [user.uid]+followingsList;
      followings[user.uid] = user;
    }
    isLoading = false;
    update();
  }

  // for load feeds
  // Future apiLoadFeeds() async {
  //   isLoading.value = true;
  //   posts.clear();
  //   followings.clear();
  //   followingsList.clear();
  //   await DataService.loadFeeds().then((followingsUid) => {
  //     // followingsUid.forEach((userUid) async {
  //       // Service.loadThisUserPosts(userUid: userUid.uid).then((posts) => _apiLoadFeeds2(posts));
  //       // Service.loadUser(uid: userUid.uid).then((user) => {
  //       //   Service.loadUserImageUrl(user: user).then((imageUrl) => _followingsImages(userUid: user.uid, imageUrl: imageUrl,fullname: user.fullName))
  //       // });
  //     // })
  //   });
  //   print("${posts.value.length} : ${followings.value.length} : ${followingsList.value.length}");
  //   isLoading.value = false;
  // }

  Future<void> apiLoadFeeds() async {
    postLoading = true;
    update();
    posts.clear();
    followings.clear();
    followingsList.clear();
    await DataService.loadFeeds().then((followingsUid) => {
      // print("boshlandi"),
      loadFollowings(followingUsers: followingsUid),
      // print("tugadi")
    });
  }

  Future<void> loadFollowings({required List<String> followingUsers}) async {
    followingUsers.forEach((userUid) {
      followingsList.add(userUid);
      Service.loadUser(uid: userUid).then((user) => loadUser(user));
    });
  }

  Future<void> loadUser(user) async {
    await Service.loadThisUserPosts(userUid: user.uid).then((loadPosts) => {
      loading(loadPosts,user)
    });
  }

  void loading(List<Post> loadPosts,User followingUser ) async {
    followings[followingUser.uid] = followingUser;
    checkPosts(loadPosts, followingUser.uid);
  }

  Future<void> checkPosts(List<Post> loadPosts,String userUid) async {
    loadPosts.forEach((post) {
      checkPosts2(post: post, id: loadPosts.last.id);
    });
  }

  Future<void> checkPosts2({required Post post,required String id}) async {
    await Service.checkLike(postUid: post.id,userUid: post.uid).then((list) => checkLiked(post: post,res: list[0],isMine: list[1],id: id));
  }

  Future<void> checkLiked({required Post post,required bool res,required bool isMine,required String id}) async {
    print("! ${post.isMine}");
    post.isLiked = res;
    post.isMine = isMine;
    posts.add(post);
    if(post.id == id) {
      if(followingsList.contains(user.uid)) {
        followingsList.remove(user.uid);
        followingsList = [user.uid]+followingsList;
      } else {
        followingsList = [user.uid]+followingsList;
        followings[user.uid] = user;
      }
      postLoading = false;
      update();
    }
    print(posts.length);
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
      await Service.removePost(postUid: post.id);
      apiLoadFeeds();
    }
  }
  void changeLiked(index) {
    posts[index].isLiked = !posts[index].isLiked;
    update();
  }

  // for liked posts
  void likedFunction({required index}) async {
    bool liked = posts[index].isLiked;
    while(liked != !posts[index].isLiked) {
      liked = (await DataService.storeLiked(
          postUid: PostUid(uid: posts[index].id), liked: liked));
    }
  }
}