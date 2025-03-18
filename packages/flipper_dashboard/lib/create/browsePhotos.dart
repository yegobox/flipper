// ignore_for_file: unused_result

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/upload_viewmodel.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class Browsephotos extends StatefulHookConsumerWidget {
  final ValueChanged<Color> onColorSelected;
  final String? imageUrl;
  final Color currentColor;

  Browsephotos({
    super.key,
    required this.onColorSelected,
    this.imageUrl,
    this.currentColor = Colors.blue,
  });

  @override
  BrowsephotosState createState() => BrowsephotosState();
}

class BrowsephotosState extends ConsumerState<Browsephotos> {
  final talker = TalkerFlutter.init();
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

  Future<void> _showColorPickerDialog(BuildContext context) async {
    final Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: true,
              },
              width: 44,
              height: 44,
              borderRadius: 22,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 165,
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      setState(() {
        selectedColor = newColor;
      });
      widget.onColorSelected(newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => UploadViewModel(),
      builder: (context, model, child) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                if (widget.imageUrl == null) {
                  await _showColorPickerDialog(context);
                }
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: widget.imageUrl == null ? selectedColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: widget.imageUrl != null
                    ? Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[500],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.color_lens,
                              size: 50,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Click to pick color',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  model.browsePictureFromGallery(
                    id: ref.watch(unsavedProductProvider)!.id,
                    callBack: (product) {
                      talker.warning("ImageToProduct:${product.imageUrl}");
                      ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
                    },
                    urlType: URLTYPE.PRODUCT,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, size: 20, color: Colors.grey[800]),
                    const SizedBox(width: 8),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
