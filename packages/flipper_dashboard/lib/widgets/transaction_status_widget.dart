import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionStatusWidget extends StatelessWidget {
  final List<TransactionStatus> statuses;

  TransactionStatusWidget({required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < statuses.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (statuses[i].status == "PENDING")
                              ? Colors.orange
                              : (statuses[i].status == "PARKED")
                                  ? Colors.blue
                                  : Colors.green,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1.5,
                        color: i < statuses.length - 1
                            ? Colors.black
                            : Colors.transparent,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statuses[i].status,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(statuses[i].dateTime),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class TransactionStatus {
  final String status;
  final DateTime dateTime;

  TransactionStatus({required this.status, required this.dateTime});
}
