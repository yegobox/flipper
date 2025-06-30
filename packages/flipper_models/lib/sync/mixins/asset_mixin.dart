import 'dart:async';
import 'dart:io';
import 'package:flipper_models/SessionManager.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:path/path.dart' as path;
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:supabase_models/brick/databasePath.dart';
import 'package:supabase_models/brick/repository.dart';

import 'package:talker_flutter/talker_flutter.dart';

abstract class AssetInterface {
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"});
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath});

  Future<void> reDownloadAsset();
  FutureOr<Assets?> getAsset({String? assetName, String? productId});
  FutureOr<void> addAsset(
      {required String productId,
      required assetName,
      required int branchId,
      required int businessId});

  /// Save an image file locally and create an asset record
  /// Returns the asset record with local path information
  Future<Assets> saveImageLocally({
    required File imageFile,
    required String productId,
    required int branchId,
    required int businessId,
  });

  /// Synchronize offline assets by uploading them to cloud storage
  /// Returns a list of successfully uploaded asset IDs
  Future<List<String>> syncOfflineAssets();

  /// Check if there are any offline assets that need to be synced
  Future<bool> hasOfflineAssets();
}

mixin AssetMixin implements AssetInterface {
  final sessionManager = SessionManager();

  // Queue to track assets that need to be uploaded
  final List<String> _pendingUploads = [];

  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) async {
    try {
      talker.info("Starting downloadAssetSave");
      int branchId = ProxyService.box.getBranchId()!;

      // Case 1: Single asset download
      if (assetName != null) {
        talker.info("Downloading single asset: $assetName");
        return downloadAsset(
            branchId: branchId, assetName: assetName, subPath: subPath!);
      }

      // Case 2: Multiple assets download
      talker.info("Fetching assets for branch: $branchId");
      List<Assets> assets = await repository.get(
          query: brick.Query(
              where: [brick.Where('branchId').isExactly(branchId)]));

      talker.info("Found ${assets.length} assets for branch: $branchId");

      // Create a controller for progress reporting
      StreamController<double> progressController = StreamController<double>();

      // Filter out assets with null names or existing localPath
      List<Assets> assetsToDownload = [];
      for (Assets asset in assets) {
        if (asset.assetName == null) {
          talker.warning('Asset name is null for asset: ${asset.id}');
          continue;
        }

        // Skip assets that already have a localPath
        if (asset.localPath != null && asset.localPath!.isNotEmpty) {
          talker.info('Asset already has localPath: ${asset.assetName}');
          // Report 100% progress for existing files
          progressController.add(100.0);
          continue;
        }

        // Also check if file exists on disk
        Directory directoryPath = await getSupportDir();
        final filePath = path.join(directoryPath.path, asset.assetName!);
        final file = File(filePath);

        if (await file.exists()) {
          talker.info('Asset file already exists: ${asset.assetName}');
          // Update the asset record with the local path
          asset.localPath = filePath;
          await repository.upsert<Assets>(asset);
          // Report 100% progress for existing files
          progressController.add(100.0);
        } else {
          talker.info('Asset needs download: ${asset.assetName}');
          assetsToDownload.add(asset);
        }
      }

      talker.info("${assetsToDownload.length} assets need downloading");

      // If no assets to download, close the stream and return
      if (assetsToDownload.isEmpty) {
        talker.info("No assets need downloading");
        progressController.close();
        return progressController.stream;
      }

      // Download assets that need downloading
      int completedDownloads = 0;
      for (Assets asset in assetsToDownload) {
        talker.info('Starting download for: ${asset.assetName}');

        // Get the download stream
        Stream<double> downloadStream = await downloadAsset(
            branchId: branchId, assetName: asset.assetName!, subPath: subPath!);

        // Listen to the download stream and add its events to the main controller
        downloadStream.listen((progress) {
          talker.info('Download progress for ${asset.assetName}: $progress');
          progressController.add(progress);

          // If this download completes, update the asset record
          if (progress >= 100.0) {
            // Update the asset record with the local path when download completes
            getSupportDir().then((dir) {
              final filePath = path.join(dir.path, asset.assetName!);
              asset.localPath = filePath;
              repository.upsert<Assets>(asset);
            });

            // If all downloads are complete, close the controller
            completedDownloads++;
            if (completedDownloads >= assetsToDownload.length) {
              talker.info('All downloads completed');
              progressController.close();
            }
          }
        }, onError: (error) {
          talker.error('Error downloading ${asset.assetName}: $error');
          progressController.addError(error);

          // Count as completed even if there's an error
          completedDownloads++;
          if (completedDownloads >= assetsToDownload.length) {
            talker.info('All downloads completed (with some errors)');
            progressController.close();
          }
        }, onDone: () {
          talker.info('Download completed for: ${asset.assetName}');
        });
      }

      return progressController.stream;
    } catch (e, s) {
      talker.error('Error in downloadAssetSave: $e');
      talker.error('Stack trace: $s');
      rethrow;
    }
  }

  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) async {
    Directory directoryPath = await getSupportDir();

    final filePath = path.join(directoryPath.path, assetName);

    final file = File(filePath);
    if (await file.exists()) {
      talker.info('File already exists locally: ${file.path}');
      return Stream.value(100.0); // Return a stream indicating 100% completion
    }
    talker.warning("file to Download:$filePath");
    if (!await sessionManager.isAuthenticated()) {
      await sessionManager.signIn("yegobox@gmail.com");
      if (!await sessionManager.isAuthenticated()) {
        throw Exception('Failed to authenticate');
      }
    }
    final storagePath = amplify.StoragePath.fromString(
        'public/${subPath}-$branchId/$assetName');
    try {
      // Create a stream controller to manage the progress
      final progressController = StreamController<double>();
      // Start the download process
      final operation = amplify.Amplify.Storage.downloadFile(
        path: storagePath,
        localFile: amplify.AWSFile.fromPath(filePath),
        onProgress: (progress) {
          // Calculate the progress percentage
          final percentageCompleted =
              (progress.fractionCompleted * 100).toInt();
          // Add the progress to the stream
          progressController.sink.add(percentageCompleted.toDouble());
        },
      );
      // Listen for the download completion
      operation.result.then((_) {
        progressController.close();
        talker.info("Downloaded file at path ${storagePath}");
      }).catchError((error) async {
        progressController.addError(error);
        progressController.close();
      });
      return progressController.stream;
    } catch (e) {
      talker.error('Error downloading file: $e');
      rethrow;
    }
  }

  @override
  Future<void> reDownloadAsset() async {
    // get list of assets
    final assets = await repository.get<Assets>(
        query: brick.Query(where: [
      brick.Where('branchId').isExactly(ProxyService.box.getBranchId()!)
    ]));
    for (Assets asset in assets) {
      downloadAsset(
          branchId: asset.branchId!,
          assetName: asset.assetName!,
          subPath: "branch");
    }
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, String? productId}) async {
    final repository = Repository();
    final query = brick.Query(
        where: assetName != null
            ? [brick.Where('assetName').isExactly(assetName)]
            : productId != null
                ? [brick.Where('productId').isExactly(productId)]
                : throw Exception("no asset"));
    final result = await repository.get<Assets>(
        query: query,
        policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return result.firstOrNull;
  }

  @override
  Future<void> addAsset(
      {required String productId,
      required assetName,
      required int branchId,
      required int businessId}) async {
    final asset = await repository.get<Assets>(
        query: brick.Query(where: [
      brick.Where('productId').isExactly(productId),
      brick.Where('assetName').isExactly(assetName),
    ]));
    if (asset.firstOrNull == null) {
      await repository.upsert<Assets>(Assets(
        assetName: assetName,
        productId: productId,
        branchId: branchId,
        businessId: businessId,
      ));
    }
  }

  Repository get repository;
  Talker get talker;

  Future<Directory> getSupportDir() async {
    return Directory(await DatabasePath.getDatabaseDirectory());
  }

  @override
  Future<Assets> saveImageLocally({
    required File imageFile,
    required String productId,
    required int branchId,
    required int businessId,
  }) async {
    try {
      // Generate a unique filename using UUID
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

      // Get the support directory
      final Directory supportDir = await getSupportDir();

      // Create the local file path
      final String localPath = path.join(supportDir.path, fileName);

      // Copy the image file to the local storage
      await imageFile.copy(localPath);

      // Create an asset record with isUploaded = false
      final asset = Assets(
        assetName: fileName,
        productId: productId,
        branchId: branchId,
        businessId: businessId,
        isUploaded: false,
        localPath: localPath,
      );

      // Save the asset to the repository
      await repository.upsert<Assets>(asset);

      // Add to pending uploads queue
      _pendingUploads.add(asset.id);

      talker.info('Image saved locally: $localPath');
      return asset;
    } catch (e, s) {
      talker.error('Error saving image locally: $e');
      talker.error(s);
      rethrow;
    }
  }

  @override
  Future<List<String>> syncOfflineAssets() async {
    final List<String> successfullyUploaded = [];

    try {
      // Check for internet connectivity
      if (!await _hasInternetConnection()) {
        talker.warning('No internet connection, skipping asset sync');
        return successfullyUploaded;
      }

      // Authenticate if needed
      if (!await sessionManager.isAuthenticated()) {
        await sessionManager.signIn("yegobox@gmail.com");
        if (!await sessionManager.isAuthenticated()) {
          throw Exception('Failed to authenticate for asset sync');
        }
      }

      // Get all assets that haven't been uploaded yet
      final assets = await repository.get<Assets>(
          query:
              brick.Query(where: [brick.Where('isUploaded').isExactly(false)]));

      for (final asset in assets) {
        if (asset.localPath != null &&
            asset.assetName != null &&
            asset.branchId != null) {
          try {
            // Create the file reference
            final file = File(asset.localPath!);
            if (await file.exists()) {
              // Upload to S3
              final storagePath = amplify.StoragePath.fromString(
                  'public/branch-${asset.branchId}/${asset.assetName}');

              await amplify.Amplify.Storage
                  .uploadFile(
                    localFile: amplify.AWSFile.fromPath(asset.localPath!),
                    path: storagePath,
                  )
                  .result;

              // Update the asset record to mark as uploaded
              asset.isUploaded = true;
              await repository.upsert<Assets>(asset);

              // Remove from pending uploads
              _pendingUploads.remove(asset.id);

              successfullyUploaded.add(asset.id);
              talker.info('Successfully uploaded asset: ${asset.assetName}');
            } else {
              talker.warning('Local file not found: ${asset.localPath}');
            }
          } catch (e, s) {
            talker.error('Error uploading asset ${asset.assetName}: $e');
            talker.error(s);
            // Continue with next asset even if this one fails
          }
        }
      }

      return successfullyUploaded;
    } catch (e, s) {
      talker.error('Error syncing offline assets: $e');
      talker.error(s);
      return successfullyUploaded;
    }
  }

  @override
  Future<bool> hasOfflineAssets() async {
    try {
      final assets = await repository.get<Assets>(
          query:
              brick.Query(where: [brick.Where('isUploaded').isExactly(false)]));
      return assets.isNotEmpty;
    } catch (e) {
      talker.error('Error checking for offline assets: $e');
      return false;
    }
  }

  // Helper method to check for internet connectivity
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
