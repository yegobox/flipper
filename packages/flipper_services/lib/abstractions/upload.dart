import 'package:flutter_uploader/flutter_uploader.dart';

enum URLTYPE { PRODUCT, USER, BUSINESS, PROFILE }

abstract class UploadT {
  Future takePicture(
      {required dynamic id,
      required URLTYPE urlType,
      required FlutterUploader uploader});
  Future browsePictureFromGallery(
      {required dynamic productId,
      required URLTYPE urlType,
      required FlutterUploader uploader});
  Future<bool> isInternetAvailable();
  Future upload({
    required List<String?> paths,
    required URLTYPE urlType,
    required FlutterUploader uploader,
    required String id,
  });
}
