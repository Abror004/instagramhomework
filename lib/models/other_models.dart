class PostUid {
  String uid = "";

  PostUid({required this.uid});

  PostUid.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
  };
}

class UserSearch {
  String name = "";
  String imageUrl = "";
  bool isFollowing = false;

  UserSearch({
    required this.name,
    required this.imageUrl,});
}

// class FeedUsers {
//   String uid = "";
//   String imageUrl = "";
//   String fullname = "";
//
//   FeedUsers({required this.uid, required this.fullname});
//
//   FeedUsers.fromJson(Map<String, dynamic> json) {
//     uid = json["uid"];
//     imageUrl = json["imageUrl"];
//     fullname = json["fullname"];
//   }
//
//   Map<String, dynamic> toJson() => {
//     "uid": uid,
//     "imageUrl": imageUrl,
//     "fullname": fullname,
//   };
// }