import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userName;
  final String profileImage;
  final String description;
  final String uid;
  final likes;
  final String postUrl;
  final String postId;
  final datePublished;
  const Post({
    required this.userName,
    required this.profileImage,
    required this.description,
    required this.uid,
    required this.likes,
    required this.datePublished,
    required this.postId,
    required this.postUrl,
  });

  Map<String, dynamic> toJason() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data = {
      "userName": userName,
      "description": description,
      "uid": uid,
      "likes": likes,
      "datePublished": datePublished,
      "profileImage": profileImage,
      "postId": postId,
      "postUrl": postUrl,
    };
    return data;
  }

  static Post fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      userName: snap["userName"],
      profileImage: snap["profileImage"],
      description: snap["description"],
      uid: snap["uid"],
      likes: snap["likes"],
      datePublished: snap["datePublished"],
      postId: snap["postId"],
      postUrl: snap["postUrl"],
    );
  }
}
