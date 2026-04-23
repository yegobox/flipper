import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_models/providers/upload_providers.dart';

class UploadViewModel extends ProductViewModel {
  final appService = loc.getIt<AppService>();
  File? selectedImage;
  WidgetRef? ref;
  final ImagePicker _imagePicker = ImagePicker();

  void setRef(WidgetRef ref) {
    this.ref = ref;
  }

  Future<Product> browsePictureFromGallery({
    required String id,
    required URLTYPE urlType,
  }) async {
    return await uploadImage(id: id, urlType: urlType);
  }

  Future<Product> takePicture({
    required String productId,
    required URLTYPE urlType,
  }) async {
    return await uploadImage(
      id: productId,
      urlType: urlType,
      source: ImageSource.camera,
    );
  }

  Future<Product> uploadImage({
    required String id,
    required URLTYPE urlType,
    ImageSource? source,
  }) async {
    await uploadAssetName(
      id: id,
      urlType: urlType,
      source: source,
      updateProductImage: true,
      persistAssetRecord: true,
    );
    final branchId = ProxyService.box.getBranchId()!;
    return (await ProxyService.strategy.getProduct(
          id: id,
          branchId: branchId,
          businessId: ProxyService.box.getBusinessId()!,
        ))!;
  }

  /// Uploads an image and returns the asset filename.
  ///
  /// When [updateProductImage] is false, this will still:
  /// - upload to S3
  /// - persist an `Assets` row linked to [id] (as productId)
  /// But will NOT update the product's `imageUrl`.
  Future<String> uploadAssetName({
    required String id,
    required URLTYPE urlType,
    ImageSource? source,
    bool updateProductImage = true,
    bool persistAssetRecord = true,
  }) async {
    final talker = TalkerFlutter.init();

    String branchId = ProxyService.box.getBranchId()!;
    final uuid = randomNumber().toString();

    String pickedPath = '';
    String pickedExtension = '';

    // On mobile we can allow camera/gallery via ImagePicker, while desktop keeps FilePicker.
    if (!kIsWeb &&
        source != null &&
        (Platform.isAndroid || Platform.isIOS)) {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) {
        safePrint('No image selected');
        throw Exception('No file selected');
      }
      pickedPath = image.path;
      pickedExtension =
          p.extension(image.path).replaceFirst('.', '').toLowerCase().trim();
    } else {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: false,
        withReadStream: false,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (result == null) {
        safePrint('No file selected');
        throw Exception('No file selected');
      }
      final platformFile = result.files.single;
      pickedPath = platformFile.path ?? '';
      final ext =
          (platformFile.extension ?? p.extension(platformFile.name))
              .replaceFirst('.', '')
              .toLowerCase()
              .trim();
      pickedExtension = ext;
    }

    if (pickedPath.isEmpty) {
      safePrint('No file selected');
      throw Exception('No file selected');
    }
    final effectiveExt = pickedExtension.isEmpty ? 'jpg' : pickedExtension;
    final uniqueFileName = '$uuid.$effectiveExt';

    try {
      talker.warning('Authenticating user with AWS Cognito...');
      await ProxyService.strategy
          .syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");

      talker.warning('Saving picked file locally...');
      await savePickedFilePathLocally(pickedPath, uniqueFileName);

      final filePath = 'public/branch-$branchId/$uniqueFileName';
      talker.warning('Uploading file to S3 at path: $filePath');

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(pickedPath),
        path: StoragePath.fromString(filePath),
        options: StorageUploadFileOptions(
          metadata: {"contentType": 'image/$effectiveExt'},
          pluginOptions: S3UploadFilePluginOptions(getProperties: true),
        ),
        onProgress: (progress) {
          talker.warning('Fraction completed: ${progress.fractionCompleted}');
          if (ref != null) {
            ref!.read(uploadProgressProvider.notifier).setProgress(
                  progress.fractionCompleted,
                );
          }
        },
      ).result;

      if (persistAssetRecord) {
        talker.warning('Saving asset and updating database...');

        Product? product = await ProxyService.strategy.getProduct(
            id: id,
            branchId: branchId,
            businessId: ProxyService.box.getBusinessId()!);
        try {
          Assets? asset =
              await ProxyService.strategy.getAsset(productId: product!.id);

          await ProxyService.strategy
              .updateAsset(assetId: asset!.id, assetName: uniqueFileName);
        } catch (e) {
          await saveAsset(assetName: uniqueFileName, productId: id);
        }
      }

