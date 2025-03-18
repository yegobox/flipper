import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_models/providers/upload_providers.dart';

class UploadViewModel extends ProductViewModel {
  final appService = loc.getIt<AppService>();
  File? selectedImage;
  final _container = ProviderContainer();

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
    return await uploadImage(id: productId, urlType: urlType);
  }

  Future<Product> uploadImage({
    required String id,
    required URLTYPE urlType,
  }) async {
    final talker = TalkerFlutter.init();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: false,
      withReadStream: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result == null) {
      safePrint('No file selected');
      throw Exception('No file selected');
    }

    int branchId = ProxyService.box.getBranchId()!;
    final platformFile = result.files.single;
    final uuid = randomNumber().toString();
    final uniqueFileName = '$uuid.${platformFile.extension!}';

    try {
      talker.warning('Authenticating user with AWS Cognito...');
      await ProxyService.strategy
          .syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");

      talker.warning('Saving picked file locally...');

      final filePath = 'public/branch-$branchId/$uniqueFileName';
      talker.warning('Uploading file to S3 at path: $filePath');

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(platformFile.path!),
        path: StoragePath.fromString(filePath),
        options: StorageUploadFileOptions(
          metadata: {
            "contentType": 'image/${platformFile.extension}'
          },
          pluginOptions: S3UploadFilePluginOptions(getProperties: true),
        ),
        onProgress: (progress) {
          talker.warning('Fraction completed: ${progress.fractionCompleted}');
          _container.read(uploadProgressProvider.notifier).state = progress.fractionCompleted;
        },
      ).result;

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
        saveAsset(assetName: uniqueFileName, productId: id);
      }
      await ProxyService.strategy.downloadAssetSave(assetName: uniqueFileName);
      await Future.delayed(Duration(seconds: 2));

      await ProxyService.strategy.updateProduct(
        productId: id,
        imageUrl: uniqueFileName,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
      );

      talker.warning('File uploaded and database updated successfully.');

      return (await ProxyService.strategy.getProduct(
          id: id,
          branchId: branchId,
          businessId: ProxyService.box.getBusinessId()!))!;
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
    final appDocDir = await getApplicationDocumentsDirectory();
    final localFile = File('${appDocDir.path}/$fileName');
    final stream = platformFile.readStream;

    if (stream != null) {
      final sink = localFile.openWrite();
      await stream.pipe(sink);
      await sink.close();
    }
  }

  FutureOr<void> saveAsset({required String productId, required assetName}) async {
    await ProxyService.strategy.addAsset(
      productId: productId,
      assetName: assetName,
      branchId: ProxyService.box.getBranchId()!,
      businessId: ProxyService.box.getBusinessId()!,
    );
  }
}
