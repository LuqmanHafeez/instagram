import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userName;
  final String photoUrl;
  final String bio;
  final String uid;
  final List followers;
  final List following;
  const User({
    required this.userName,
    required this.photoUrl,
    required this.bio,
    required this.uid,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJason() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data = {
      "userName": userName,
      "bio": bio,
      "uid": uid,
      "followers": followers,
      "following": following,
      "photoUrl": photoUrl,
    };
    return data;
  }

  static User fromSnapShot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return User(
        userName: snap["userName"],
        photoUrl: snap["photoUrl"],
        bio: snap["bio"],
        uid: snap["uid"],
        followers: snap["followers"],
        following: snap["following"]);
  }
}
