// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddBranch extends StatefulHookConsumerWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends ConsumerState<AddBranch> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _locationError;

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(branchesProvider((active: false)));
    final isProcessing = ref.watch(isProcessingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: Text(
          'Branch Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add New Branch',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Branch Name',
                          hint: 'Enter branch name',
                          errorText: _nameError,
                          prefixIcon: Icons.business,
                          onChanged: (_) => setState(() => _nameError = null),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _locationController,
                          label: 'Location',
                          hint: 'Enter branch location',
                          errorText: _locationError,
                          prefixIcon: Icons.location_on,
                          onChanged: (_) =>
                              setState(() => _locationError = null),
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isProcessing ? null : _handleAddBranch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isProcessing
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Add Branch',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24),
              // Branches List
              Expanded(
                child: branches.when(
                  data: (branchesList) => _buildBranchesList(branchesList),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading branches',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildBranchesList(List<dynamic> branches) {
    return ListView.builder(
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.name ?? "-",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey.shade600),
                          SizedBox(width: 4),
                          Text(
                            branch.location ?? "",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStatusChip(
                            icon: Icons.star,
                            label: 'Default',
                            isActive: branch.isDefault!,
                            activeColor: Colors.amber,
                          ),
                          SizedBox(width: 12),
                          _buildStatusChip(
                            icon: Icons.check_circle,
                            label: 'Active',
                            isActive: branch.active!,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!branch.isDefault!)
                  IconButton(
                    onPressed: () => _showDeleteDialog(branch),
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? activeColor.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? activeColor : Colors.grey,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(dynamic branch) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Delete Branch'),
          content: Text('Are you sure you want to delete ${branch.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed ?? false) {
        await ProxyService.strategy.deleteBranch(
          branchId: branch.serverId!,
          flipperHttpClient: ProxyService.http,
        );
        ref.refresh(branchesProvider((active: false)));
      }
    });
  }

  Future<void> _handleAddBranch() async {
    if (validateForm()) {
      try {
        ref.read(isProcessingProvider.notifier).startProcessing();
        await ProxyService.strategy.addBranch(
          isDefault: false,
          active: false,
          name: _nameController.text,
          businessId: ProxyService.box.getBusinessId()!,
          location: _locationController.text,
          userOwnerPhoneNumber: ProxyService.box.getUserPhone()!,
          flipperHttpClient: ProxyService.http,
        );
        ref.refresh(branchesProvider((active: false)));
        _nameController.clear();
        _locationController.clear();
        setState(() {
          _nameError = null;
          _locationError = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Error adding branch'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        ref.read(isProcessingProvider.notifier).stopProcessing();
      }
    }
  }

  bool validateForm() {
    setState(() {
      _nameError =
          _nameController.text.isEmpty ? "Branch name is required" : null;
      _locationError =
          _locationController.text.isEmpty ? "Location is required" : null;
    });
    return _nameError == null && _locationError == null;
  }
}
