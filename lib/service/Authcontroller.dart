import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> registerUser({
    required String email,
    required String password,
    required String username,
    required String mobile,
    required String category,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': email,
        'username': username,
        'mobile': mobile,
        'category': category,
        'uid': cred.user!.uid,
      });

      return true;
    } catch (e) {
      debugPrint("Signup Error: $e");
      return false;
    }
  }
}
