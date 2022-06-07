import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramhomework/controllers/profile_controller.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/pages/home_page.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/file_service.dart';

class Update_Controller extends GetxController {
  var isLoading = false.obs;
  var captionController = TextEditingController().obs;
  var saveImage = File("").obs;
  var name = "";
  BuildContext? context;

  // for image
  _imgFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    saveImage.value = File(image!.path);
  }

  _imgFromGallery() async {
    XFile? image = await  ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    saveImage.value = File(image!.path);
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                      update();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                    update();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  // for post
  void uploadNewPost({required BuildContext loadContext}) {
    context = loadContext;
    String caption = captionController.value.text.trim().toString();
    if(caption.isEmpty || saveImage.value.path == null) return;
    // Send post  to Server
    if(!isLoading.value) {
      _apiPostImage();
    }
  }

  void _apiPostImage() async {
    isLoading.value = true;
    update();
    await FileService.uploadImage(saveImage.value, FileService.folderPostImg).then((imageUrl) => {
      _resPostImage(imageUrl: imageUrl),
    });
  }

  void _resPostImage({required List imageUrl}) async {
    String caption = captionController.value.text.trim().toString();
    Post post = Post(postImageId: imageUrl[0], postImage: imageUrl[1], caption: caption);
    _apiStorePost(post);
  }

  void _apiStorePost(Post storePost) async {
    // Post to all posts folder
    await DataService2.storeToAllPosts(post: storePost);
    _moveToFeed();
  }

  void _moveToFeed() {
    Get.find<Profile_Controller>().user = User.isEmpty();
    isLoading.value = false;
    Navigator.pushReplacementNamed(context!, Home_Page.id);
    update();
  }
}