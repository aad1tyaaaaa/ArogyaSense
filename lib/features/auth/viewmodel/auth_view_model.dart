// features/auth/viewmodel/auth_viewmodel.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/utils/constants.dart';
import '../model/user_profile.dart';
import '../service/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserProfile? _user;
  bool _isLoading = false;
  String? _error;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // 1. Load cached profile and show UI immediately if available
    _user = await _service.loadCacheUserProfile();
    _isLoading = false;
    notifyListeners();

    // 2. Refresh from Firestore in the background (don't block UI)
    try {
      final freshUser = await _service.getCurrentUserProfile();
      if (freshUser != null) {
        _user = freshUser;
        await _service.cacheUserProfile(freshUser);
        notifyListeners();
      }
    } catch (e) {
      // Optionally set an error, but don't block the UI
      _error = 'Failed to refresh user: $e';
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _service.signIn(email, password);
      if (_user != null) {
        await _service.cacheUserProfile(_user!);
        await saveFcmToken(_user!.uid);
      }
    } catch (e) {
      _error = 'Sign in failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.signUp(email, password, name);
      _user = await _service.getCurrentUserProfile();
      if (_user != null) {
        await _service.cacheUserProfile(_user!);
        saveFcmToken(_user!.uid);
      }
    } catch (e) {
      _error = 'Sign up failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.signOut();
      _user = null;
    } catch (e) {
      _error = 'Sign out failed: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveFcmToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection(userCollection)
          .doc(userId)
          .update({'fcmToken': token});
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
