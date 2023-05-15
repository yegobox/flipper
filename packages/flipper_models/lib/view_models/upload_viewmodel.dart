import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/upload_response.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';

class UploadViewModel extends ProductViewModel {
  FlutterUploader uploader = FlutterUploader();

  final appService = loc.locator<AppService>();
  void browsePictureFromGallery(
      {required int id,
      required Function(String) callBack,
      required URLTYPE urlType}) {
    uploader.clearUploads();
    ProxyService.upload.browsePictureFromGallery(
        productId: id, urlType: urlType, uploader: uploader);
    uploader.result.listen((UploadTaskResponse result) async {
      log(result.status.toString(), name: "status");
      log(result.status!.description.toString(), name: "status description");
      if (result.status?.description == "Completed") {
        // uploader.clearUploads();
        if (urlType == URLTYPE.PRODUCT) {
          final UploadResponse uploadResponse =
              uploadResponseFromJson(result.response!);
          Product? product = await ProxyService.isarApi.getProduct(id: id);
          product!.imageUrl = uploadResponse.url;
          ProxyService.isarApi.update(data: product);
          Product? kProduct = await ProxyService.isarApi.getProduct(id: id);
          ProxyService.productService.setCurrentProduct(product: kProduct!);
          callBack(uploadResponse.url);
        }
        if (urlType == URLTYPE.BUSINESS) {
          final UploadResponse uploadResponse =
              uploadResponseFromJson(result.response!);
          Business? business =
              await ProxyService.isarApi.getBusinessById(id: id);
          business!.imageUrl = uploadResponse.url;
          ProxyService.isarApi.update(data: business);
          updateBusinessProfile(url: uploadResponse.url);
          callBack(uploadResponse.url);
        }
      }
    }, onError: (ex, stacktrace) {
      log(ex);
    });
  }

  Stream<double> uploadProgress() {
    return uploader.progress.map((progress) => progress.progress!.toDouble());
  }

  void takePicture(
      {required int productId,
      required Function callBack,
      required URLTYPE urlType}) {
    ProxyService.upload
        .takePicture(urlType: urlType, id: productId, uploader: uploader);
  }

  void updateBusinessProfile({required String url}) async {
    ITenant? tenant = await ProxyService.isarApi
        .getTenantBYUserId(userId: ProxyService.box.getUserId()!);
    // update business as well as for this time tenant is the same as busienss

    if (tenant != null) {
      tenant.imageUrl = url;
      ProxyService.isarApi.update(data: tenant);
    }

    /// if the user has enabled the flipper connecta update his profile image in contacts as well
    if (await appService.isSocialLoggedin()) {
      // we are logged in in social so safe to patch the image as well
      ProxyService.isarApi.updateContact(contact: {
        "phoneNumber": ProxyService.box.getUserPhone(),
        "avatar": url,
        "entity": "contacts",
        "businessId": ProxyService.box.getBusinessId()
      }, businessId: ProxyService.box.getBusinessId()!);
    }
  }
}
