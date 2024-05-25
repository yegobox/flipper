// import 'dart:developer';

import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
// import 'package:flipper_services/upload_response.dart';
// import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/app_service.dart';

class UploadViewModel extends ProductViewModel {
  // FlutterUploader uploader = FlutterUploader();

  final appService = loc.getIt<AppService>();
  void browsePictureFromGallery(
      {required dynamic id,
      required Function(String) callBack,
      required URLTYPE urlType}) {
    // uploader.clearUploads();
    ProxyService.upload.browsePictureFromGallery(
        productId: id, urlType: urlType, uploader: 'uploader');
    handleUploaderResult(urlType, id, callBack);
  }

  void handleUploaderResult(URLTYPE urlType, id, Function(String) callBack) {
    // uploader.result.listen((UploadTaskResponse result) async {
    //   ProxyService.realm.realm!.writeAsync(() async {
    //     if (result.status?.description == "Completed") {
    //       if (urlType == URLTYPE.PRODUCT) {
    //         final UploadResponse uploadResponse =
    //             uploadResponseFromJson(result.response!);
    //         Product? product = await ProxyService.realm.getProduct(id: id);
    //         product!.imageUrl = uploadResponse.url;
    //         Product? kProduct = await ProxyService.realm.getProduct(id: id);
    //         setCurrentProduct(currentProduct: kProduct!);
    //         callBack(uploadResponse.url);
    //       }
    //       if (urlType == URLTYPE.BUSINESS) {
    //         final UploadResponse uploadResponse =
    //             uploadResponseFromJson(result.response!);
    //         Business business = await ProxyService.realm
    //             .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    //         business.imageUrl = uploadResponse.url;
    //         updateBusinessProfile(url: uploadResponse.url);
    //         callBack(uploadResponse.url);
    //       }
    //     }
    //   });
    // }, onError: (ex, stacktrace) {
    //   log(ex);
    // });
  }

  // Stream<double> uploadProgress() {
  //   // return uploader.progress.map((progress) => progress.progress!.toDouble());
  // }

  void takePicture(
      {required int productId,
      required Function(String) callBack,
      required URLTYPE urlType}) {
    //uploader.clearUploads();
    ProxyService.upload
        .takePicture(urlType: urlType, id: productId, uploader: 'uploader');
    handleUploaderResult(urlType, productId, callBack);
  }

  void updateBusinessProfile({required String url}) async {
    Tenant? tenant = await ProxyService.realm
        .getTenantBYUserId(userId: ProxyService.box.getUserId()!);
    // update business as well as for this time tenant is the same as busienss

    if (tenant != null) {
      ProxyService.realm.realm!.write(() {
        tenant.imageUrl = url;
      });
    }

    /// if the user has enabled the flipper connecta update his profile image in contacts as well
    if (await appService.isSocialLoggedin()) {
      // we are logged in in social so safe to patch the image as well
      ProxyService.realm.updateContact(contact: {
        "phoneNumber": ProxyService.box.getUserPhone(),
        "avatar": url,
        "entity": "contacts",
        "businessId": ProxyService.box.getBusinessId()
      }, businessId: ProxyService.box.getBusinessId()!);
    }
  }
}
