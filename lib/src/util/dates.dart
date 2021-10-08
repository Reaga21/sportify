import 'package:intl/intl.dart';


String today() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

String yesterday() {
  return DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));
}