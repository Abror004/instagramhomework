import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramhomework/models/other_models.dart';
import 'package:instagramhomework/models/post_model.dart';
import 'package:instagramhomework/models/user_model.dart';
import 'package:instagramhomework/services/pref_service.dart';

class DataService2 {
  // init
  static final instance = FirebaseFirestore.instance;

  // folder
  static const String folderUsers = "users";
  static const String folderPosts = "posts";
  static const String folderFeeds = "feeds";
  static const String folderLikeds = "likeds";
  static const String folderFollowings = "followings";
  static const String folderFollowers = "followers";

  // User
  static Future<void> storeUser(User user) async {
    user.uid = (await Prefs.load(StorageKeys.UID))!;
    await storeFeed(OnlyUid(uid: user.uid).uid);
    return instance.collection(folderUsers).doc(user.uid).set(user.toJson());
  }

  static Future<User> loadUser() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var value = await instance.collection(folderUsers).doc(uid).get();
    User user = User.fromJson(value.data()!);
    var querySnapshot1 = await instance.collection(folderUsers).doc(uid).collection(folderFollowings).get();
    var querySnapshot2 = await instance.collection(folderUsers).doc(uid).collection(folderFollowers).get();
    user.followingCount = querySnapshot1.docs.length;
    user.followersCount = querySnapshot2.docs.length;
    return user;
  }

  static Future<void> updateUser(User user) async {
    return instance.collection(folderUsers).doc(user.uid).update(user.toJson());
  }

  static Future<List<User>> searchUsers(String keyword) async {
    User user = await loadUser();
    List<User> users = [];
    // write request
    var querySnapshot = await instance.collection(folderUsers).orderBy("fullName").startAt([keyword]).endAt([keyword + '\uf8ff']).get();
    if (kDebugMode) {
      print(querySnapshot.docs.toString());
    }

    for (var element in querySnapshot.docs) {
      users.add(User.fromJson(element.data()));
    }

    users.remove(user);
    return users;
  }

  static Future<void> deleteUser(User user) async {
    return instance.collection(folderUsers).doc(user.uid).delete();
  }

  // Posts Posts
  static Future<List<String>> loadPosts() async {
    List<String> posts = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    // var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderPosts).get();
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderPosts).get();

    for (var element in querySnapshot.docs) {
      posts.add(Post.fromJson(element.data()).id);
    }
    return posts;
  }

  static Future<bool> storePost({required Post post,}) async {
    await instance.collection(folderPosts).doc(post.id).set(post.toJson());
    return true;
  }

  static Future<bool> updatePost(Post post) async {
    await instance.collection(folderPosts).doc(post.id).update(post.toJson());
    return true;
  }

  static Future<bool> removePost({required String postUid}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    await instance.collection(folderUsers).doc(uid).collection(folderPosts).doc(postUid).delete();
    return true;
  }

  // Feed Posts
  static Future<String> storeFeed(String userUid) async {
    await instance.collection(folderUsers).doc(userUid).collection(folderFeeds).doc(userUid).set(OnlyUid(uid: userUid).toJson());
    return userUid;
  }

  static Future<List> loadFeeds() async {
    print("feedPostlar olinmoqda..");
    List<Post> feedPosts = [];
    List<User> followingsList = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var followings = await instance.collection(folderUsers).doc(uid).collection(folderFeeds).get();
    for (var user in followings.docs) {
      var posts = await instance.collection(folderPosts).where("uid",isEqualTo: OnlyUid.fromJson(user.data()).uid).get();
      for(var post in posts.docs) {
        feedPosts.add(Post.fromJson(post.data()));
        feedPosts.last.isMine = feedPosts.last.uid == uid ? true : false;
      }
      var userData = await instance.collection(folderUsers).doc(OnlyUid.fromJson(user.data()).uid).get();
      followingsList.add(User.fromJson(userData.data()!));
    }
    print("feedPostlar olinmoqda...");
    return [followingsList, feedPosts];
  }

  //liked posts
  static Future<bool> storeLiked({required OnlyUid postUid,required bool liked}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    if(liked == true) {
      await instance.collection(folderUsers).doc(uid)
          .collection(folderLikeds)
          .doc(postUid.uid).set(postUid.toJson());
    } else {
      await instance.collection(folderUsers).doc(uid)
          .collection(folderLikeds).doc(postUid.uid).delete();
    }
    return liked;
  }

  static Future<List<Post>> loadLikes() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    List<Post> posts = [];
    var querySnapshot1 = await instance.collection(folderUsers).doc(uid).collection(folderLikeds).get();
    for(var postUid in querySnapshot1.docs) {
      var querySnapshot2 = await instance.collection(folderPosts).doc(OnlyUid.fromJson(postUid.data()).uid).get();
      posts.add(Post.fromJson(querySnapshot2.data()!));
    }
    print(posts.length);
    return posts;
  }

  // All posts
  static Future<Post> storeToAllPosts({required Post post}) async {
    // filled post
    User me = await loadUser();
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.imageUser = me.imageUrl;
    post.createdDate = DateTime.now().toString();

    String postId = instance.collection(folderUsers).doc(me.uid).collection(folderPosts).doc().id;
    post.id = postId;
    await instance.collection(folderUsers).doc(me.uid).collection(folderPosts).doc(postId).set(post.toJson());
    await storePost(post: post);
    return post;
  }

  static Future<void> updateFromAllPosts({required Post post}) async {
    return await instance.collection(folderUsers).doc(post.uid).collection(folderPosts).doc(post.id).update(post.toJson());
  }

  static Future removeFromAllPosts({required String postUid}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    return await instance.collection(folderPosts).doc(uid).delete();
  }

  // followings
  static Future<bool> updateFollowing({required String userUid,required bool liked}) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    if(liked) {
      // my followings
      await instance.collection(folderUsers).doc(uid).collection(
          folderFollowings).doc(userUid).set(OnlyUid(uid: userUid).toJson());
      // my feeds
      await instance.collection(folderUsers).doc(uid).collection(
          folderFeeds).doc(userUid).set(OnlyUid(uid: userUid).toJson());
      // user followers
      await instance.collection(folderUsers).doc(userUid).collection(
          folderFollowers).doc(uid).set(OnlyUid(uid: uid).toJson());
    } else {
      await instance.collection(folderUsers).doc(uid).collection(
          folderFollowings).doc(userUid).delete();
      await instance.collection(folderUsers).doc(uid).collection(
          folderFeeds).doc(userUid).delete();
      await instance.collection(folderUsers).doc(userUid).collection(
          folderFollowers).doc(uid).delete();
    }
    return liked;
  }

  // followers
  static Future<List<OnlyUid>> loadFollowers() async {
    List<OnlyUid> followers = [];
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var querySnapshot = await instance.collection(folderUsers).doc(uid).collection(folderFollowers).get();

    for (var element in querySnapshot.docs) {
      OnlyUid follower = OnlyUid.fromJson(element.data());
      followers.add(follower);
    }
    return followers;
  }
}