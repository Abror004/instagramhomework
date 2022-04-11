import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/services/data_service.dart';
import 'package:instagramhomework/services/required_service.dart';

class Search_Controller extends GetxController {
  var controller = TextEditingController().obs;
  var height = 0.0.obs;
  var width = 0.0.obs;
  var types = ["members","posts"].obs;
  var users = [].obs;
  var length = 0.obs;
  var selectType = 0.obs;
  var isLoading = true.obs;

  void loadUsers() async {
    users.clear();
    isLoading.value = true;
    String keyword = "";
    keyword = controller.value.text.trim().toString();
    if(keyword != "") {
      users.value = (await DataService.searchUsers(keyword));
    }
    users.value = await checkUserFollow(users: users.value);
    isLoading.value = false;
  }

  Future<List> checkUserFollow({required List users}) async {
    for (var user in users) {
      user.followed = (await Service.containUser(userUid: user.uid));
    }
    return users;
  }

  void likedFunction({required index}) async {
    bool? liked;
    while(liked != !users[index].followed) {
      liked = (await DataService.updateFollowing(userUid: users[index].uid, liked: users[index].followed));
    }
  }
  void selectTypeEdit(int editNumber) {
    selectType.value = editNumber;
  }
}