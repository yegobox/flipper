import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Fieldcompositeactivated extends StatefulHookConsumerWidget {
  const Fieldcompositeactivated({
    super.key,
    required this.barCodeController,
    required this.skuController,
    required this.formKey,
  });
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
    final branchId = ProxyService.box.getBranchId(); // Get the branch ID

    // Handle branchId being null
    if (branchId == null) {
      return Center(child: Text('Branch ID is null'));
    }

    // 1. Access the stream (using ref.watch)
    final skuStream = ref.watch(skuProvider(branchId));

    // Assuming `initialSku` comes from `skuStream` or some other source
    final initialSku = skuStream.when(
      data: (data) => data,
      loading: () => null,
      error: (err, stack) => null,
    );

    // Set initial value for the barCodeController
    if (initialSku != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // if (widget.barCodeController.text.isEmpty) {
        widget.skuController.text = initialSku.sku.toString();
        // }
      });
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
                decoration: InputDecoration(
                  labelText: 'SKU',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: widget.barCodeController,
                decoration: InputDecoration(
                  labelText: 'Bar Code',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
