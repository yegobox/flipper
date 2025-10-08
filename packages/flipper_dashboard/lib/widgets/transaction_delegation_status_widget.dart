import 'package:flutter/material.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/mixins/transaction_delegation_mixin.dart';
import 'package:flipper_models/db_model_export.dart';

/// Widget to display transaction delegation status
/// Shows the current status of a delegated transaction and allows actions
class TransactionDelegationStatusWidget extends StatefulWidget {
  final String transactionId;
  final bool showActions;

  const TransactionDelegationStatusWidget({
    Key? key,
    required this.transactionId,
    this.showActions = true,
  }) : super(key: key);

  @override
  State<TransactionDelegationStatusWidget> createState() =>
      _TransactionDelegationStatusWidgetState();
}

class _TransactionDelegationStatusWidgetState
    extends State<TransactionDelegationStatusWidget> {
  TransactionDelegationStatus? _status;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final taxController = TaxController<ITransaction>();

    final status = await taxController.getTransactionDelegationStatus(
      widget.transactionId,
    );

    String? error;
    if (status == TransactionDelegationStatus.error) {
      error = await taxController.getDelegationError(widget.transactionId);
    }

    if (mounted) {
      setState(() {
        _status = status;
        _error = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _retry() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final taxController = TaxController<ITransaction>();
      await taxController.retryDelegation(widget.transactionId);

      await _loadStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retry initiated'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Delegation'),
        content: const Text(
          'Are you sure you want to cancel this delegation? '
          'You will need to manually process this transaction.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final taxController = TaxController<ITransaction>();
      await taxController.cancelDelegation(widget.transactionId);

      await _loadStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delegation cancelled'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_status == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusDescription(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.showActions && _shouldShowActions()) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildActions(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (_status!) {
      case TransactionDelegationStatus.pending:
        icon = Icons.hourglass_empty;
        color = Colors.grey;
        break;
      case TransactionDelegationStatus.delegated:
        icon = Icons.sync;
        color = Colors.blue;
        break;
      case TransactionDelegationStatus.processing:
        icon = Icons.sync;
        color = Colors.orange;
        break;
      case TransactionDelegationStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case TransactionDelegationStatus.error:
        icon = Icons.error;
        color = Colors.red;
        break;
      case TransactionDelegationStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color, size: 32);
  }

  String _getStatusTitle() {
    switch (_status!) {
      case TransactionDelegationStatus.pending:
        return 'Pending Delegation';
      case TransactionDelegationStatus.delegated:
        return 'Waiting for Desktop';
      case TransactionDelegationStatus.processing:
        return 'Desktop Processing';
      case TransactionDelegationStatus.completed:
        return 'Completed by Desktop';
      case TransactionDelegationStatus.error:
        return 'Delegation Failed';
      case TransactionDelegationStatus.cancelled:
        return 'Delegation Cancelled';
    }
  }

  String _getStatusDescription() {
    switch (_status!) {
      case TransactionDelegationStatus.pending:
        return 'Transaction is pending delegation to desktop';
      case TransactionDelegationStatus.delegated:
        return 'Waiting for desktop to process receipt';
      case TransactionDelegationStatus.processing:
        return 'Desktop is generating receipt...';
      case TransactionDelegationStatus.completed:
        return 'Receipt generated and printed on desktop';
      case TransactionDelegationStatus.error:
        return 'An error occurred during processing';
      case TransactionDelegationStatus.cancelled:
        return 'Delegation was cancelled';
    }
  }

  bool _shouldShowActions() {
    return _status == TransactionDelegationStatus.error ||
        _status == TransactionDelegationStatus.delegated ||
        _status == TransactionDelegationStatus.cancelled;
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];

    if (_status == TransactionDelegationStatus.error ||
        _status == TransactionDelegationStatus.cancelled) {
      actions.add(
        TextButton.icon(
          onPressed: _retry,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Retry'),
        ),
      );
    }

    if (_status == TransactionDelegationStatus.delegated) {
      actions.add(
        TextButton.icon(
          onPressed: _cancel,
          icon: const Icon(Icons.cancel, size: 16),
          label: const Text('Cancel'),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
        ),
      );
    }

    return actions;
  }
}
