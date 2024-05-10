import 'package:flutter/material.dart';

class Refund extends StatefulWidget {
  const Refund(
      {super.key,
      required this.refundAmount,
      required this.transactionId,
      this.currency = "RWF"});
  final double refundAmount;
  final String transactionId;
  final String? currency;

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        width: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.currency} ${widget.refundAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Transaction ID: ${widget.transactionId}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform refund operation
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.blue[900],
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Text(
                        'Refund',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
