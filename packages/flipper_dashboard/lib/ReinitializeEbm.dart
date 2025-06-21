import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class ReInitializeEbmDialog extends StatefulWidget {
  const ReInitializeEbmDialog({Key? key}) : super(key: key);

  @override
  _ReInitializeEbmDialogState createState() => _ReInitializeEbmDialogState();
}

class _ReInitializeEbmDialogState extends State<ReInitializeEbmDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tinController = TextEditingController();
  final _bhfIdController = TextEditingController();
  final _dvcSrlNoController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.refresh, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  "Re-initialize EBM",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _tinController,
                    labelText: 'TIN',
                    prefixIcon: Icons.numbers,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'TIN is required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _bhfIdController,
                    labelText: 'BHF ID',
                    prefixIcon: Icons.business,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'BHF ID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _dvcSrlNoController,
                    labelText: 'Device Serial Number',
                    prefixIcon: Icons.devices,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Device Serial Number is required'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _handleReInitialize,
                  child: _isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Processing...'),
                          ],
                        )
                      : const Text('Re-initialize'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _handleReInitialize() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final tin = _tinController.text;
    final bhfId = _bhfIdController.text;
    final dvcSrlNo = _dvcSrlNoController.text;

    try {
      final businessInfo = await ProxyService.strategy.initializeEbm(
        tin: tin,
        bhfId: bhfId,
        dvcSrlNo: dvcSrlNo,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      // Show an improved success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildSuccessDialog(context, businessInfo);
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        // If the error message is already user-friendly (from our API handling), use it as is
        // Otherwise, prepend a generic error message
        final errorMessage = e.toString();
        _errorMessage = errorMessage.startsWith('Exception: ')
            ? errorMessage.substring('Exception: '.length)
            : 'Failed to initialize EBM: $errorMessage';
      });
    }
  }

  Widget _buildSuccessDialog(BuildContext context, dynamic businessInfo) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "EBM Initialized Successfully",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    label: "Taxpayer Name",
                    value: businessInfo.taxprNm,
                    icon: Icons.person_outline,
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    context,
                    label: "Branch Name",
                    value: businessInfo.bhfNm,
                    icon: Icons.store_outlined,
                  ),
                  // Add more info rows as needed
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Close both dialogs
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary.withOpacity(0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tinController.dispose();
    _bhfIdController.dispose();
    _dvcSrlNoController.dispose();
    super.dispose();
  }
}
