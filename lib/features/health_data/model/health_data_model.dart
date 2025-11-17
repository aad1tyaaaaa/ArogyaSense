// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthDataModel {
  HealthDataModel({
    this.temperature,
    this.humidity,
    this.heartRate,
    this.spo2,
    this.steps,
    this.timestamp,
  });

  factory HealthDataModel.fromMap(Map<String, dynamic> map) {
    DateTime? ts;
    if (map['timestamp'] is Timestamp) {
      ts = (map['timestamp'] as Timestamp).toDate();
    } else if (map['timestamp'] is int) {
      ts = DateTime.fromMillisecondsSinceEpoch(map['timestamp']);
    }
    return HealthDataModel(
      temperature: (map['temperature'] as num?)?.toDouble(),
      humidity: (map['humidity'] as num?)?.toDouble(),
      heartRate: (map['heartRate'] as num?)?.toInt(),
      spo2: (map['spo2'] as num?)?.toDouble(),
      steps: (map['steps'] as num?)?.toInt(),
      timestamp: ts,
    );
  }

  Map<String, dynamic> toMap() => {
    'temperature': temperature,
    'humidity': humidity,
    'heartRate': heartRate,
    'spo2': spo2,
    'steps': steps,
  };

  final double? temperature;
  final double? humidity;
  final int? heartRate;
  final double? spo2;
  final int? steps;
  final DateTime? timestamp;
}
