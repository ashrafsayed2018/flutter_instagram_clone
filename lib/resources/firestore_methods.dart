import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import "package:uuid/uuid.dart";

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(String desc, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "some error accured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("post", file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        description: desc,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profImage,
        likes: 0,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
