import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Fieldcompositeactivated extends StatefulHookConsumerWidget {
  const Fieldcompositeactivated({
    Key? key,
    required this.barCodeController,
    required this.skuController,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController barCodeController;
  final TextEditingController skuController;
  final GlobalKey<FormState> formKey;

  @override
  FieldcompositeactivatedState createState() => FieldcompositeactivatedState();
}

class FieldcompositeactivatedState
    extends ConsumerState<Fieldcompositeactivated> {
  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();

    if (branchId == null) {
      return Center(child: Text('Branch ID is null'));
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.skuController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "SKU is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'SKU',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.barCodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bar code is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Bar Code',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        ref.listenManual(
          skuProvider(branchId),
          (previous, next) {
            next.whenData((sku) {
              if (sku != null && mounted) {
                widget.skuController.text = sku.sku.toString();
              }
            });
          },
        );
      }
    });
  }
}
