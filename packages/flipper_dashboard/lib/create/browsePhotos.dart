import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/upload_viewmodel.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Browsephotos extends StatefulHookConsumerWidget {
  Browsephotos({super.key, required this.productId});
  final int productId;

  @override
  BrowsephotosState createState() => BrowsephotosState();
}

class BrowsephotosState extends ConsumerState<Browsephotos> {
  final talker = TalkerFlutter.init();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => UploadViewModel(),
        builder: (context, model, child) {
          return SizedBox(
            height: 64,
            width: 180,
            child: TextButton(
              child: Text(
                'Choose Photo',
              ),
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.grey.withOpacity(0.04);
                    }
                    if (states.contains(WidgetState.focused) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.grey.withOpacity(0.12);
                    }
                    return null;
                  },
                ),
              ),
              onPressed: () async {
                model.browsePictureFromGallery(
                  id: widget.productId,
                  callBack: (product) {
                    // talker.info(product.imageUrl);
                    ref
                        .read(productProvider.notifier)
                        .emitProduct(value: product);
                  },
                  urlType: URLTYPE.PRODUCT,
                );
              },
            ),
          );
        });
  }
}
