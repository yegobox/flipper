import 'dart:io';

import 'abstractions/upload.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'proxy.dart';

class MobileUpload implements UploadT {
  final _picker = ImagePicker();

  @override
  Future handleImage({required File image, required String productId}) async {
    final String targetPath = (await getTemporaryDirectory()).path +
        '/' +
        DateTime.now().toIso8601String() +
        '.jpg';

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
      // final Document productUpdated = _databaseService.getById(id: product.id);

      // _state.setProduct(product: Product.fromMap(productUpdated.map));
      // final bool internetAvailable = await isInternetAvailable();
      // if (internetAvailable) {
      upload(
          fileName: fileName, productId: productId, storagePath: storagePath);
      // }
    });
  }

  @override
  Future upload({
    required String storagePath,
    required String fileName,
    required String productId,
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
      // final UploadResponse uploadResponse =
      //     uploadResponseFromJson(result.response);

      // final DatabaseService _databaseService = ProxyService.database;
      // final Document productDoc = _databaseService.getById(id: productId);

      // productDoc.properties['picture'] = uploadResponse.url;
      // _databaseService.update(document: productDoc);
      // final Document product = _databaseService.getById(id: productId);
      // _state.setProduct(product: Product.fromMap(product.map));
      // final Product product = Product.fromMap(productDoc.jsonProperties);
    }, onError: (ex, stacktrace) {
      print('error' + stacktrace.toString());
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

  // Future takePicture({BuildContext context}) async {
  // final File image = await ImagePicker.pickImage(source: ImageSource.camera);

  // await handleImage(image, context);
  // }

  // Future browsePictureFromGallery({BuildContext context}) async {
  //   final File image = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   await handleImage(image, context);
  // }
  @override
  Future browsePictureFromGallery({required String productId}) async {
    final PickedFile? image =
        await _picker.getImage(source: ImageSource.gallery);
    final File file = File(image!.path);
    await handleImage(image: file, productId: productId);
  }

  @override
  Future takePicture({required String productId}) async {
    final PickedFile? image =
        await _picker.getImage(source: ImageSource.camera);
    final File file = File(image!.path);

    await handleImage(image: file, productId: productId);
  }
}
