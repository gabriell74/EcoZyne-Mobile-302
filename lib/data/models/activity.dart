class Activity {
  final int id;
  final String title;
  final String description;
  final String photo;
  final String location;
  final int currentQuota;
  final int quota;
  final String regisStartDate;
  final String regisDueDate;
  final String startDate;
  final String dueDate;
  final String createdAt;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.location,
    required this.currentQuota,
    required this.quota,
    required this.regisStartDate,
    required this.regisDueDate,
    required this.startDate,
    required this.dueDate,
    required this.createdAt
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      photo: json['photo'] ?? "",
      location: json['location'],
      currentQuota: json['current_quota'],
      quota: json['quota'],
      regisStartDate: json['registration_start_date'],
      regisDueDate: json['registration_due_date'],
      startDate: json['start_date'],
      dueDate: json['due_date'],
      createdAt: json['created_at']
    );
  }
}