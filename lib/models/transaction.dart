import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final bool isIncrement;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;

  Transaction(this.title, this.isIncrement, this.amount, this.date);
}
