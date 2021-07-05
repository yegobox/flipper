import 'dart:io';

abstract class UploadT {
  Future takePicture({required int productId});
  Future browsePictureFromGallery({required int productId});
  Future handleImage({required File image, required int productId});
  Future<bool> isInternetAvailable();
  Future upload({required List<String?> paths, required int productId});
}
