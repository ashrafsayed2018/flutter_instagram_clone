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
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> likePost({uid, String? postId, List? likes}) async {
    try {
      if (likes!.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid]),
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // create comment on post
  Future<String> postComment(
      {String? postId,
      String? text,
      String? uid,
      String? name,
      String? profilePic}) async {
    String res = "some error accured";
    try {
      if (text != null && text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'text': text,
          'uid': uid,
          'name': name,
          'profilePic': profilePic,
          'commentId': commentId,
          'dateCommented': DateTime.now(),
        });

        res = "success";
      } else {
        print('not text added');
      }
    } catch (err) {
      print(err.toString());
    }
    return res;
  }

  Future<void> deletePost({String? postId}) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  // delete comment

}
