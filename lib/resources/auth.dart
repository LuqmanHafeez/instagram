import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage.dart';

class AuthMethod {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(user!.uid).get();
    return model.User.fromSnapShot(snapshot);
  }

  Future<String> signUpAuth(String email, String password, String bio,
      String userName, Uint8List? file) async {
    String error = "Some problem";
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String? photoUrl;

      if (file != null) {
        Uint8List image =
            await FlutterImageCompress.compressWithList(file, quality: 25);
        photoUrl = await StorageMethod()
            .uploadImageToStorage("profilePic", kIsWeb ? file : image, false);
      } else {
        photoUrl =
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOmexifoKNXEehSgw2Qx-LbzHlEwLCwZ_I0BsPsGZxwA&s";
      }
      model.User user = model.User(
        userName: userName,
        photoUrl: photoUrl,
        bio: bio,
        uid: userCredential.user!.uid,
        followers: [],
        following: [],
      );

      await _firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set(user.toJason());
      error = "Success";
    } catch (er) {
      error = er.toString();
      return error;
    }
    return error;
  }

  Future<String> logInMethod(String email, String password) async {
    String error = "Some problem";
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      error = "Success";
    } catch (er) {
      error = er.toString();
      return error;
    }
    return error;
  }

  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
