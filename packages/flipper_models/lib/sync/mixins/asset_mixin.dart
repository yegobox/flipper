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
}

mixin AssetMixin implements AssetInterface {
  final sessionManager = SessionManager();

  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) async {
    try {
      talker.info("About to call downloadAssetSave");
      int branchId = ProxyService.box.getBranchId()!;

      if (assetName != null) {
        return downloadAsset(
            branchId: branchId, assetName: assetName, subPath: subPath!);
      }

      List<Assets> assets = await repository.get(
          query: brick.Query(
              where: [brick.Where('branchId').isExactly(branchId)]));

      StreamController<double> progressController = StreamController<double>();

      for (Assets asset in assets) {
        if (asset.assetName != null) {
          // Get the download stream
          Stream<double> downloadStream = await downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!);

          // Listen to the download stream and add its events to the main controller
          downloadStream.listen((progress) {
            print('Download progress for ${asset.assetName}: $progress');
            progressController.add(progress);
          }, onError: (error) {
            // Handle errors in the download stream
            talker.error(
                'Error in download stream for ${asset.assetName}: $error');
            progressController.addError(error);
          });
        } else {
          talker.warning('Asset name is null for asset: ${asset.id}');
        }
      }

      // Close the stream controller when all downloads are finished
      Future.wait(assets.map((asset) => asset.assetName != null
          ? downloadAsset(
              branchId: branchId,
              assetName: asset.assetName!,
              subPath: subPath!)
          : Future.value(Stream.empty()))).then((_) {
        progressController.close();
      }).catchError((error) {
        talker.error('Error in downloading assets: $error');
        progressController.close();
      });

      return progressController.stream;
    } catch (e, s) {
      talker.error('Error in downloading assets: $e');
      talker.error('Error in downloading assets: $s');
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
      talker.warning('File Exist: ${file.path}');
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
        talker.warning("Downloaded file at path ${storagePath}");
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
}
