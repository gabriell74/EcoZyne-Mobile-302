import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
      return formattedDate;
    } catch (e) {
      return '-';
    }
  }
}