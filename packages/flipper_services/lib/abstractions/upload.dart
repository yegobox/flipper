import 'dart:io';

abstract class UploadT {
  Future takePicture({required String productId});
  Future browsePictureFromGallery({required String productId});
  Future handleImage({required File image, required String productId});
  Future<bool> isInternetAvailable();
  Future upload(
      {required String storagePath,
      required String fileName,
      required String productId});
}
