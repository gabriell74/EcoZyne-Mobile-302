import 'package:ecozyne_mobile/data/models/activity.dart';
import 'package:ecozyne_mobile/data/models/activity_registration.dart';
import 'package:ecozyne_mobile/data/services/activity_service.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final ActivityService _activityService = ActivityService();

  List<Activity> _activities = [];
  List<ActivityRegistration> _activityRegistrations = [];
  bool _isRegistrationLoading = false;
  String _registrationMessage = "";
  List<Activity> _completedActivities = [];
  bool _isLoading = false;
  bool _isCompletedLoading = false;
  String _message = "";
  String _completedMessage = '';
  bool _connected = true;

  Map<int, bool> _registrationStatus = {};
  bool _isCheckingStatus = false;

  Map<int, bool> get registrationStatus => _registrationStatus;
  bool isActivityRegistered(int id) => _registrationStatus[id] ?? false;
  bool get isCheckingStatus => _isCheckingStatus;


  Activity? _latestActivity;

  List<Activity> get activities => _activities;
  List<Activity> get completedActivities => _completedActivities;
  List<ActivityRegistration> get activityRegistrations => _activityRegistrations;
  bool get isLoading => _isLoading;
  bool get isRegistrationLoading => _isRegistrationLoading;
  bool get isCompletedLoading => _isCompletedLoading;
  String get message => _message;
  String get registrationMessage => _registrationMessage;
  String get completedMessage => _completedMessage;
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

  Future<bool> activityRegister(int activityId) async {
    _isLoading = true;
    notifyListeners();

    final activityIndex = _activities.indexWhere((act) => act.id == activityId);
    int? originalQuota;

    final result = await _activityService.activityRegister(activityId);

    if (activityIndex != -1) {
      originalQuota = _activities[activityIndex].currentQuota;
      _activities[activityIndex].currentQuota++;
      notifyListeners();
    }

    _connected = result["connected"] ?? false;

    _message = result["message"] ?? "Terjadi kesalahan";
    final bool success = result["success"];

    if (!success) {
      if (activityIndex != -1 && originalQuota != null) {
        _activities[activityIndex].currentQuota = originalQuota;
      }
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> getActivityRegistrations() async {
    _isRegistrationLoading = true;
    notifyListeners();

    final result = await _activityService.fetchActivityRegistrations();

    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];

      if (data != null && data.isNotEmpty) {
        _activityRegistrations = data.cast<ActivityRegistration>();
        _registrationMessage = result["message"] ??
            "Berhasil mengambil data pendaftaran kegiatan";
      } else {
        _activityRegistrations = [];
        _registrationMessage = "Belum ada riwayat pendaftaran kegiatan";
      }
    } else {
      _activityRegistrations = [];
      _registrationMessage =
          result["message"] ?? "Gagal memuat riwayat pendaftaran kegiatan";
    }

    _isRegistrationLoading = false;
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
        _message = result["message"] ?? "Berhasil mengambil kegiatan terbaru";
      } else {
        _latestActivity = null;
        _message = "Belum ada kegiatan terbaru";
      }
    } else {
      _latestActivity = null;
      _message = result["message"] ?? "Gagal memuat kegiatan terbaru";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCompletedActivity() async {
    _isCompletedLoading = true;
    notifyListeners();

    final result = await _activityService.fetchCompletedActivity();
    _connected = result["connected"] ?? false;

    if (result["success"]) {
      final data = result["data"];
      if (data != null && data.isNotEmpty) {
        _completedActivities = data;
        _completedMessage = result["message"] ?? "Berhasil mengambil kegiatan yang sudah selesai";
      } else {
        _completedActivities = [];
        _completedMessage = "Belum ada kegiatan yang selesai";
      }
    } else {
      _completedActivities = [];
      _completedMessage = result["message"] ?? "Gagal memuat kegiatan yang sudah selesai";
    }

    _isCompletedLoading = false;
    notifyListeners();
  }

  Future<void> checkRegistrationStatus(int activityId) async {
    _isCheckingStatus = true;
    notifyListeners();

    final result = await _activityService.checkRegistrationStatus(activityId);

    _connected = result["connected"] ?? false;

    if (result["success"] == true) {
      _registrationStatus[activityId] = result["registered"] ?? false;
    } else {
      _registrationStatus[activityId] = false;
    }

    _isCheckingStatus = false;
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