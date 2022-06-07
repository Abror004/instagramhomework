import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/required_service2.dart';

class Search_Controller extends GetxController {
  var controller = TextEditingController().obs;
  var height = 0.0.obs;
  var width = 0.0.obs;
  var types = ["members","posts"].obs;
  List<User> users = [];
  var length = 0.obs;
  var selectType = 0.obs;
  var isLoading = true.obs;

  void loadUsers() async {
    users.clear();
    isLoading.value = true;
    String keyword = "";
    keyword = controller.value.text.trim().toString();
    if(keyword != "") {
      users = (await DataService2.searchUsers(keyword));
    }
    users = await checkUserFollow(users: users);
    isLoading.value = false;
  }

  Future<List<User>> checkUserFollow({required List<User> users}) async {
    for (var user in users) {
      user.followed = (await Service2.containUser(userUid: user.uid));
    }
    return users;
  }

  void likedFunction({required index}) async {
    bool? liked;
    while(liked != !users[index].followed) {
      liked = (await DataService2.updateFollowing(userUid: users[index].uid, liked: users[index].followed));
    }
  }
  void selectTypeEdit(int editNumber) {
    selectType.value = editNumber;
  }
}