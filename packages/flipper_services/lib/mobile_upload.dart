import 'dart:io';

import 'package:flipper/routes.logger.dart';

import 'abstractions/upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flipper_models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'proxy.dart';
import 'dart:convert';

UploadResponse uploadResponseFromJson(String str) =>
    UploadResponse.fromJson(json.decode(str));

String uploadResponseToJson(UploadResponse data) => json.encode(data.toJson());

class UploadResponse {
  UploadResponse({
    required this.url,
  });

  String url;

  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class HttpUpload implements UploadT {
  final _picker = ImagePicker();
  final log = getLogger('HttpUpload');
  @override
  Future browsePictureFromGallery({required int productId}) async {
    PickedFile? image = await _picker.getImage(source: ImageSource.gallery);

    final File file = File(image!.path);
    await handleImage(image: file, productId: productId);
  }

  @override
  Future handleImage({required File image, required int productId}) async {
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
      // _state.setProduct(product: Product.fromMap(productUpdated.map));
      // final bool internetAvailable = await isInternetAvailable();
      log.i('we got here');
      log.i(fileName);
      log.i(storagePath);
      upload(
        fileName: fileName,
        productId: productId,
        storagePath: storagePath,
      );
    });
  }

  @override
  Future<bool> isInternetAvailable() async {
    print('no supported on this platform');
    return false;
  }

  @override
  Future takePicture({required int productId}) async {
    print('no supported on this platform');
  }

  @override
  Future upload(
      {required String storagePath,
      required String fileName,
      required int productId}) async {
    print('no supported on this platform');
  }
}

// end of http upload
class MobileUpload implements UploadT {
  final _picker = ImagePicker();
  final log = getLogger('MobileUpload');
  @override
  Future handleImage({required File image, required int productId}) async {
    final tempDir = await getTemporaryDirectory();
    CompressObject compressObject = CompressObject(
      imageFile: image, //image
      path: tempDir.path, //compress to path
      quality: 85, //first compress quality, default 80
      //compress quality step, The bigger the fast, Smaller is more accurate, default 6
      step: 9,
      mode: CompressMode.LARGE2SMALL, //default AUTO
    );
    Luban.compressImage(compressObject).then((_path) {
      final String fileName = _path!.split('/').removeLast();
      final String storagePath = _path.replaceAll('/' + fileName, '');

      upload(
        fileName: fileName,
        productId: productId,
        storagePath: storagePath,
      );
    });
  }

  @override
  Future upload({
    required String storagePath,
    required String fileName,
    required int productId,
  }) async {
    final FlutterUploader uploader = FlutterUploader();
    var fileItem = FileItem(path: storagePath, field: 'picture');
    final String token = ProxyService.box.read(key: 'UToken');
    await uploader.enqueue(MultipartFormDataUpload(
      url: 'https://flipper.yegobox.com/upload',
      files: [fileItem],
      method: UploadMethod.POST,
      tag: 'Upload',
      headers: {'Authorization': 'Bearer  ' + token},
    ));

    uploader.progress.listen((UploadTaskProgress progress) {
      // print('uploadProgress:' + progress.toString());
    });
    uploader.result.listen((UploadTaskResponse result) async {
      final UploadResponse uploadResponse =
          uploadResponseFromJson(result.response!);

      Product? product = await ProxyService.api.getProduct(id: productId);
      Map map = product!.toJson();
      map['picture'] = uploadResponse.url;
      ProxyService.api.update(data: map, endPoint: 'product');
      ProxyService.api.products(); //refresh data!
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
  Future browsePictureFromGallery({required int productId}) async {
    PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) return;
    final File file = File(image.path);
    await handleImage(image: file, productId: productId);
  }

  @override
  Future takePicture({required int productId}) async {
    // final String token = ProxyService.box.read(key: 'UToken');
    try {
      final PickedFile? image =
          await _picker.getImage(source: ImageSource.camera);
      if (image == null) return;
      final File file = File(image.path);

      await handleImage(image: file, productId: productId);
    } catch (e) {
      log.i(e);
      // ProxyService.crash.log(e);
    }
  }
}
