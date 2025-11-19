import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/data/services/activity_service.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityService _activityService = ActivityService();

  List<Activity> _activities = [];
  bool _isLoading = false;
  String _message = "";
  bool _connected = true;

  Activity? _latestActivity;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get connected => _connected;
  Activity? get latestActivity => _latestActivity;


  Future<void> getActivity() async {
    _isLoading = true;
    notifyListeners();

    final result = await _activityService.fetchActivities();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _activities = data;
        _message = result["message"];
    } else {
        _activities = [];
        _message = "Belum ada kegiatan tersedia";
      }
    } else {
      _activities = [];
      _message = result["message"] ?? "Gagal memuat kegiatan";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getLatestActivity() async {
    _isLoading = true;
    notifyListeners();

    final result = await _activityService.fetchLatestActivity();
    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"] as Activity?;
      if (data != null) {
        _latestActivity = data;
        _message = result["message"] ?? "Berhasil mengambil aktivitas terbaru";
      } else {
        _latestActivity = null;
        _message = "Belum ada aktivitas terbaru";
      }
    } else {
      _latestActivity = null;
      _message = result["message"] ?? "Gagal memuat aktivitas terbaru";
    }

    _isLoading = false;
    notifyListeners();
  }

  Activity? getFeaturedActivity() {
    if (_activities.isEmpty) return null;

    final activitiesCopy = List<Activity>.from(_activities);

    // Cari currentQuota tertinggi untuk normalisasi
    final maxCurrent = activitiesCopy
        .map((a) => a.currentQuota)
        .fold(0, (a, b) => a > b ? a : b);

    // semua 0 → tidak ada unggulan
    if (maxCurrent == 0) return null;

    // Hitung skor setiap activity
    double scoreOf(Activity a) {
      final percentage = a.quota == 0 ? 0 : a.currentQuota / a.quota;
      final popularity = maxCurrent == 0 ? 0 : a.currentQuota / maxCurrent;

      return (percentage * 0.7) + (popularity * 0.3);
    }

    // Sort berdasarkan skor tertinggi
    activitiesCopy.sort((a, b) => scoreOf(b).compareTo(scoreOf(a)));

    final topScore = scoreOf(activitiesCopy.first);

    // Jika activity tertinggi FULL → cari pengganti
    if (activitiesCopy.first.currentQuota >= activitiesCopy.first.quota) {
      for (var a in activitiesCopy.skip(1)) {
        final score = scoreOf(a);

        // Keluar jika menemukan activity lain skor-nya > 0 dan belum full
        if (score > 0 && a.currentQuota < a.quota) {
          return a;
        }
      }

      // Jika loop selesai tanpa menemukan alternatif
      // Tidak ada yang skor > 0, jadi tetap tampilkan yang pertama
      return activitiesCopy.first;
    }

    // Kalau tidak full → langsung return
    return activitiesCopy.first;
  }

}