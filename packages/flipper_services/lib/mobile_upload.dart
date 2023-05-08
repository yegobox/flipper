import 'dart:developer';
import 'dart:io';

import 'package:flipper_services/upload_response.dart';
import 'package:flutter/foundation.dart';

import 'abstractions/upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flipper_models/isar_models.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'proxy.dart';

class HttpUpload implements UploadT {
  @override
  Future browsePictureFromGallery(
      {required int productId,
      required URLTYPE urlType,
      required Function onComplete}) async {
    UnimplementedError();
  }

  @override
  Future handleImage({
    required File image,
    required int id,
    required URLTYPE urlType,
    required Function(String) onUploadComplete,
  }) async {
    final tempDir = await getTemporaryDirectory();
    CompressObject compressObject = CompressObject(
      imageFile: image, //image
      path: tempDir.path, //compress to path
      //first compress quality, default 80
      //compress quality step, The bigger the fast, Smaller is more accurate, default 6
      quality: 85,
      step: 9,
      mode: CompressMode.LARGE2SMALL, //default AUTO
    );
    Luban.compressImage(compressObject).then((_path) {
      final String fileName = _path!.split('/').removeLast();
      final String storagePath = _path.replaceAll('/' + fileName, '');

      upload(
        paths: [storagePath],
        id: id,
        urlType: urlType,
        onUploadComplete: onUploadComplete,
      );
    });
  }

  @override
  Future<bool> isInternetAvailable() async {
    print('no supported on this platform');
    return false;
  }

  @override
  Future takePicture(
      {required int id,
      required URLTYPE urlType,
      required Function onComplete}) async {
    print('no supported on this platform');
  }

  @override
  Future upload({
    required List<String?> paths,
    required int id,
    required URLTYPE urlType,
    required Function(String) onUploadComplete,
  }) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}

// end of http upload
class MobileUpload implements UploadT {
  final _picker = ImagePicker();
  @override
  Future handleImage(
      {required File image,
      required int id,
      required URLTYPE urlType,
      required Function(String) onUploadComplete}) async {
    final tempDir = await getTemporaryDirectory();
    CompressObject compressObject = CompressObject(
      imageFile: image, //image
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
        onUploadComplete: onUploadComplete,
      );
    }).onError((error, stackTrace) {
      log(error.toString(), name: "error compressing image");
    });
  }

  @override
  Future upload({
    required List<String?> paths,
    required int id,
    required URLTYPE urlType,
    required Function(String) onUploadComplete,
  }) async {
    final FlutterUploader uploader = FlutterUploader();
    final String? token = ProxyService.box.getBearerToken();

    late String url;
    if (kDebugMode) {
      url = 'https://uat-apihub.yegobox.com/s3/upload';
    } else if (!kDebugMode) {
      url = 'https://apihub.yegobox.com/s3/upload';
    }
    await uploader.enqueue(MultipartFormDataUpload(
      url: url,
      files: paths.map((e) => FileItem(path: e!, field: 'file')).toList(),
      method: UploadMethod.POST,
      tag: 'file',
      headers: {'Authorization': token!},
    ));

    uploader.progress.listen((UploadTaskProgress progress) {
      // print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      if (result.response != 'There are no items to upload' ||
          result.response != null) {
        try {
          if (urlType == URLTYPE.PRODUCT) {
            final UploadResponse uploadResponse =
                uploadResponseFromJson(result.response!);
            Product? product = await ProxyService.isarApi.getProduct(id: id);
            product!.imageUrl = uploadResponse.url;
            ProxyService.isarApi.update(data: product);
            Product? kProduct = await ProxyService.isarApi.getProduct(id: id);
            ProxyService.productService.setCurrentProduct(product: kProduct!);
            onUploadComplete(uploadResponse.url);
          }
          if (urlType == URLTYPE.BUSINESS) {
            final UploadResponse uploadResponse =
                uploadResponseFromJson(result.response!);
            Business? business =
                await ProxyService.isarApi.getBusinessById(id: id);
            business!.imageUrl = uploadResponse.url;
            ProxyService.isarApi.update(data: business);
            onUploadComplete(uploadResponse.url);
          }
        } catch (e) {
          onUploadComplete("500");
        }
      }
    }, onError: (ex, stacktrace) {
      log(ex);
    });
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
  Future browsePictureFromGallery(
      {required int productId,
      required URLTYPE urlType,
      required Function onComplete}) async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final File file = File(image.path);
      await handleImage(
        image: file,
        id: productId,
        urlType: urlType,
        onUploadComplete: (String statusCode) {
          onComplete(statusCode);
        },
      );
    } catch (e) {
      //refresh to token
      String? phone = ProxyService.box.read(key: 'userPhone');
      await ProxyService.isarApi
          .login(userPhone: phone!, skipDefaultAppSetup: false);
      onComplete(Exception(e.toString()));
    }
  }

  @override
  Future takePicture(
      {required int id,
      required URLTYPE urlType,
      required Function onComplete}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    final File file = File(image.path);

    await handleImage(
      image: file,
      id: id,
      urlType: urlType,
      onUploadComplete: (String statusCode) async {
        if (statusCode == "200") {
          onComplete(statusCode);
        } else {
          onComplete(statusCode);
        }
      },
    );
  }
}
