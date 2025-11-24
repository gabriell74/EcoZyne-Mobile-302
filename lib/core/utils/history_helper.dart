String timeAgo(dynamic date) {
  DateTime dt;

  try {
    dt = date is String ? DateTime.parse(date) : date;
  } catch (_) {
    return "-";
  }

  final diff = DateTime.now().difference(dt);

  if (diff.inMinutes < 60) return "${diff.inMinutes}m";
  if (diff.inHours < 24) return "${diff.inHours}j";
  return "${diff.inDays}h";
}

Map<String, List<T>> groupByDate<T>(
    List<T> items, {
      required DateTime Function(T item) getDate,
    }) {
  final Map<String, List<T>> grouped = {};

  for (var item in items) {
    final date = getDate(item);
    final key =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    grouped.putIfAbsent(key, () => []).add(item);
  }

  final sortedKeys = grouped.keys.toList()
    ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

  return {for (var k in sortedKeys) k: grouped[k]!};
}


