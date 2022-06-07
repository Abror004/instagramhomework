import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/file_service.dart';
import 'package:instagramhomework/services/required_service2.dart';

class Profile_Controller extends GetxController {
  double height = 0.0;
  double width = 0.0;
  List<Post> posts = [];
  User user = User.isEmpty();
  File _image = File("");
  bool isLoading = false;
  bool imgLoading = false;
  bool isReloading = false;
  int countPosts = 0;

  // for user image
  _imgFromCamera() async {
    print("++++++++++1 --> kirdi");
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    print("++++++++++2 --> rasm olindi");
    _image = File(image!.path);
    _apiChangePhoto();
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    _image = File(image!.path);
    _apiChangePhotoFirst();
  }

  void _apiChangePhotoFirst() {
    print("10++++++++++ --> imgLoading true");
    imgLoading = true;
    update();
    print("11+++++++++++ --> imgLoading true");
    _apiChangePhoto();
  }

  // for edit user
  void _apiChangePhoto() async {
    if (_image == null) return;
    // print("+++ --> ${_image.readAsBytesSync().join()}");
    print("++++ --> ${_image.readAsBytesSync().lengthInBytes}");
    print("++++ --> ${_image.readAsBytesSync().lengthInBytes.bitLength}");
    print("++++++++++3 --> rasm ochirish");
    await imgDelete("reverseImage");
    print("++++++++++4 --> rasm ochirildi");
    List list = (await FileService.uploadImage(_image, FileService.folderUserImg));
    print("++++++++++5 --> yangi rasm olindi");
    user.imageUrl = list[1];
    user.imageId = list[0];
    await DataService2.updateUser(user);
    imgLoading = false;
    update();
  }

  imgDelete(String type) async {
    if(type != "reverseImage") {
      imgLoading = true;
      update();
    }
    String imageUid = user.imageId ?? "";
    user.imageId = null;
    user.imageUrl = null;
    DataService2.updateUser(user);
    if(imageUid != "") {
      await FileService.deleteImage(imageUid: imageUid);
    }
    if(type != "reverseImage") {
      imgLoading = false;
      update();
    }
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30),),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Photo Library'),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.of(context).pop();
                          }),
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Camera'),
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
    user = User.isEmpty();
    isLoading = true;
    user = await DataService2.loadUser();
    isLoading = false;
    update();
  }

  Future<void> apiReloadUser() async {
    isReloading = true;
    update();
    User userInfo = await DataService2.loadUser();
    user.followersCount = userInfo.followersCount;
    user.followingCount = userInfo.followingCount;
    isReloading = false;
    update();
  }

  // for load post
  Future<void> apiLoadPost() async {
    countPosts = await Service2.loadPostsLength();
    posts.clear();

    await Service2.loadPosts(type: PostsType.myPosts).then((loadPosts) => {_resLoadPost(loadPosts)});
  }

  void _resLoadPost(List<Post> loadPosts) {
    posts = loadPosts;
    update();
  }
}