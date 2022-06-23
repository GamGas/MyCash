import 'package:flutter/material.dart';
import 'package:flutter_my_cash/models/transaction.dart';
import 'package:flutter_my_cash/widgets/main_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_prov;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_prov.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(TransactionAdapter());

  runApp(const MainPage());
}
