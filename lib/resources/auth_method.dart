import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import "../models/user.dart" as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // sign up the user
  Future<String> signupUser(
    String email,
    String username,
    String password,
    String bio,
    Uint8List file,
  ) async {
    String res = 'error occured';

    try {
      if (email.isNotEmpty &&
          username.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          password: password,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        // add user to our database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        // another method of adding the user

        // await _firestore.collection('users').add({
        //   "uid": cred.user!.uid,
        //   "username": username,
        //   'email': email,
        //   'password': password,
        //   "bio": bio,
        //   "followers": [],
        //   "following": []
        // });
        res = "success";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "البريد الالكتروني غير صحيح";
      } else if (error.code == "weak-password") {
        res = "الرقم السري اقل من 6 حروف";
      } else if (error.code == 'email-already-in-use') {
        res = "البريد الالكتروني مستخدم من قبل ";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginUser(String email, String password) async {
    String res = '';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the feild";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "البريد الالكتروني غير صحيح";
      } else if (e.code == "wrong-password") {
        res = "الرقم السري غير صحيح";
      } else if (e.code == 'email-already-in-use') {
        res = "البريد الالكتروني مستخدم من قبل ";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // get the user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    String uid = currentUser.uid;

    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return model.User.fromSnap(snap);
  }
}
