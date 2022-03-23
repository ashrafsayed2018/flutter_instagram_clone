import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? username;
  final String? email;
  final String? password;
  final String? bio;
  final String? photoUrl;
  final List? followers;
  final List? following;
  User(
      {this.uid,
      this.username,
      this.email,
      this.password,
      this.bio,
      this.photoUrl,
      this.followers,
      this.following});
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'photoUrl': photoUrl,
      'followers': followers,
      'following': following,
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    Map data = (snap.data() as Map<String, dynamic>);
    return User(
        uid: data['uid'],
        bio: data['bio'],
        username: data['username'],
        email: data['email'],
        password: data['password'],
        followers: data['followers'],
        following: data['following'],
        photoUrl: data['photoUrl']);
  }
}
