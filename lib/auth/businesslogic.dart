import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login user with email and password
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in user
        UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Update user data in Firestore
        await _firestore.collection("users").doc(cred.user!.uid).update({
          "lastLogin": Timestamp.now(),
          "email": email,
        }).catchError((e) {
          // If document doesn't exist, create it
          _firestore.collection("users").doc(cred.user!.uid).set({
            "uid": cred.user!.uid,
            "email": email,
            "lastLogin": Timestamp.now(),
            "username": email.split('@')[0], // Default username
            "bio": "",
            "followers": [],
            "following": [],
            "photoUrl": "",
          }, SetOptions(merge: true));
        });

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          res = "No user found with this email.";
          break;
        case 'wrong-password':
          res = "Incorrect password.";
          break;
        case 'invalid-email':
          res = "Invalid email format.";
          break;
        default:
          res = e.message ?? "Login failed.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Signup user (from your previous code)
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file.isNotEmpty) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload profile picture
        String photoUrl = await StorageMethods().uploadImageToStorage(
          'ProfilePics',
          file,
          false,
        );

        // Add user to Firestore
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "username": username,
          "uid": cred.user!.uid,
          "email": email,
          "bio": bio,
          "followers": [],
          "following": [],
          "photoUrl": photoUrl,
          "lastLogin": Timestamp.now(),
        });

        res = "success";
      } else {
        res = "Please fill all required fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    try {
      Reference ref = _storage.ref().child(childName).child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}