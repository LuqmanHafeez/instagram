import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool ispost) async {
    String id = Uuid().v1();
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    if (ispost) {
      ref = ref.child(id);
    }
    TaskSnapshot uploadTask = await ref.putData(file);
    String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }
}
