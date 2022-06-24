// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_my_cash/models/transaction.dart';
import 'package:flutter_my_cash/models/tx_filter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ModalForm extends StatefulWidget {
  @override
  State<ModalForm> createState() => _ModalFormState();
}

class _ModalFormState extends State<ModalForm> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _amountController,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
                decoration: InputDecoration(
                  hintText: 'Сумма',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _titleController,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  hintText: 'Краткое описание',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Дата',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
                        style: TextStyle(fontSize: 15),
                      ),
                      OutlinedButton(
                        //style: ButtonStyle(),
                        onPressed: () =>
                            setState(() => _pickedDate = DateTime.now()),
                        child: Text('Сейчас'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => presentDatePicker()),
                        child: Text('Установить'),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            minimumSize: Size(100, 50),
                          ),
                          onPressed: () => _formSubmit(
                            context: context,
                            titleController: _titleController,
                            amountController: _amountController,
                            isIncrement: false,
                            date: _pickedDate,
                          ),
                          child: Text(
                            'Расход',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.greenAccent,
                            minimumSize: Size(100, 50),
                          ),
                          onPressed: () => _formSubmit(
                            context: context,
                            titleController: _titleController,
                            amountController: _amountController,
                            isIncrement: true,
                            date: _pickedDate,
                          ),
                          child: Text(
                            'Приход',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _formSubmit(
      {required BuildContext context,
      required TextEditingController titleController,
      required TextEditingController amountController,
      required bool isIncrement,
      required DateTime date}) {
    // Hive.registerAdapter(TransactionAdapter());
    Box<Transaction> txBox = Hive.box<Transaction>('tx_box');
    if (titleController.text.isEmpty || titleController.text.isEmpty) return;
    String txTitle = titleController.text;
    double? amount = double.tryParse(amountController.text);
    if (amount == null) return;

    var newTx = Transaction(txTitle, isIncrement, amount, date);
    txBox.add(newTx);
    TxFilter().endDate = DateTime.now();
    Navigator.pop(context);
  }

  void presentDatePicker() {
    DateTime pDate;
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((pickedTime) {
        if (pickedDate == null || pickedTime == null) return;
        pDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _pickedDate = pDate;
      });
    });
  }
}
