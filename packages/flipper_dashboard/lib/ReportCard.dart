import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final double stockValue;
  final double soldStock;
  final String cardName;
  final String wordingA;
  final String wordingB;
  final String description;

  const ReportCard({
    Key? key,
    required this.stockValue,
    required this.soldStock,
    required this.cardName,
    required this.wordingA,
    required this.wordingB,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = stockValue != 0
        ? ((soldStock / stockValue) * 100).clamp(0.0, 100.0)
        : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigoAccent, Colors.lightBlueAccent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildDataRow(
              title: wordingA,
              value: stockValue.toCurrencyFormatted(
                  symbol: ProxyService.box.defaultCurrency()),
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: stockValue != 0
                  ? (soldStock / stockValue).clamp(0.0, 1.0)
                  : 0.0,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
            const SizedBox(height: 8),
            Text(
              '$description: ${percentage.toFormattedPercentage()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
