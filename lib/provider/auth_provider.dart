import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String _userKey = 'user_data';
  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _verificationId;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Google Sign In
  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      _setLoading(true);
      _setError(null);

      // Start the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setError('Google sign in cancelled');
        return false;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      _user = userCredential.user;
      await _saveUserDataLocally(); // Save after successful sign in
      _setLoading(false);
      return true;

    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Phone Authentication
  Future<void> startPhoneAuth(
    String phoneNumber,
    Function(String) onCodeSent,
    Function(String) onError,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign in if possible
          await _auth.signInWithCredential(credential);
          _setLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(e.message);
          onError(e.message ?? 'Verification failed');
          _setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
          _setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _setLoading(false);
        },
      );
    } catch (e) {
      _setError(e.toString());
      onError(e.toString());
      _setLoading(false);
    }
  }

  // Verify Phone Code
  Future<bool> verifyPhoneCode(String smsCode) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_verificationId == null) {
        _setError('No verification ID found');
        return false;
      }

      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Sign in
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      _user = userCredential.user;
       await _saveUserDataLocally(); 
      _setLoading(false);
      return true;

    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        _clearUserDataLocally(),
      ]);
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Get current user data
  Future<Map<String, dynamic>> getCurrentUserData() async {
    if (_user != null) {
      return {
        'uid': _user?.uid ?? '',
        'displayName': _user?.displayName ?? '',
        'email': _user?.email ?? '',
        'phoneNumber': _user?.phoneNumber ?? '',
        'photoURL': _user?.photoURL ?? '',
      };
    }
    return await loadUserDataLocally();
  }



   Future<void> _saveUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      final userData = {
        'uid': _user?.uid,
        'displayName': _user?.displayName,
        'email': _user?.email,
        'phoneNumber': _user?.phoneNumber,
        'photoURL': _user?.photoURL,
      };
      await prefs.setString(_userKey, jsonEncode(userData));
    }
  }

  // Load user data from SharedPreferences
  Future<Map<String, dynamic>> loadUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return {};
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}