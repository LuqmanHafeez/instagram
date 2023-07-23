import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram/models/post.dart';

import 'package:instagram/resources/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirestoreMethods {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String childName,
    required Uint8List file,
    required bool ispost,
    required String userName,
    required String description,
    required String uid,
    required String photoUrl,
  }) async {
    String res = "Some Problem";
    try {
      String postId = Uuid().v1();
      debugPrint("image Compress ${file.lengthInBytes}");
      Uint8List? imageCompressed;
      if (!kIsWeb) {
        imageCompressed =
            await FlutterImageCompress.compressWithList(file, quality: 25);
        debugPrint("image Compress ${imageCompressed.lengthInBytes}");
      }

      String postUrl = await StorageMethod().uploadImageToStorage(
          childName, kIsWeb ? file : imageCompressed, ispost);
      Post post = Post(
          userName: userName,
          profileImage: photoUrl,
          description: description,
          uid: uid,
          likes: [],
          datePublished: DateTime.now(),
          postId: postId,
          postUrl: postUrl);

      await _firebaseFirestore
          .collection("posts")
          .doc(postId)
          .set(post.toJason());
      return res = "Success";
    } catch (e, stackTrace) {
      debugPrint("uploadPost Exception " + e.toString());
      debugPrint("uploadPost StackTrace " + stackTrace.toString());
      res = e.toString();
      return res;
    }
  }

  Future likes(String postId, String uid, final likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebaseFirestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future comments(
      {required String comment,
      required String postId,
      required String uid,
      required String photoUrl,
      required String userName}) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "likes": [],
          "comment": comment,
          "uid": uid,
          "photoUrl": photoUrl,
          "userName": userName,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection("posts").doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future commentLikes(
      {required String postId,
      required String commentId,
      required likes,
      required String uid}) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future followUser(
      {required String? currentUserUid,
      required bool followers,
      required String? followId}) async {
    try {
      if (!followers) {
        await _firebaseFirestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([currentUserUid])
        });

        await _firebaseFirestore
            .collection("users")
            .doc(currentUserUid)
            .update({
          "following": FieldValue.arrayUnion([followId]),
        });
      } else {
        await _firebaseFirestore
            .collection("users")
            .doc(currentUserUid)
            .update({
          "following": FieldValue.arrayRemove([followId]),
        });
        await _firebaseFirestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([currentUserUid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
