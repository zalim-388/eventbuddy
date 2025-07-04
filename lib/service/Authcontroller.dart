import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _username;

  String? get username => _username;

  Future<void> fetchUsername() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _username = doc.data()?['username'] as String?;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
    }
  }

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
        'uid': cred.user!.uid,
      });

      _username = username;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("Signup Error: [${e.code}] ${e.message}");
      throw e;
    } on FirebaseException catch (e) {
      debugPrint("Firestore Error: [${e.code}] ${e.message}");
      throw e;
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _username = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}
