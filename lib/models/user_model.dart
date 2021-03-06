class User {
  String uid = "";
  late String fullName;
  late String email;
  late String password;
  String? imageUrl;
  String? imageId;
  bool followed = false;
  int followersCount = 0;
  int followingCount = 0;
  String a = "";
  String b = "";
  String c = "";

  User({required this.fullName, required this.email, required this.password});
  User.isEmpty();

  User.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    email = json["email"];
    password = json["password"];
    imageUrl = json["imageUrl"];
    imageId = json["imageId"];
    followersCount = json["followersCount"];
    followingCount = json["followingCount"];
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "email": email,
    "password": password,
    "imageUrl": imageUrl,
    "imageId": imageId,
    "followingCount": followingCount,
    "followersCount": followersCount,
  };

  @override
  bool operator ==(Object other) {
    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
