import 'dart:io';

enum URLTYPE { PRODUCT, USER, BUSINESS, PROFILE }

abstract class UploadT {
  Future takePicture(
      {required int id,
      required URLTYPE urlType,
      required Function onComplete});
  Future browsePictureFromGallery(
      {required int productId,
      required URLTYPE urlType,
      required Function onComplete});
  Future handleImage({
    required File image,
    required int id,
    required URLTYPE urlType,
    required Function(String) onUploadComplete,
  });
  Future<bool> isInternetAvailable();
  Future upload({
    required List<String?> paths,
    required URLTYPE urlType,
    required int id,
    required Function(String) onUploadComplete,
  });
  Stream<double> uploadProgress();
}
