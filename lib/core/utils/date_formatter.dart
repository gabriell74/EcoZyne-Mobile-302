import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(dynamic date) {
    try {
      DateTime dateTime;

      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return '-';
      }

      return DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return '-';
    }
  }
}
