import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BranchInfo extends ConsumerWidget {
  final InventoryRequest request;
  final Branch incomingBranch;

  const BranchInfo({
    Key? key,
    required this.request,
    required this.incomingBranch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (request.subBranchId == null) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                ref
                    .watch(branchByIdProvider(branchId: request.subBranchId))
                    .when(
                      data: (branch) {
                        return _buildBranchInfoRow(
                          'From',
                          "${branch?.name ?? request.branch?.name}",
                          Colors.green[700]!,
                        );
                      },
                      loading: () => Text("Loading..."),
                      error: (error, stack) => Text("Error: $error"),
                    ),
                SizedBox(height: 8),
                _buildBranchInfoRow(
                  'To',
                  "${incomingBranch.name}",
                  Colors.blue[700]!,
                ),
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
