// ignore_for_file: unused_result

import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flipper_models/providers/upload_providers.dart';
import 'package:flipper_models/providers/product_provider.dart';
import 'package:flipper_models/view_models/upload_viewmodel.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

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
  bool isUploading = false;
  bool isOfflineMode = false;
  
  // Provider to track if there are pending uploads
  final hasPendingUploadsProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }
  
  // Check for internet connectivity and set offline mode accordingly
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOfflineMode = connectivityResult == ConnectivityResult.none;
    });
    
    // Check if there are any pending uploads
    if (!isOfflineMode) {
      _checkPendingUploads();
    }
  }
  
  // Check if there are any pending uploads that need to be synced
  Future<void> _checkPendingUploads() async {
    try {
      final hasOfflineAssets = await ProxyService.strategy.hasOfflineAssets();
      ref.read(hasPendingUploadsProvider.notifier).state = hasOfflineAssets;
    } catch (e) {
      talker.error('Error checking pending uploads: $e');
    }
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
    Color tempColor = widget.currentColor;
    final Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: tempColor,
              onColorChanged: (Color color) {
                setState(() {
                  tempColor = color;
                });
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
                Navigator.of(context).pop(tempColor);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (newColor != null) {
      widget.onColorSelected(newColor);
    }
  }

  // Helper function to handle image upload with offline support
  Future<void> _handleImageUpload(UploadViewModel model) async {
    setState(() {
      isUploading = true;
    });
    ref.read(uploadProgressProvider.notifier).state = 0.0;

    try {
      // Check connectivity again before proceeding
      await _checkConnectivity();
      
      final productRef = ref.watch(unsavedProductProvider);
      if (productRef == null) {
        throw Exception('No product selected');
      }
      
      if (isOfflineMode) {
        // Handle offline image upload
        await _handleOfflineImageUpload(productRef.id);
      } else {
        // Handle online image upload using existing method
        final product = await model.browsePictureFromGallery(
          id: productRef.id,
          urlType: URLTYPE.PRODUCT,
        );
        talker.warning("ImageToProduct:${product.imageUrl}");
        ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
      }
      
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
  
  // Handle offline image upload
  Future<void> _handleOfflineImageUpload(String productId) async {
    try {
      // Get image from gallery
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile == null) {
        throw Exception('No image selected');
      }
      
      final imageFile = File(pickedFile.path);
      
      // Get business and branch IDs
      final branchId = ProxyService.box.getBranchId()!;
      final businessId = ProxyService.box.getBusinessId()!;
      
      // Save image locally using our new method
      final asset = await ProxyService.strategy.saveImageLocally(
        imageFile: imageFile,
        productId: productId,
        branchId: branchId,
        businessId: businessId,
      );
      
      // Update the product with the local asset name
      final product = ref.watch(unsavedProductProvider);
      if (product != null) {
        product.imageUrl = asset.assetName;
        ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
      }
      
      // Update the pending uploads provider
      ref.read(hasPendingUploadsProvider.notifier).state = true;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved locally. Will be uploaded when online.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      talker.error('Offline upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      rethrow;
    }
  }
  
  // Sync offline assets when online
  Future<void> _syncOfflineAssets() async {
    try {
      setState(() {
        isUploading = true;
      });
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection. Try again later.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isUploading = false;
        });
        return;
      }
      
      // Sync offline assets
      final uploadedAssets = await ProxyService.strategy.syncOfflineAssets();
      
      // Check if there are still pending uploads
      final hasOfflineAssets = await ProxyService.strategy.hasOfflineAssets();
      ref.read(hasPendingUploadsProvider.notifier).state = hasOfflineAssets;
      
      setState(() {
        isUploading = false;
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Synced ${uploadedAssets.length} images'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      talker.error('Sync error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sync images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadProgress = ref.watch(uploadProgressProvider);
    final hasPendingUploads = ref.watch(hasPendingUploadsProvider);

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
                      ? widget.currentColor
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
                              isOfflineMode ? Icons.cloud_off : Icons.image,
                              size: 40,
                              color: isOfflineMode ? Colors.orange[400] : Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isOfflineMode ? 'Add Image (Offline)' : 'Add Image',
                              style: TextStyle(
                                color: isOfflineMode ? Colors.orange[600] : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (hasPendingUploads && !isOfflineMode) ...[
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                icon: Icon(Icons.cloud_upload, size: 16),
                                label: Text('Sync Images', style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size(100, 30),
                                ),
                                onPressed: isUploading ? null : _syncOfflineAssets,
                              ),
                            ],
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
