import 'dart:io';

abstract class UploadT {
  Future takePicture({required int productId, required Function onComplete});
  Future browsePictureFromGallery(
      {required int productId, required Function onComplete});
  Future handleImage({
    required File image,
    required int productId,
    required Function(int) onUploadComplete,
  });
  Future<bool> isInternetAvailable();
  Future upload({
    required List<String?> paths,
    required int productId,
    required Function(int) onUploadComplete,
  });
}
