// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:instagramhomework/models/post_model.dart';
// import 'package:instagramhomework/models/other_models.dart';
// import 'package:instagramhomework/models/user_model.dart';
// import 'package:instagramhomework/services/data_service.dart';
// import 'package:instagramhomework/services/pref_service.dart';
//
// class Service {
//   // init
//   static final instance = FirebaseFirestore.instance;
//
//   // folder
//   static const String folderUsers = "users";
//   static const String folderPosts = "posts";
//   static const String folderFeeds = "feeds";
//   static const String folderLikeds = "likeds";
//   static const String folderFollowings = "followings";
//   static const String folderFollowers = "followers";
//
//   // for someone user load
//   static Future<User> loadUser({required String uid}) async {
//     var value = await instance.collection(folderUsers).doc(uid).get();
//     return User.fromJson(value.data()!);
//   }
//
//   static Future<List<Post>> loadThisUserPosts({required String userUid}) async {
//     List<Post> posts = [];
//     var querySnapshot = await instance.collection(folderUsers).doc(userUid).collection(folderPosts).get();
//     for (var element in querySnapshot.docs) {
//       posts.add(Post.fromJson(element.data()));
//     }
//     return posts;
//   }
//
//   static Future<Post> loadPost({required String postUid}) async {
//     var querySnapshot = await instance.collection(folderPosts).doc(postUid).get();
//     Post post = Post.fromJson(querySnapshot.data()!);
//     return post;
//   }
//
//   static Future<String> loadUserImageUrl({required User user}) async {
//     // print(user.imageUrl);
//     return user.imageUrl!;
//   }
//
//   static Future<bool> removePost({required String postUid}) async {
//     await DataService.removeFromAllPosts(postUid: postUid);
//     await DataService.removePost(postUid: postUid);
//     return true;
//   }
//
//   static Future<List<bool>> checkLike({required String postUid,required String userUid}) async {
//     String uid = (await Prefs.load(StorageKeys.UID))!;
//     var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderLikeds).doc(postUid).get();
//     bool liked = false;
//     bool isMine = false;
//     if(querySnapshot.data() != null) {
//       liked = true;
//     }
//     if(uid == userUid) {
//       isMine = true;
//     }
//     return [liked,isMine];
//   }
//
//   static Future<bool> containUser({required String userUid}) async {
//     String uid = (await Prefs.load(StorageKeys.UID))!;
//     var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderFollowings).doc(userUid).get();
//     if(querySnapshot.data() != null && PostUid.fromJson(querySnapshot.data()!).uid == userUid) {
//       return true;
//     }
//     return false;
//   }
// }