import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ReportCard extends StatelessWidget {
  final double valueA;
  final double valueB;
  final String cardName;
  final String wordingA;
  final String wordingB;
  final String description;

  const ReportCard({
    Key? key,
    required this.valueA,
    required this.valueB,
    required this.cardName,
    required this.wordingA,
    required this.wordingB,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final talker = TalkerFlutter.init();
    talker.warning("Incoming Value A ${valueA}: Incoming Value B ${valueB}");

    return SizedBox(
      width: 250,
      height: 150,
      child: Card(
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
              Text(
                cardName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              _buildDataRow(
                title: wordingA,
                value: '\RWF ${valueA.toStringAsFixed(0)}',
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 4),
              _buildDataRow(
                title: wordingB,
                value: '\RWF ${valueB.toStringAsFixed(0)}',
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: valueA != 0 ? (valueB / valueA).clamp(0.0, 1.0) : 0.0,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
              const SizedBox(height: 8),
              Text(
                '$description: ${(valueB / valueA * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
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
