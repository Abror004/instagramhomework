import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service.dart';
import 'package:instagramhomework/services/file_service.dart';

class Profile_Controller extends GetxController {
  var height = 0.0.obs;
  var width = 0.0.obs;
  var posts = [].obs;
  var user = User(fullName: "", email: "", password: "").obs;
  var _image = File("").obs;
  var isLoading = false.obs;
  var imgLoading = false.obs;
  var countPosts = 0.obs;

  // for user image
  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    _image.value = File(image!.path);
    _apiChangePhoto();
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    _image.value = File(image!.path);
    _apiChangePhoto();
  }

  imgDelete() async {
    imgLoading.value = true;
    String imageUid = user.value.imageId ?? "";
    user.value.imageId = null;
    user.value.imageUrl = null;
    DataService.updateUser(user.value);
    if(imageUid != "") {
      await FileService.deleteImage(imageUid: imageUid);
    }
    imgLoading.value = false;
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30),),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Photo Library'),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.of(context).pop();
                          }),
                      ListTile(
                        leading: Icon(Icons.photo_camera),
                        title: Text('Camera'),
                        onTap: () {
                          _imgFromCamera();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  // for load user
  Future<void> apiLoadUser() async {
    isLoading.value = true;
    print("1");
    await DataService.loadUser().then((value) => _showUserInfo(value));
    print("3");
    isLoading.value = false;
  }

  Future<bool> _showUserInfo(User infoUser) async {
    print("2");
    user.value = infoUser;
    return true;
  }

  // for edit user
  void _apiChangePhoto() async {
    imgLoading.value = true;
    print("1");
    if (_image == null) return;
    await imgDelete();
    print("2");
    List list = (await FileService.uploadImage(_image.value, FileService.folderUserImg));
    user.value.imageUrl = list[1];
    user.value.imageId = list[0];
    print("3");
    await DataService.updateUser(user.value);
    print("4");
    imgLoading.value = false;
  }

  // for load post
  Future<void> apiLoadPost() async {
    print("post1");
    await DataService.loadPosts().then((posts) => {_resLoadPost(posts)});
    print("post4");
  }

  void _resLoadPost(List<Post> loadPosts) {
    print("post2");
    posts.value = loadPosts;
    countPosts.value = posts.length;
    print("post3");
  }
}