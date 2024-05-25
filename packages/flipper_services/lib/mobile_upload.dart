import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'abstractions/upload.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
// import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'proxy.dart';

class HttpUpload implements UploadT {
  var processed = <String>[];

  @override
  Future browsePictureFromGallery({
    required dynamic productId,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    UnimplementedError();
  }

  @override
  Future<bool> isInternetAvailable() async {
    print('no supported on this platform');
    return false;
  }

  @override
  Future takePicture({
    required dynamic id,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    print('no supported on this platform');
  }

  @override
  Future upload({
    required List<String?> paths,
    required String id,
    required dynamic uploader,
    required URLTYPE urlType,
  }) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}

// end of http upload
class MobileUpload implements UploadT {
  final _picker = ImagePicker();

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
    } else if (!kDebugMode) {
      url = 'https://apihub.yegobox.com/s3/upload';
    }
    log(paths.length.toString(), name: 'paths');
    uploader.clearUploads();
    // await uploader
    //     .enqueue(MultipartFormDataUpload(
    //       url: url,
    //       files: [FileItem(path: paths.first!, field: 'file')],
    //       method: UploadMethod.POST,
    //       tag: 'file',
    //       headers: {'Authorization': token!},
    //     ))
    //     .whenComplete(() => log('done uploading', name: 'upload'));
  }

  @override
  Future<bool> isInternetAvailable() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Future browsePictureFromGallery({
    required dynamic productId,
    required URLTYPE urlType,
    required dynamic uploader,
  }) async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      log(image.path, name: "Path choosen");
      final File file = File(image.path);
      final tempDir = await getTemporaryDirectory();
      CompressObject compressObject = CompressObject(
        imageFile: file, //image
        path: tempDir.path, //compress to path
        quality: 85,
        step: 9,
        mode: CompressMode.LARGE2SMALL, //default AUTO
      );
      Luban.compressImage(compressObject).then((_path) {
        upload(
          id: productId,
          paths: [_path!],
          urlType: urlType,
          uploader: uploader,
        );
      }).onError((error, stackTrace) {
        log(error.toString(), name: "error compressing image");
      });
    } catch (e) {
      //refresh to token
      String? phone = ProxyService.box.readString(key: 'userPhone');
      await ProxyService.realm
          .login(userPhone: phone!, skipDefaultAppSetup: false);
    }
  }

  @override
  Future takePicture(
      {required dynamic id,
      required URLTYPE urlType,
      required dynamic uploader}) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      final File file = File(image.path);
      final tempDir = await getTemporaryDirectory();
      CompressObject compressObject = CompressObject(
        imageFile: file, //image
        path: tempDir.path, //compress to path
        quality: 85,
        step: 9,
        mode: CompressMode.LARGE2SMALL, //default AUTO
      );
      Luban.compressImage(compressObject).then((_path) {
        upload(
          id: id,
          paths: [_path!],
          urlType: urlType,
          uploader: uploader,
        );
      }).onError((error, stackTrace) {
        log(error.toString(), name: "error compressing image");
      });
    } catch (e) {
      //refresh to token
      String? phone = ProxyService.box.readString(key: 'userPhone');
      await ProxyService.realm
          .login(userPhone: phone!, skipDefaultAppSetup: false);
    }
  }
}
