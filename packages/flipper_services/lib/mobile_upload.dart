import 'dart:io';

import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_services/upload_response.dart';

import 'abstractions/upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flipper_models/models/models.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'proxy.dart';

class HttpUpload implements UploadT {
  final _picker = ImagePicker();
  final log = getLogger('HttpUpload');
  @override
  Future browsePictureFromGallery(
      {required int productId, required Function onComplete}) async {
    UnimplementedError();
  }

  @override
  Future handleImage({
    required File image,
    required int productId,
    required Function(int) onUploadComplete,
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
      // final Document productUpdated = _databaseService.getById(id: product.id);
      // _state.setProduct(product: ProductSync.fromMap(productUpdated.map));
      // final bool internetAvailable = await isInternetAvailable();
      log.i('we got here');
      log.i(fileName);
      log.i(storagePath);
      upload(
        paths: [storagePath],
        productId: productId,
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
      {required int productId, required Function onComplete}) async {
    print('no supported on this platform');
  }

  @override
  Future upload({
    required List<String?> paths,
    required int productId,
    required Function(int) onUploadComplete,
  }) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}

// end of http upload
class MobileUpload implements UploadT {
  final _picker = ImagePicker();
  final log = getLogger('MobileUpload');
  @override
  Future handleImage(
      {required File image,
      required int productId,
      required Function(int) onUploadComplete}) async {
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
        productId: productId,
        paths: [_path!],
        onUploadComplete: onUploadComplete,
      );
    }).onError((error, stackTrace) {
      log.i(error);
    });
  }

  @override
  Future upload({
    required List<String?> paths,
    required int productId,
    required Function(int) onUploadComplete,
  }) async {
    final FlutterUploader uploader = FlutterUploader();
    final String token = ProxyService.box.read(key: 'UToken');
    await uploader.enqueue(MultipartFormDataUpload(
      url: 'https://flipper.yegobox.com/upload',
      files: paths.map((e) => FileItem(path: e!, field: 'picture')).toList(),
      method: UploadMethod.POST,
      tag: 'Upload',
      headers: {'Authorization': 'Bearer  ' + token},
    ));

    uploader.progress.listen((UploadTaskProgress progress) {
      // print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      if (result.response != 'There are no items to upload' ||
          result.response != null) {
        try {
          final UploadResponse uploadResponse =
              uploadResponseFromJson(result.response!);
          ProductSync? product =
              await ProxyService.api.getProduct(id: productId);
          Map map = product!.toJson();
          map['picture'] = uploadResponse.url;
          map['imageUrl'] = uploadResponse.url;
          map['hasPicture'] = true;
          log.i(map);
          log.i(productId);
          ProxyService.api.update(data: map, endPoint: 'product');
          ProductSync? kProduct =
              await ProxyService.api.getProduct(id: productId);
          ProxyService.productService
              .setCurrentProduct(product: kProduct!); //refresh data!
          onUploadComplete(result.statusCode!);
        } catch (e) {
          onUploadComplete(500);
        }
      }
    }, onError: (ex, stacktrace) {
      log.i('error' + stacktrace.toString());
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
      {required int productId, required Function onComplete}) async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final File file = File(image.path);
      await handleImage(
        image: file,
        productId: productId,
        onUploadComplete: (int statusCode) {
          if (statusCode == 200) {
            onComplete(statusCode);
          } else {
            onComplete(Exception('error'));
          }
        },
      );
    } catch (e) {
      //refresh to token
      String? phone = ProxyService.box.read(key: 'userPhone');
      await ProxyService.api.login(userPhone: phone!);
      onComplete(Exception(e.toString()));
    }
  }

  @override
  Future takePicture(
      {required int productId, required Function onComplete}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    final File file = File(image.path);

    await handleImage(
      image: file,
      productId: productId,
      onUploadComplete: (int statusCode) async {
        if (statusCode == 200) {
          onComplete(statusCode);
        } else {
          /// refresh to token
          String? phone = ProxyService.box.read(key: 'userPhone');
          log.d(phone);
          await ProxyService.api.login(userPhone: phone!);

          // onComplete(Exception('error'));
          onComplete(statusCode);
        }
      },
    );
  }
}