      // Save the original file to local storage
      final appSupportDir = await getApplicationSupportDirectory();
      final localFilePath = '${appSupportDir.path}/$uniqueFileName';
      await File(pickedPath).copy(localFilePath);

      if (updateProductImage) {
        await ProxyService.strategy.updateProduct(
          productId: id,
          imageUrl: uniqueFileName,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
        );
      }

      talker.warning('File uploaded and database updated successfully.');
      return uniqueFileName;
    } on StorageException catch (e) {
      talker.warning('StorageException: ${e.message}');
      rethrow;
    } catch (e, s) {
      talker.warning('General Exception: $e');
      talker.error(s);
      rethrow;
    }
  }

  /// Upload an already-picked local image path and return the generated filename.
  ///
  /// Use this when the UI needs to show an immediate preview from [pickedPath]
  /// while the upload runs.
  Future<String> uploadPickedImagePath({
    required String pickedPath,
    required String id,
    required URLTYPE urlType,
    bool updateProductImage = true,
    bool persistAssetRecord = true,
  }) async {
    final talker = TalkerFlutter.init();
    final branchId = ProxyService.box.getBranchId()!;
    final uuid = randomNumber().toString();

    final pickedExtension =
        p.extension(pickedPath).replaceFirst('.', '').toLowerCase().trim();
    final effectiveExt = pickedExtension.isEmpty ? 'jpg' : pickedExtension;
    final uniqueFileName = '$uuid.$effectiveExt';

    try {
      talker.warning('Authenticating user with AWS Cognito...');
      await ProxyService.strategy
          .syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");

      talker.warning('Saving picked file locally...');
      await savePickedFilePathLocally(pickedPath, uniqueFileName);

      final filePath = 'public/branch-$branchId/$uniqueFileName';
      talker.warning('Uploading file to S3 at path: $filePath');

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(pickedPath),
        path: StoragePath.fromString(filePath),
        options: StorageUploadFileOptions(
          metadata: {"contentType": 'image/$effectiveExt'},
          pluginOptions: S3UploadFilePluginOptions(getProperties: true),
        ),
        onProgress: (progress) {
          if (ref != null) {
            ref!.read(uploadProgressProvider.notifier).setProgress(
                  progress.fractionCompleted,
                );
          }
        },
      ).result;

      if (persistAssetRecord) {
        Product? product = await ProxyService.strategy.getProduct(
          id: id,
          branchId: branchId,
          businessId: ProxyService.box.getBusinessId()!,
        );
        try {
          Assets? asset =
              await ProxyService.strategy.getAsset(productId: product!.id);
          await ProxyService.strategy
              .updateAsset(assetId: asset!.id, assetName: uniqueFileName);
        } catch (_) {
          await saveAsset(assetName: uniqueFileName, productId: id);
        }
      }

      final appSupportDir = await getApplicationSupportDirectory();
      final localFilePath = '${appSupportDir.path}/$uniqueFileName';
      await File(pickedPath).copy(localFilePath);

      if (updateProductImage) {
        await ProxyService.strategy.updateProduct(
          productId: id,
          imageUrl: uniqueFileName,
          branchId: ProxyService.box.getBranchId()!,
          businessId: ProxyService.box.getBusinessId()!,
        );
      }

      return uniqueFileName;
    } on StorageException catch (e) {
      talker.warning('StorageException: ${e.message}');
      rethrow;
    } catch (e, s) {
      talker.warning('General Exception: $e');
      talker.error(s);
      rethrow;
    }
  }

  Future<void> savePickedFileLocally(
      PlatformFile platformFile, String fileName) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final localFile = File('${appSupportDir.path}/$fileName');

    if (platformFile.path != null) {
      await File(platformFile.path!).copy(localFile.path);
    } else if (platformFile.bytes != null) {
      await localFile.writeAsBytes(platformFile.bytes!);
    } else if (platformFile.readStream != null) {
      final sink = localFile.openWrite();
      await platformFile.readStream!.pipe(sink);
      await sink.close();
    }
  }

  Future<void> savePickedFilePathLocally(String path, String fileName) async {
    final appSupportDir = await getApplicationSupportDirectory();
    final localFile = File('${appSupportDir.path}/$fileName');
    await File(path).copy(localFile.path);
  }

  FutureOr<void> saveAsset(
      {required String productId, required assetName}) async {
    await ProxyService.strategy.addAsset(
      productId: productId,
      assetName: assetName,
      branchId: ProxyService.box.getBranchId()!,
      businessId: ProxyService.box.getBusinessId()!,
    );
  }
}
