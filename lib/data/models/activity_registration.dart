import 'package:ecozyne_mobile/data/models/activity.dart';

class ActivityRegistration {
  final int id;
  final String createdAt;
  final Activity activity;

  ActivityRegistration({
    required this.id,
    required this.createdAt,
    required this.activity,
  });

  factory ActivityRegistration.fromJson(Map<String, dynamic> json) {
    return ActivityRegistration(
      id: json['id'],
      createdAt: json['created_at'],
      activity: Activity.fromJson(json['activity']),
    );
  }
}