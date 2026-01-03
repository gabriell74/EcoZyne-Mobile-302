class EcoEnzymeTracking {
  final int? id;
  final String batchName;
  final DateTime startDate;
  final DateTime dueDate;
  final String notes;

  EcoEnzymeTracking({
    this.id,
    required this.batchName,
    required this.startDate,
    required this.dueDate,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'batch_name': batchName,
    'start_date': startDate.toIso8601String(),
    'end_date': dueDate.toIso8601String(),
    'notes': notes,
  };

  factory EcoEnzymeTracking.fromJson(Map<String, dynamic> json) => EcoEnzymeTracking(
    id: json['id'],
    batchName: json['batch_name'],
    startDate: DateTime.parse(json['start_date']),
    dueDate: DateTime.parse(json['end_date']),
    notes: json['notes'],
  );
}
