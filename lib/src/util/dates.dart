import 'package:intl/intl.dart';

String today() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

String yesterday() {
  return DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));
}

String nowFormated() {
  return DateFormat('HH:mm:ss dd.MM.yyyy').format(DateTime.now());
}

String shortDate(DateTime date){
  return DateFormat('dd.MM.yyyy').format(date);
}