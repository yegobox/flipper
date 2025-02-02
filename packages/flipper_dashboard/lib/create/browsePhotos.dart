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
  final ValueChanged<Color> onColorSelected; // Callback for selected color

  Browsephotos({super.key, required this.onColorSelected});

  @override
  BrowsephotosState createState() => BrowsephotosState();
}

class BrowsephotosState extends ConsumerState<Browsephotos> {
  final talker = TalkerFlutter.init();
  Color selectedColor = Colors.blue; // Default color

  // Function to show the color picker in a modal dialog
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
                // Update the selected color while the dialog is open
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
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(selectedColor); // Return the selected color
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Update the selected color if the user pressed "OK"
    if (newColor != null) {
      setState(() {
        selectedColor = newColor;
      });

      // Invoke the callback with the selected color
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
            // Button to open the color picker modal
            SizedBox(
              width: 180,
              child: FlipperButton(
                textColor: Colors.black,
                borderRadius: BorderRadius.circular(1),
                text: 'Pick a Color',
                onPressed: () async {
                  await _showColorPickerDialog(
                      context); // Open the color picker modal
                },
              ),
            ),

            // Choose a Photo Button
            SizedBox(
              width: 180,
              child: TextButton(
                child: const Text(
                  'Choose a Photo',
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
                    id: ref.watch(unsavedProductProvider)!.id,
                    callBack: (product) {
                      talker.warning("ImageToProduct:${product.imageUrl}");
                      ref
                          .read(unsavedProductProvider.notifier)
                          .emitProduct(value: product);
                    },
                    urlType: URLTYPE.PRODUCT,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
