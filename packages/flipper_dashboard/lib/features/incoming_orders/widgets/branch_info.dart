import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';

class BranchInfo extends StatelessWidget {
  final InventoryRequest request;
  final Branch incomingBranch;

  const BranchInfo({
    Key? key,
    required this.request,
    required this.incomingBranch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.swap_horiz, color: Colors.blue[700], size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBranchInfoRow(
                    'From', "${request.branch?.name}", Colors.green[700]!),
                SizedBox(height: 8),
                _buildBranchInfoRow(
                    'To', "${incomingBranch.name}", Colors.blue[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchInfoRow(String label, String branch, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          branch,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
