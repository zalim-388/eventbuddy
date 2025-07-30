// AuthController.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _errorMessage;
  bool _isLoading = false;

  String? get username => _username;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  User? get currentUser => _auth.currentUser;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> fetchUsername(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _username = doc.data()?['username'] as String?;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
      _setError("Failed to fetch user data");
    }
  }

  Future<bool> registerUser({
    required String email,
    required String username,
    required String mobile,
    required String category,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
        'mobile': mobile,
        'category': category,
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _username = username;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'weak-password':
          _setError('The password provided is too weak.');
          break;
        case 'email-already-in-use':
          _setError('The account already exists for that email.');
          break;
        case 'invalid-email':
          _setError('The email address is not valid.');
          break;
        default:
          _setError('Registration failed: ${e.message}');
      }
      return false;
    } on FirebaseException catch (e) {
      _setLoading(false);
      _setError("Firestore Error: ${e.message}");
      debugPrint("Firestore Error: [${e.code}] ${e.message}");
      return false;
    } catch (e) {
      _setLoading(false);
      _setError("Unexpected Error: $e");
      debugPrint("Unexpected Error: $e");
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      await fetchUsername(userCredential.user!.uid);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      switch (e.code) {
        case 'user-not-found':
          _setError('No user found for that email.');
          break;
        case 'wrong-password':
          _setError('Wrong password provided.');
          break;
        case 'invalid-email':
          _setError('The email address is not valid.');
          break;
        default:
          _setError('Login failed: ${e.message}');
      }
      return false;
    } catch (e) {
      _setLoading(false);
      _setError("Unexpected Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _username = null;
      _errorMessage = null;

      notifyListeners();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }
}
