// ignore_for_file: avoid_unnecessary_containers, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_my_cash/models/transaction.dart';
import 'package:flutter_my_cash/models/tx_filter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<Transaction>('tx_box').listenable(),
        builder: (BuildContext context, Box<Transaction> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Transactions is empty'),
            );
          }
          List<Transaction> list = box
              .toMap()
              .values
              .where((tItem) =>
                  tItem.date.isAfter(TxFilter().startDate) &&
                  tItem.date.isBefore(TxFilter().endDate))
              .toList();
          list.sort((a, b) {
            if (a.date.isBefore(b.date)) return 0;
            return 1;
          });
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, txIndex) {
              Transaction txItem = list.elementAt(txIndex);
              return Card(
                color: txItem.isIncrement
                    ? const Color.fromARGB(255, 214, 255, 236)
                    : const Color.fromARGB(255, 255, 227, 227),
                margin: const EdgeInsets.only(left: 7, right: 7, top: 8),
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  //height: 70,
                  child: Column(
                    children: [
                      /// Начало заголовка карточки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Заголовок операции
                          Text(
                            (txItem as Transaction).title,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),

                          /// Дата операции
                          Text(
                            DateFormat('dd.MM.yyyy HH:mm').format(txItem.date),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      /// Конец заголовка карточки
                      ///
                      /// Начало основного тела карточки
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${(txItem.isIncrement ? '+' : '-') + txItem.amount.toStringAsFixed(2)}₽',
                                style: TextStyle(
                                    fontSize: 35,
                                    color: txItem.isIncrement
                                        ? Colors.green
                                        : Colors.redAccent),
                              ),
                            ),

                            ///Здесь кнопка удаления транзакции

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeTx(txIndex),
                            ),
                          ],
                        ),
                      ),

                      ///Конец основного тела карточки
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _removeTx(int txIndex) async {
    await Hive.openBox<Transaction>('tx_box').then((txBox) {
      setState(() {
        txBox.deleteAt(txIndex);
      });
    });
  }
}
