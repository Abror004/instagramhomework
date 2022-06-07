import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/controllers/feed_controller.dart';
import 'package:instagramhomework/models/other_models.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/file_service.dart';
import 'package:instagramhomework/services/required_service2.dart';
import 'package:instagramhomework/services/utils.dart';

class Likes_Controller extends GetxController{
  bool isLoading = false;
  List<Post> likedPosts = [];
  double width = 0;

  Future<void> loadPosts() async {
    isLoading = true;
    update();
    likedPosts = await Service2.loadPosts(type: PostsType.likedPosts);
    isLoading = false;
    update();
  }

  // unliked post
  Future<void> unliked({required String postUid,required int index}) async {
    await DataService2.storeLiked(postUid: OnlyUid(uid: postUid), liked: false);
    Get.find<FeedController>().posts[Get.find<FeedController>().posts.indexWhere((post) => post.id == postUid)].isLiked = false;
    likedPosts.removeAt(index);
    update();
  }

  void deletePost({required Post post,required BuildContext context}) async {
    bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do yu want to remove this post?", false);
    if(result) {
      FileService.deletePostImage(id: post.postImageId);
    }
  }
}