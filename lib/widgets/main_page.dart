// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_my_cash/models/transaction.dart';
import 'package:flutter_my_cash/models/tx_filter.dart';
import 'package:flutter_my_cash/widgets/main_body.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

//MainAppBar().myAppBar
class _MainPageState extends State<MainPage> {
  final TxFilter _txFilter = TxFilter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Hive.openBox<Transaction>('tx_box'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(snapshot.error.toString())),
              );
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: const Text('Мои деньги'),
                  actions: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_txFilter.startDateString),
                          Text(_txFilter.endDateString),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () => _presentRangeFilter(context),
                        icon: const Icon(
                          Icons.filter_alt,
                        ))
                  ],
                ),
                body: const Center(
                  child: MainBody(),
                ),
                floatingActionButton:
                    FloatingActionButton(onPressed: () => _addMockTx()),
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(snapshot.connectionState.toString())),
            );
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Fira Mono'),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void _presentRangeFilter(BuildContext context) {
    showDateRangePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            firstDate: _txFilter.startDate,
            lastDate: _txFilter.endDate)
        .then((pickedValue) {
      setState(() {
        if (pickedValue == null) {
          return;
        }
        _txFilter.startDate = pickedValue.start;
        _txFilter.endDate = pickedValue.end;
      });
    });
  }

  void _addMockTx() async {
    await Hive.openBox<Transaction>('tx_box').then((txBox) {
      setState(() {
        txBox.add(Transaction(
          'Чаевые',
          true,
          250.00,
          DateTime.now(),
        ));
      });
    });
  }
}
