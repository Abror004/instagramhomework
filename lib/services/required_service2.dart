import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramhomework/models/other_models.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/data_service2.dart';
import 'package:instagramhomework/services/pref_service.dart';

enum PostsType{myPosts,feedPosts,likedPosts,allPosts}

class Service2 {

  // init
  static final instance = FirebaseFirestore.instance;

  // folder
  static const String folderUsers = "users";
  static const String folderPosts = "posts";
  static const String folderFeeds = "feeds";
  static const String folderLikeds = "likeds";
  static const String folderFollowings = "followings";
  static const String folderFollowers = "followers";
  static List<Post> posts = [];
  static int postsLength = 0;

  // for someone user load
  static Future<User> loadUser({required String uid}) async {
    var value = await instance.collection(folderUsers).doc(uid).get();
    return User.fromJson(value.data()!);
  }

  static Future<List<Post>> loadThisUserPosts({required String userUid}) async {
    List<Post> posts = [];
    var querySnapshot = await instance.collection(folderUsers).doc(userUid).collection(folderPosts).get();
    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }
    return posts;
  }

  static Future<int> loadPostsLength() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderPosts).get();
    // print("data size: ${querySnapshot.size}");
    return querySnapshot.size;
  }

  static Future<List<Post>> loadPosts({required PostsType type}) async {
    List<String> postsUid = [];
    posts.clear();
    print("kirdi");
    if(PostsType.myPosts == type) {
      postsUid = await DataService2.loadPosts();
      for(int i = 0; i < postsUid.length; i++) {
        await loadPosts2(postUid: postsUid[i]);
      }
    } else if(PostsType.feedPosts == type) {
      // X
    } else if(PostsType.likedPosts == type) {
      posts = await DataService2.loadLikes();
    } else if(PostsType.allPosts == type) {
      // DataService2.loadAllPosts().then((postsUid) => loadPosts2(postUid: postsUid));
    }
    print("tugadi");
    return posts;
  }

  static Future<bool> removePost({required String postUid}) async {
    await DataService2.removeFromAllPosts(postUid: postUid);
    await DataService2.removePost(postUid: postUid);
    return true;
  }

  static Future<List<bool>> checkLike({required String postUid,required String userUid}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderLikeds).doc(postUid).get();
    bool liked = false;
    bool isMine = false;
    if(querySnapshot.data() != null) {
      liked = true;
    }
    if(uid == userUid) {
      isMine = true;
    }
    return [liked,isMine];
  }

  static Future<String> loadPosts2({required String postUid}) async {
    print("POST---");
    var querySnapshot = await instance.collection(folderPosts).doc(postUid).get();
    print("POST+++ ${querySnapshot.data()}");
    Post post = (await checkPost(post: Post.fromJson(querySnapshot.data()!)));
    print("POST*** :. isLiked ${post.isLiked} : isMine: ${post.isMine}");
    posts.add(post);
    return "+";
  }

  static Future<Post> checkPost({required Post post}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderLikeds).doc(post.id).get();
    if(querySnapshot.data() != null) {
      post.isLiked = true;
    }
    if(uid == post.uid) {
      post.isMine = true;
    }
    print("<<<isLiked: ${post.isLiked} : isMine: ${post.isMine}>>>");
    return post;
  }

  static Future<bool> containUser({required String userUid}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderFollowings).doc(userUid).get();
    if(querySnapshot.data() != null && OnlyUid.fromJson(querySnapshot.data()!).uid == userUid) {
      return true;
    }
    return false;
  }

  static Future<List<User>> loadFollowings() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    List<User> followings = [];
    var querySnapshot1 = await instance.collection(folderUsers).doc(uid).collection(folderFollowings).get();
    for(var users in querySnapshot1.docs) {
      var querySnapshot2 = await instance.collection(folderUsers).doc(OnlyUid.fromJson(users.data()).uid).get();
      followings.add(User.fromJson(querySnapshot2.data()!));
    }
    return followings;
  }
}