import 'package:intl/intl.dart';

class Conversions {
  static convertTimeStamp(DateTime timestamp) {
    if (timestamp.toString().isEmpty) {
      return;
    }
    String convertedDate = DateFormat.yMMMd().add_jm().format(timestamp);
    return convertedDate;
  }
}
