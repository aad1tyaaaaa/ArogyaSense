import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/core/utils/constants.dart';
import 'package:health_app/features/auth/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final profile = UserProfile(uid: user.uid, email: email, name: name);
        await _firestore
            .collection(userCollection)
            .doc(user.uid)
            .set(profile.toMap());
        return profile;
      }
      return null;
    } catch (e) {
      throw Exception('Sign up failed: $e.');
    }
  }

  Future<UserProfile?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final doc = await _firestore
            .collection(userCollection)
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return UserProfile.fromMap(doc.data()!, user.uid);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e.');
    }
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection(userCollection)
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return UserProfile.fromMap(doc.data()!, user.uid);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user profile: $e.');
    }
  }

  Future<void> cacheUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      userProfileSharedPrefString,
      jsonEncode(profile.toMap()..['uid'] = profile.uid),
    );
  }

  Future<UserProfile?> loadCacheUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(userProfileSharedPrefString);
    if (jsonString != null) {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromMap(map, map['uid']);
    }
    return null;
  }

  Future<void> clearCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userProfileSharedPrefString);
  }
}
