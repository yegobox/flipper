// ignore_for_file: unused_result

import 'package:flipper_localize/flipper_localize.dart';
import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_location_picker.dart';
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

class AddBranch extends StatefulHookConsumerWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends ConsumerState<AddBranch> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _routerService = locator<RouterService>();

  BranchServices get _services => ref.read(branchServicesProvider);

  String? _nameError;
  String? _locationError;

  /// Optional map pin for the branch being created.
  BranchCoordinates? _pickedLocation;

  bool _isDefaultBranch(Branch branch) => branch.isDefault == true;

  bool _canDeleteBranch(Branch branch, List<Branch> branches) {
    if (_isDefaultBranch(branch)) return false;
    if (branches.length <= 1) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _refreshBranchesFromSupabase(),
    );
  }

  Future<void> _refreshBranchesFromSupabase() async {
    if (!mounted) return;
    final businessId = _services.box.getBusinessId();
    if (businessId == null) return;
    await hydrateBusinessBranchesFromRemote(businessId: businessId);
    if (!mounted) return;
    ref.invalidate(allBusinessBranchesProvider(businessId: businessId));
  }

  @override
  Widget build(BuildContext context) {
    final businessId = _services.box.getBusinessId();
    final branches = ref.watch(
      allBusinessBranchesProvider(businessId: businessId),
    );
    final isProcessing = ref.watch(isProcessingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onPop: () {
          _routerService.pop();
        },
        title: context.flipperL10n.branchesTitle,
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
                      context.flipperL10n.branchesAddNew,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: context.flipperL10n.branchesName,
                      hint: context.flipperL10n.branchesNameHint,
                      errorText: _nameError,
                      onChanged: (_) => setState(() => _nameError = null),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationController,
                      label: context.flipperL10n.location,
                      hint: context.flipperL10n.branchesLocationHint,
                      errorText: _locationError,
                      onChanged: (_) => setState(() => _locationError = null),
                    ),
                    SizedBox(height: 8),
                    _buildMapPinRow(),
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
                                context.flipperL10n.branchesCreate,
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
                      context.flipperL10n.branchesAll,
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
                            context.flipperL10n.branchesLoadFailed,
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

  Widget _buildMapPinRow() {
    final picked = _pickedLocation;
    if (picked == null) {
      return TextButton.icon(
        onPressed: () async {
          final result = await showBranchLocationPicker(
            context,
            location: _services.location,
          );
          if (result != null && mounted) {
            setState(() => _pickedLocation = result);
          }
        },
        icon: const Icon(Icons.add_location_alt_outlined, size: 18),
        label: Text(context.flipperL10n.branchLocationPinOnMap),
      );
    }
    return Row(
      children: [
        Icon(Icons.location_pin, size: 18, color: Colors.red.shade400),
        SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () async {
              final result = await showBranchLocationPicker(
                context,
                location: _services.location,
                latitude: picked.latitude,
                longitude: picked.longitude,
              );
              if (result != null && mounted) {
                setState(() => _pickedLocation = result);
              }
            },
            child: Text(
              formatBranchCoordinates(picked.latitude, picked.longitude),
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ),
        Semantics(
          label: context.flipperL10n.branchLocationClear,
          button: true,
          child: IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
            onPressed: () => setState(() => _pickedLocation = null),
            splashRadius: 18,
          ),
        ),
      ],
    );
  }

  Future<void> _setBranchLocation(Branch branch) async {
    final result = await showBranchLocationPicker(
      context,
      location: _services.location,
      latitude: branch.latitude,
      longitude: branch.longitude,
    );
    if (result == null || !mounted) return;
    try {
      await _services.strategy.updateBranchCoordinates(
        branchId: branch.id,
        latitude: result.latitude,
        longitude: result.longitude,
        flipperHttpClient: _services.http,
      );
      await _refreshBranchesFromSupabase();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.flipperL10n.branchLocationSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.flipperL10n.branchLocationSaveFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBranchesList(List<Branch> branches) {
    if (branches.isEmpty) {
      return Center(
        child: Text(
          context.flipperL10n.branchesNoneFound,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.separated(
      itemCount: branches.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final branch = branches[index];
        final canDelete = _canDeleteBranch(branch, branches);
        final hasMapLocation = hasRealBranchCoordinates(
          branch.latitude,
          branch.longitude,
        );
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
                      branch.name ?? context.flipperL10n.dashUnknown,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        hasMapLocation
                            ? formatBranchCoordinates(
                                branch.latitude!,
                                branch.longitude!,
                              )
                            : context.flipperL10n.branchLocationMissing,
                        style: TextStyle(
                          color: hasMapLocation
                              ? Colors.grey.shade500
                              : Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: context.flipperL10n.branchLocationSet,
                button: true,
                child: IconButton(
                  icon: Icon(
                    hasMapLocation
                        ? Icons.location_on_outlined
                        : Icons.add_location_alt_outlined,
                    color: hasMapLocation
                        ? Colors.grey.shade600
                        : Colors.orange.shade700,
                    size: 20,
                  ),
                  onPressed: () => _setBranchLocation(branch),
                  splashRadius: 20,
                ),
              ),
              if (branch.isDefault == true)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.flipperL10n.branchesDefaultBadge,
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
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.flipperL10n.branchesActiveBadge,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              SizedBox(width: 8),
              if (canDelete)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                  onPressed: () =>
                      _showDeleteDialog(branch, branches: branches),
                  splashRadius: 20,
                  tooltip: context.flipperL10n.branchesDelete,
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(
    Branch branch, {
    required List<Branch> branches,
  }) async {
    if (!_canDeleteBranch(branch, branches)) {
      if (!mounted) return;
      final message = _isDefaultBranch(branch)
          ? context.flipperL10n.branchesDefaultCannotDelete
          : context.flipperL10n.branchesKeepOne;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.flipperL10n.branchesDelete),
          content: Text(
            context.flipperL10n.branchesDeleteConfirm(branch.name ?? ''),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.flipperL10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                context.flipperL10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed ?? false) {
        if (!_canDeleteBranch(branch, branches)) return;
        try {
          await _services.strategy.deleteBranch(
            branchId: branch.id,
            flipperHttpClient: _services.http,
          );
          await _refreshBranchesFromSupabase();
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString().contains('Default branch')
                    ? context.flipperL10n.branchesDefaultCannotDelete
                    : context.flipperL10n.branchesDeleteFailed,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  Future<void> _handleAddBranch() async {
    if (validateForm()) {
      try {
        ref.read(isProcessingProvider.notifier).startProcessing();
        await _services.strategy.addBranch(
          isDefault: false,
          active: true,
          name: _nameController.text,
          businessId: _services.box.getBusinessId()!,
          location: _locationController.text,
          latitude: _pickedLocation?.latitude,
          longitude: _pickedLocation?.longitude,
          userOwnerPhoneNumber: _services.box.getUserPhone()!,
          flipperHttpClient: _services.http,
        );
        await _refreshBranchesFromSupabase();
        _nameController.clear();
        _locationController.clear();
        setState(() {
          _nameError = null;
          _locationError = null;
          _pickedLocation = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.flipperL10n.branchesAddError),
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
          ? context.flipperL10n.branchesNameRequired
          : null;
      _locationError = _locationController.text.isEmpty
          ? context.flipperL10n.branchesLocationRequired
          : null;
    });
    return _nameError == null && _locationError == null;
  }
}
