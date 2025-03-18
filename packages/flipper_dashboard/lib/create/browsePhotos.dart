// ignore_for_file: unused_result

import 'dart:io';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/upload_viewmodel.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/providers/upload_providers.dart';

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
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    Directory appSupportDir = await getApplicationSupportDirectory();

    final imageFilePath = '${appSupportDir.path}/$imageFileName';
    final file = File(imageFilePath);

    if (await file.exists()) {
      return imageFilePath;
    } else {
      return null;
    }
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

  // Helper function to handle image upload
  Future<void> _handleImageUpload(UploadViewModel model) async {
    setState(() {
      isUploading = true;
    });
    ref.read(uploadProgressProvider.notifier).state = 0.0;

    try {
      final product = await model.browsePictureFromGallery(
        id: ref.watch(unsavedProductProvider)!.id,
        urlType: URLTYPE.PRODUCT,
      );
      talker.warning("ImageToProduct:${product.imageUrl}");
      ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
      setState(() {
        isUploading = false;
      });
      ref.read(uploadProgressProvider.notifier).state = 0.0;
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ref.read(uploadProgressProvider.notifier).state = 0.0;
      talker.error("Upload error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadProgress = ref.watch(uploadProgressProvider);

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () {
        final model = UploadViewModel();
        model.setRef(ref);
        return model;
      },
      builder: (context, model, child) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                if (widget.imageUrl == null) {
                  await _showColorPickerDialog(context);
                } else {
                  await _handleImageUpload(model);
                }
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: widget.imageUrl == null
                      ? selectedColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    if (widget.imageUrl != null)
                      FutureBuilder<String?>(
                        future:
                            getImageFilePath(imageFileName: widget.imageUrl!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Image.file(
                              File(snapshot.data!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                talker.error("Image load error: $error");
                                return Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey[500],
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey[500],
                              ),
                            );
                          }
                        },
                      )
                    else
                      Center(
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
                    if (widget.imageUrl != null)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Click to change image',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: uploadProgress,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.lerp(Colors.blue, Colors.green,
                                              uploadProgress) ??
                                          Colors.blue),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${(uploadProgress * 100).toInt()}%',
                                  style: TextStyle(
                                    color: Color.lerp(Colors.blue, Colors.green,
                                            uploadProgress) ??
                                        Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            const SizedBox(height: 8),
            if (widget.imageUrl == null)
              SizedBox(
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isUploading
                        ? Color.lerp(Colors.blue, Colors.green, uploadProgress)
                        : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: isUploading
                      ? null
                      : () async {
                          await _handleImageUpload(model);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isUploading)
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 8),
                          child: CircularProgressIndicator(
                            value: uploadProgress,
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        Icon(Icons.upload, size: 20, color: Colors.grey[800]),
                      const SizedBox(width: 8),
                      Text(
                        isUploading
                            ? '${(uploadProgress * 100).toInt()}%'
                            : 'Upload Image',
                        style: TextStyle(
                          color: isUploading ? Colors.white : Colors.grey[800],
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
