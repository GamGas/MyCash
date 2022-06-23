import 'package:intl/intl.dart';

class TxFilter {
  DateTime startDate;
  DateTime endDate;
  var dFormat = DateFormat('dd.MM.yyyy');

  TxFilter({
    required this.startDate,
    required this.endDate,
  });

  @override
  String toString() {
    var dFormat = DateFormat('dd.MM.yyyy HH:mm');
    return '${dFormat.format(startDate)}|${dFormat.format(endDate)}';
  }

  String get startDateString => dFormat.format(startDate);
  String get endDateString => dFormat.format(endDate);
}

enum Operation { increment, decrement }
