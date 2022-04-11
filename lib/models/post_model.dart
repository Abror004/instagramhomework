class Post {
  /// owners info
  String uid = "";         /// owner uid
  String fullName = "";    /// owner name       #changeable
  String? imageUser;       /// owner image      #changeable
  /// basic info
  String id = "";          /// uid
  late String caption;     /// caption
  String createdDate = ""; /// create data
  /// image info
  late String postImage;   /// image url
  late String postImageId; /// image uid
  double? height;          /// image height
  /// others info
  bool isLiked = false;    /// liked or unliked  #changeable
  bool isMine = false;     /// my or not mine    #changeable

  Post({
    required this.postImage,
    required this.caption,
    required this.postImageId,
  });

  Post.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    fullName = json["fullName"];
    id = json["id"];
    postImage = json["postImage"];
    postImageId = json["postImageId"];
    caption = json["caption"];
    createdDate = json["createdDate"];
    isLiked = json["isLiked"];
    isMine = json["isMine"];
    imageUser = json["imageUser"];
    height = json["height"];
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "fullName": fullName,
    "id": id,
    "postImage": postImage,
    "postImageId": postImageId,
    "caption": caption,
    "createdDate": createdDate,
    "isLiked": isLiked,
    "isMine": isMine,
    "imageUser": imageUser,
    "height": height,
  };

  @override
  bool operator == (Object other) {
    return other is Post && other.createdDate == createdDate;
  }

  @override
  int get hashCode => createdDate.hashCode;
}