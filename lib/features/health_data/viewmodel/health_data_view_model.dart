// features/health_data/viewmodel/health_data_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:health_app/features/health_data/model/health_data_model.dart';
import '../service/health_data_service.dart';

class HealthDataViewModel extends ChangeNotifier {
  final HealthDataService _service = HealthDataService();

  HealthDataModel? _latestData;
  List<HealthDataModel> _history = [];
  bool _isLoading = false;
  String? _error;

  HealthDataModel? get latestData => _latestData;
  List<HealthDataModel> get history => _history;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool useDummyData = true;

  Future<void> fetchLatestData(String userId) async {
    _isLoading = true;
    _error = null;

    _latestData = await _service.loadCachedLatestHealthData();
    notifyListeners();

    try {
      if (useDummyData) {
        _latestData = HealthDataModel(
          temperature: 36.5,
          humidity: 45.0,
          heartRate: 72,
          spo2: 98.0,
          steps: 5000,
          timestamp: DateTime.now(),
        );

        _isLoading = false;
        notifyListeners();
      }
      // final freshData = await _service.fetchLatestHealthData(userId);

      // if (freshData != null) {
      //   _latestData = freshData;
      //   await _service.cacheLatestHealthData(freshData);
      // }
    } catch (e) {
      _error = 'Failed to fetch latest health data: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHistory(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _history = await _service.fetchHealthDataHistory(userId);
    } catch (e) {
      _error = 'Failed to fetch health data history: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHealthData(String userId, HealthDataModel data) async {
    _isLoading = true;
    _error = null;

    final oldLatest = _latestData;
    final oldHistory = List<HealthDataModel>.from(_history);
    _latestData = data;
    _history = [data, ..._history];
    notifyListeners();

    try {
      await _service.addHealthData(userId, data);
      await fetchLatestData(userId);
      await fetchHistory(userId);
    } catch (e) {
      _latestData = oldLatest;
      _history = oldHistory;
      _error = 'Failed to add health data: $e';
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
