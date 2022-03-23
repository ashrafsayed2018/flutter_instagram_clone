import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? description;
  final String? uid;
  final String? username;
  final String? postId;
  final DateTime? datePublished;
  final String? bio;
  final String? postUrl;
  final String? profileImage;
  final likes;
  Post({
    this.uid,
    this.description,
    this.username,
    this.postId,
    this.datePublished,
    this.bio,
    this.postUrl,
    this.profileImage,
    this.likes,
  });
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'description': description,
      'username': username,
      'postId': postId,
      'datePublished': datePublished,
      'bio': bio,
      'postUrl': postUrl,
      'profileImage': profileImage,
      'likes': likes,
    };
  }

  static Post fromSnap(DocumentSnapshot snap) {
    Map data = (snap.data() as Map<String, dynamic>);
    return Post(
        uid: data['uid'],
        description: data['description'],
        username: data['username'],
        postId: data['postId'],
        datePublished: data['datePublished'],
        bio: data['bio'],
        postUrl: data['postUrl'],
        profileImage: data['profileImage'],
        likes: data['likes']);
  }
}
