import 'package:intl/intl.dart';

extension ExtendedDateFormat on DateFormat {
  static String formattedDate(DateTime dateTime) {
    return '${DateFormat('dd MMMM yyyy').format(dateTime)}, ${DateFormat('h:mm a').format(dateTime)}';
  }
}
