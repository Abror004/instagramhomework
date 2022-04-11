import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  static final Reference _storage = FirebaseStorage.instance.ref();
  static const String folderUserImg = "user_image";
  static const String folderPostImg = "post_image";

  static Future<List<String>> uploadImage(File image, String folder) async {
    // image name
    String imgName = "image_" + DateTime.now().toString();
    Reference storageRef = _storage.child(folder).child(imgName);
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    final String imgId = await taskSnapshot.ref.name;
    return [imgId,downloadUrl];
  }

  static Future<void> deleteImage({required String imageUid}) async {
    _storage.child(folderUserImg).child(imageUid).delete();
  }
  static Future<void> deletePostImage({required String id}) async {
    _storage.child(folderPostImg).child(id).delete();
  }
}