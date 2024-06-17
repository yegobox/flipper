import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/helperModels/random.dart';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UploadViewModel extends ProductViewModel {
  final appService = loc.getIt<AppService>();
  File? selectedImage;

  void browsePictureFromGallery(
      {required dynamic id,
      required Function(Product) callBack,
      required URLTYPE urlType}) async {
    // final pickedFile = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   withData: false,
    //   // Ensure to get file stream for better performance
    //   withReadStream: true,
    //   allowedExtensions: ['jpg', 'png'],
    // );
    // if (pickedFile != null) {
    // selectedImage = File(pickedFile.files.single.path!);
    await uploadImage(id: id, urlType: urlType, callBack: callBack);
    // }
  }

  void takePicture(
      {required int productId,
      required Function(Product) callBack,
      required URLTYPE urlType}) async {
    // final pickedFile = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   withData: false,
    //   // Ensure to get file stream for better performance
    //   withReadStream: true,
    //   allowedExtensions: ['jpg', 'png'],
    // );
    // if (pickedFile != null) {
    //   selectedImage = File(pickedFile.files.single.path!);
    await uploadImage(id: productId, urlType: urlType, callBack: callBack);
    // }
  }

  Future<void> uploadImage({
    required int id,
    required URLTYPE urlType,
    required Function(Product) callBack,
  }) async {
    final talker = TalkerFlutter.init();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: false,
      withReadStream: true,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result == null) {
      safePrint('No file selected');
      return;
    }

    int branchId = ProxyService.box.getBranchId()!;
    final platformFile = result.files.single;
    // final mimeType =
    //     lookupMimeType(platformFile.name) ?? 'application/octet-stream';

    // Generate a unique file name
    final uuid = randomNumber().toString();
    final uniqueFileName = '$uuid.${platformFile.extension!}';

    try {
      // Log step: Ensure user is authenticated with AWS Cognito
      talker.warning('Authenticating user with AWS Cognito...');
      await ProxyService.realm
          .syncUserWithAwsIncognito(identifier: "yegobox@gmail.com");

      // Log step: Save the picked file locally
      talker.warning('Saving picked file locally...');

      // Log step: Preparing to upload to S3
      final filePath = 'public/branch-$branchId/$uniqueFileName';
      talker.warning('Uploading file to S3 at path: $filePath');

      await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromStream(
          platformFile.readStream!,
          size: platformFile.size,
        ),
        // options: StorageUploadFileOptions(
        //   metadata: {'contentType': mimeType},
        // ),
        path: StoragePath.fromString(filePath),
        // path: StoragePath.fromString('public/${platformFile.name}'),
        onProgress: (progress) {
          talker.warning('Fraction completed: ${progress.fractionCompleted}');
        },
      ).result;

      // Log step: Save asset and update database
      talker.warning('Saving asset and updating database...');
      saveAsset(assetName: uniqueFileName, productId: id);
      Product? product = ProxyService.realm.getProduct(id: id);
      ProxyService.realm.realm!.write(() {
        if (product != null) {
          product.imageUrl = uniqueFileName;
        }
      });

      await ProxyService.realm.downloadAssetSave(assetName: uniqueFileName);
      // Log success
      talker.warning('File uploaded and database updated successfully.');
      Product? _product = ProxyService.realm.getProduct(id: id);
      callBack(_product!);
    } on StorageException catch (e) {
      talker.warning('StorageException: ${e.message}');
    } catch (e) {
      talker.warning('General Exception: $e');
    }
  }

  // Helper function to save the picked file locally
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

  void saveAsset({required int productId, required assetName}) async {
    ProxyService.realm.realm!.write(() {
      ProxyService.realm.realm!.add<Assets>(
        Assets(ObjectId(),
            assetName: assetName,
            productId: productId,
            id: randomNumber(),
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!),
      );
    });
  }
}
