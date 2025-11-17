import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/core/utils/constants.dart';
import 'package:health_app/features/health_data/model/health_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cacheLatestHealthData(HealthDataModel data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(latestHealthDataSharedPrefString, jsonEncode(data.toMap()));
  }

  Future<HealthDataModel?> loadCachedLatestHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(latestHealthDataSharedPrefString);
    if (jsonString != null) {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return HealthDataModel.fromMap(map);
    }
    return null;
  }

  Future<void> clearCachedLatestHealthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(latestHealthDataSharedPrefString);
  }

  Future<void> addHealthData(String userId, HealthDataModel data) async {
    try {
      final dataMap = data.toMap();
      dataMap['timestamp'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(userCollection)
          .doc(userId)
          .collection('health_data')
          .add(dataMap);
    } catch (e) {
      throw Exception('Failed to add health data: $e.');
    }
  }

  Future<HealthDataModel?> fetchLatestHealthData(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(userCollection)
          .doc(userId)
          .collection('health_data')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return HealthDataModel.fromMap(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch latest health data: $e.');
    }
  }

  Future<List<HealthDataModel>> fetchHealthDataHistory(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(userCollection)
          .doc(userId)
          .collection('health_data')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => HealthDataModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch health data history: $e.');
    }
  }
}
