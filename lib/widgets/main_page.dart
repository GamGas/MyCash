// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_my_cash/models/transaction.dart';
import 'package:flutter_my_cash/models/tx_filter.dart';
import 'package:flutter_my_cash/widgets/main_body.dart';
import 'package:flutter_my_cash/widgets/modal_form.dart';
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
                      child: _txFilter.filterActive
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_txFilter.startDateString),
                                Text(_txFilter.endDateString),
                              ],
                            )
                          : Column(),
                    ),
                    _txFilter.filterActive
                        ? IconButton(
                            onPressed: () => setState(() {
                                  _txFilter.startDate = DateTime.now()
                                      .subtract(const Duration(days: 365));
                                  _txFilter.endDate = DateTime.now();
                                  _txFilter.filterActive = false;
                                }),
                            icon: const Icon(
                              Icons.filter_alt_off,
                            ))
                        : IconButton(
                            onPressed: () => _presentRangeFilter(context),
                            icon: const Icon(
                              Icons.filter_alt,
                            )),
                  ],
                ),
                body: const Center(
                  child: MainBody(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _openNewTransactionForm(context),
                  child: const Icon(Icons.add),
                ),
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

  void _openNewTransactionForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ModalForm();
        });
  }

  void _presentRangeFilter(BuildContext context) {
    showDateRangePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            firstDate: DateTime(2022, 1, 1),
            lastDate: DateTime.now())
        .then((pickedValue) {
      setState(() {
        if (pickedValue == null) {
          return;
        }
        _txFilter.startDate = pickedValue.start;
        _txFilter.endDate = pickedValue.end
            .subtract(const Duration(hours: -23, minutes: -59, seconds: -59));
        _txFilter.filterActive = true;
      });
    });
  }
}
