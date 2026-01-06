// ignore_for_file: unused_result

import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class AddBranch extends StatefulHookConsumerWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends ConsumerState<AddBranch> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _routerService = locator<RouterService>();

  String? _nameError;
  String? _locationError;

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(
      branchesProvider(businessId: ProxyService.box.getBusinessId()),
    );
    final isProcessing = ref.watch(isProcessingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onPop: () {
          _routerService.pop();
        },
        title: 'Branches',
        showActionButton: false,
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 90,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Section
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade200)),
              ),
              padding: const EdgeInsets.only(right: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Branch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Branch Name',
                      hint: 'Enter branch name',
                      errorText: _nameError,
                      onChanged: (_) => setState(() => _nameError = null),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      hint: 'Enter branch location',
                      errorText: _locationError,
                      onChanged: (_) => setState(() => _locationError = null),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isProcessing ? null : _handleAddBranch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: isProcessing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Create Branch',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Branches List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Branches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    Expanded(
                      child: branches.when(
                        data: (branchesList) =>
                            _buildBranchesList(branchesList),
                        loading: () => Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Text(
                            'Could not load branches',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            errorText: errorText,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBranchesList(List<dynamic> branches) {
    if (branches.isEmpty) {
      return Center(
        child: Text('No branches found', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final branch = branches[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.business,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name ?? "Unknown",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (branch.location != null && branch.location!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          branch.location!,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (branch.isDefault == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (branch.active == true && branch.isDefault != true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              SizedBox(width: 8),
              if (branch.isDefault != true)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                  onPressed: () => _showDeleteDialog(branch),
                  splashRadius: 20,
                  tooltip: 'Delete Branch',
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(dynamic branch) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Branch'),
          content: Text('Are you sure you want to delete ${branch.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed ?? false) {
        await ProxyService.strategy.deleteBranch(
          branchId: branch.id!,
          flipperHttpClient: ProxyService.http,
        );
        ref.refresh(
          branchesProvider(businessId: ProxyService.box.getBusinessId()),
        );
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
        ref.refresh(
          branchesProvider(businessId: ProxyService.box.getBusinessId()),
        );
        _nameController.clear();
        _locationController.clear();
        setState(() {
          _nameError = null;
          _locationError = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding branch'),
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
      _nameError = _nameController.text.isEmpty
          ? "Branch name is required"
          : null;
      _locationError = _locationController.text.isEmpty
          ? "Location is required"
          : null;
    });
    return _nameError == null && _locationError == null;
  }
}
