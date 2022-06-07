import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramhomework/models/post_model.dart';

class OnlyUid {
  String uid = "";

  OnlyUid({required this.uid});

  OnlyUid.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
  };
}


class FeedData {
  List<Post>? posts;
  List<User>? followings;

  FeedData.data({required this.posts, required this.followings});


}