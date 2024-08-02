// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
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
    final branches = ref.watch(branchesProvider);
    final isProcessing = ref.watch(isProcessingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Manager'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Container(
                width: 300,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Branch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorText: _nameError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _nameError = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorText: _locationError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _locationError = null;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    BoxButton(
                      key: const Key('addBranch'),
                      title: "Add Branch",
                      onTap: () async {
                        if (validateForm()) {
                          try {
                            ref
                                .read(isProcessingProvider.notifier)
                                .startProcessing();
                            await ProxyService.local.addBranch(
                              name: _nameController.text,
                              businessId: ProxyService.box.getBusinessId()!,
                              location: _locationController.text,
                              userOwnerPhoneNumber:
                                  ProxyService.box.getUserPhone()!,
                            );
                            ref.refresh(branchesProvider);
                            _nameController.clear();
                            _locationController.clear();
                            setState(() {
                              _nameError = null;
                              _locationError = null;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Internal error while adding branch'),
                              ),
                            );
                          } finally {
                            ref
                                .read(isProcessingProvider.notifier)
                                .stopProcessing();
                          }
                        }
                      },
                      busy: isProcessing,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Icon(Icons.location_pin, color: Colors.blue),
                      title: Text(
                        branch.name ?? "-",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${branch.location ?? ""}'),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: branch.isDefault
                                      ? Colors.yellow
                                      : Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                  'Default: ${branch.isDefault ? 'Yes' : 'No'}'),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: branch.active!
                                      ? Colors.green
                                      : Colors.grey),
                              SizedBox(width: 4),
                              Text('Active: ${branch.active! ? 'Yes' : 'No'}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: // Add trailing icon for delete action
                          IconButton(
                        onPressed: branch.isDefault
                            ? null // Disable delete for default branch
                            : () async {
                                if (await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Branch'),
                                          content: Text(
                                              'Are you sure you want to delete ${branch.name}?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    ) ??
                                    false) {
                                  // If confirmed
                                  // Delete the branch
                                  await ProxyService.local
                                      .deleteBranch(branchId: branch.serverId!);
                                  ref.refresh(
                                      branchesProvider); // Refresh the provider
                                }
                              },
                        icon: Icon(Icons.delete,
                            color: branch.isDefault
                                ? Colors.grey
                                : Colors.red), // Grey if default
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateForm() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? "Name is required" : null;
      _locationError =
          _locationController.text.isEmpty ? "Location is required" : null;
    });
    return _nameError == null && _locationError == null;
  }
}
