import 'package:intl/intl.dart';

class TxFilter {
  static final TxFilter _instance = TxFilter._internal();

  late DateTime startDate;
  late DateTime endDate;

  var dFormat = DateFormat('dd.MM.yyyy');

  factory TxFilter() {
    return _instance;
  }
  TxFilter._internal() {
    startDate = DateTime.now().subtract(const Duration(days: 365));
    endDate = DateTime.now();
  }

  @override
  String toString() {
    var dFormat = DateFormat('dd.MM.yyyy HH:mm');
    return '${dFormat.format(startDate)}|${dFormat.format(endDate)}';
  }

  String get startDateString => dFormat.format(startDate);
  String get endDateString => dFormat.format(endDate);
}

enum Operation { increment, decrement }
