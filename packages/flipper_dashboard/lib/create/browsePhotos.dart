// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flipper_models/providers/upload_providers.dart';
import 'package:flipper_models/view_models/upload_viewmodel.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/asset_sync_service.dart';
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
  _BrowsephotosState createState() => _BrowsephotosState();
}

class _BrowsephotosState extends ConsumerState<Browsephotos> {
  final talker = TalkerFlutter.init();
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  bool isOfflineMode = false;

  // We don't need to track pending uploads in the UI since background sync handles it

  // Stream subscription for sync status updates
  StreamSubscription<SyncStatus>? _syncStatusSubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    // Listen for asset sync status updates
    _syncStatusSubscription =
        AssetSyncService().syncStatusStream.listen(_handleSyncStatusUpdate);
  }

  @override
  void dispose() {
    _syncStatusSubscription?.cancel();
    super.dispose();
  }

  // Handle sync status updates
  void _handleSyncStatusUpdate(SyncStatus status) {
    if (status.status == SyncState.inProgress) {
      // Show a subtle indicator that sync is happening
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status.message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (status.status == SyncState.completed && status.count > 0) {
      // Show success message if assets were synced
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status.message),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    } else if (status.status == SyncState.error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status.message),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Check for internet connectivity and set offline mode accordingly
  Future<void> _checkConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final hasConnection =
        connectivityResults.any((result) => result != ConnectivityResult.none);

    setState(() {
      isOfflineMode = !hasConnection;
    });

    // Check if there are any pending uploads
    if (hasConnection) {
      _checkPendingUploads();
    }
  }

  // Check if there are any pending uploads that need to be synced
  Future<void> _checkPendingUploads() async {
    try {
      // Just check if there are offline assets, but we don't need to update UI
      await ProxyService.strategy.hasOfflineAssets();
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

  // Try to load an image from the asset's localPath in the database
  Future<String?> _tryLoadFromAssetPath(String assetName) async {
    try {
      // Look up the asset in the database
      final asset = await ProxyService.strategy.getAsset(assetName: assetName);

      // If the asset exists and has a local path, return it
      if (asset != null &&
          asset.localPath != null &&
          asset.localPath!.isNotEmpty) {
        final file = File(asset.localPath!);
        if (await file.exists()) {
          return asset.localPath!;
        }
      }
      return null;
    } catch (e) {
      talker.error('Error loading asset from local path: $e');
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
    // Check connectivity before proceeding
    await _checkConnectivity();

    setState(() {
      isUploading = true;
    });

    // Reset upload progress
    ref.read(uploadProgressProvider.notifier).state = 0.0;

    try {
      // Check connectivity again before proceeding
      await _checkConnectivity();

      final productRef = ref.watch(unsavedProductProvider);
      if (productRef == null) {
        throw Exception('No product selected');
      }

      // Check if we need to delete an existing image first
      if (productRef.imageUrl != null && productRef.imageUrl!.isNotEmpty) {
        talker.info('Replacing existing image: ${productRef.imageUrl}');
        // Try to find and delete the existing asset
        try {
          final existingAsset = await ProxyService.strategy
              .getAsset(assetName: productRef.imageUrl!);
          if (existingAsset != null) {
            // If we're online, try to delete from S3 immediately
            if (!isOfflineMode) {
              await ProxyService.strategy
                  .removeS3File(fileName: productRef.imageUrl!);
            } else {
              // If offline, add to pending deletions to be processed when online
              await AssetSyncService().addPendingDeletion(productRef.imageUrl!);
              talker
                  .info('Added ${productRef.imageUrl} to pending S3 deletions');
            }

            // Delete the local file if it exists (we can do this regardless of connectivity)
            if (existingAsset.localPath != null &&
                existingAsset.localPath!.isNotEmpty) {
              final file = File(existingAsset.localPath!);
              if (await file.exists()) {
                await file.delete();
                talker.info('Deleted local file: ${existingAsset.localPath}');
              }
            }
          }
        } catch (e) {
          talker.error('Error deleting existing asset: $e');
          // Continue with the upload even if deletion fails
        }
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
    setState(() {
      isUploading = true;
    });

    try {
      // Get image from gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() {
          isUploading = false;
        });
        return;
      }

      final File imageFile = File(image.path);
      final branchId = ProxyService.box.getBranchId();
      final businessId = ProxyService.box.getBusinessId();

      if (branchId == null || businessId == null) {
        throw Exception('Branch ID or Business ID not available');
      }

      // Save image locally
      final asset = await ProxyService.strategy.saveImageLocally(
        imageFile: imageFile,
        productId: productId,
        branchId: branchId,
        businessId: businessId,
      );

      // Update the product with the local asset name
      final product = ref.watch(unsavedProductProvider);
      if (product != null && asset.assetName != null) {
        product.imageUrl = asset.assetName;
        ref.read(unsavedProductProvider.notifier).emitProduct(value: product);
      }

      // Background sync service will handle this automatically

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved locally. Will be uploaded when online.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        isUploading = false;
      });
    } catch (e) {
      talker.error('Error saving image locally: $e');
      setState(() {
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
                                // Try to load from network if local file fails
                                return FutureBuilder(
                                  future: _tryLoadFromAssetPath(
                                      widget.imageUrl!.toString()),
                                  builder: (context, assetSnapshot) {
                                    if (assetSnapshot.hasData &&
                                        assetSnapshot.data != null) {
                                      return Image.file(
                                        File(assetSnapshot.data!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.image_not_supported,
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
                                );
                              },
                            );
                          } else {
                            // Try to load from asset's localPath
                            return FutureBuilder(
                              future: _tryLoadFromAssetPath(
                                  widget.imageUrl!.toString()),
                              builder: (context, assetSnapshot) {
                                if (assetSnapshot.hasData &&
                                    assetSnapshot.data != null) {
                                  return Image.file(
                                    File(assetSnapshot.data!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.image_not_supported,
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
                              color: isOfflineMode
                                  ? Colors.orange[400]
                                  : Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isOfflineMode
                                  ? 'Add Image (Offline)'
                                  : 'Add Image',
                              style: TextStyle(
                                color: isOfflineMode
                                    ? Colors.orange[600]
                                    : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            // Offline status indicator if there are pending uploads
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
