import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'abstractions/upload.dart';
import 'proxy.dart';

class HttpUpload implements UploadT {
  var processed = <String>[];

  @override
  Future browsePictureFromGallery({
    required dynamic productId,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInternetAvailable() async {
    print('Not supported on this platform');
    return false;
  }

  @override
  Future takePicture({
    required dynamic id,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    print('Not supported on this platform');
  }

  @override
  Future upload({
    required List<String?> paths,
    required String id,
    required dynamic uploader,
    required URLTYPE urlType,
  }) {
    throw UnimplementedError();
  }
}

class MobileUpload implements UploadT {
  @override
  Future upload({
    required List<String?> paths,
    required String id,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    final String? token = ProxyService.box.getBearerToken();

    late String url;
    if (kDebugMode) {
      url = 'https://uat-apihub.yegobox.com/s3/upload';
    } else {
      url = 'https://178.62.206.133/s3/upload';
    }

    log(paths.length.toString(), name: 'paths');
    uploader.clearUploads();

    // TODO: Implement file upload logic using `uploader`
    // Example:
    // await uploader.enqueue(
    //   MultipartFormDataUpload(
    //     url: url,
    //     files: [FileItem(path: paths.first!, field: 'file')],
    //     method: UploadMethod.POST,
    //     tag: 'file',
    //     headers: {'Authorization': token!},
    //   ),
    // ).whenComplete(() => log('Done uploading', name: 'upload'));
  }

  @override
  Future<bool> isInternetAvailable() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future browsePictureFromGallery({
    required dynamic productId,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final String? filePath = result.files.single.path;
      if (filePath == null) return;

      log(filePath, name: "Path chosen");

      final File file = File(filePath);
      final tempDir = await getTemporaryDirectory();

      // TODO: Implement file compression logic if needed
      // Example:
      // final compressedPath = await compressImage(file, tempDir.path);
      // if (compressedPath != null) {
      //   upload(
      //     id: productId,
      //     paths: [compressedPath],
      //     urlType: urlType,
      //     uploader: uploader,
      //   );
      // }
    } catch (e) {
      log('Error picking image: $e', name: 'browsePictureFromGallery');
      // Refresh token or handle error
      String? phone = ProxyService.box.readString(key: 'userPhone');
    }
  }

  @override
  Future takePicture({
    required dynamic id,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final String? filePath = result.files.single.path;
      if (filePath == null) return;

      final File file = File(filePath);
      final tempDir = await getTemporaryDirectory();

      // TODO: Implement file compression logic if needed
      // Example:
      // final compressedPath = await compressImage(file, tempDir.path);
      // if (compressedPath != null) {
      //   upload(
      //     id: id,
      //     paths: [compressedPath],
      //     urlType: urlType,
      //     uploader: uploader,
      //   );
      // }
    } catch (e) {
      log('Error taking picture: $e', name: 'takePicture');
      // Refresh token or handle error
    }
  }

  // Example compression method (if needed)
  Future<String?> compressImage(File file, String tempDirPath) async {
    // Implement compression logic here
    // Example: Use a package like `flutter_image_compress`
    return file.path; // Return the compressed file path
  }
}
