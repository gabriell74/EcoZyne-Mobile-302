class WasteSubmissionHistory {
  final int id;
  final int communityId;
  final int point;
  final String createdAt;

  WasteSubmissionHistory({
    required this.id,
    required this.communityId,
    required this.point,
    required this.createdAt,
  });

  factory WasteSubmissionHistory.fromJson(Map<String, dynamic> json) {
    return WasteSubmissionHistory(
      id: json["id"],
      communityId: json["community_id"],
      point: json["point"],
      createdAt: json["created_at"],
    );
  }
}
