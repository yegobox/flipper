import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_routing/ui/common/ui_helpers.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'logout_model.dart';

const double _graphicSize = 60;

class LogOut extends StackedView<LogoutModel> with CoreMiscellaneous {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const LogOut({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LogoutModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible:
                  request.data != null, // Hide the Row if request.data is null
              child: Row(
                children: [
                  Image.asset(
                    request.data != null
                        ? 'assets/${_getDeviceName(request.data!)}.png'
                        : 'assets/default_image.png', // Provide a default image path or handle the null case.
                    height: _graphicSize,
                    width: _graphicSize,
                    package: 'flipper_dashboard',
                  ),
                  horizontalSpaceSmall,
                  const Text(
                    'Flipper',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpaceMedium,
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      completer(DialogResponse(confirmed: false));
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (request.data != null) {
                        Device device = request.data!;
                        if (ProxyService.box.getUserId() != null &&
                            ProxyService.box.getBusinessId() != null) {
                          ProxyService.event.publish(loginDetails: {
                            'channel':
                                "${ProxyService.box.getUserId()!}-logout",
                            'userId': ProxyService.box.getUserId()!,
                            'businessId': ProxyService.box.getBusinessId()!,
                            'branchId': ProxyService.box.getBranchId()!,
                            'phone': ProxyService.box.getUserPhone(),
                            'defaultApp': ProxyService.box.getDefaultApp(),
                            'deviceName': device.deviceName,
                            'deviceVersion': device.deviceVersion,
                            'linkingCode': device.linkingCode,
                          });

                          try {
                            // await ProxyService.remote.hardDelete(
                            //     id: device.id!, collectionName: 'devices');
                            // await ProxyService.isar.delete(
                            //   endPoint: 'device',
                            //   id: device.id!,
                            // );
                          } catch (e) {}
                          completer(DialogResponse(confirmed: true));
                        }
                      } else {
                        //this is mobile client we can safely logout without deleting devices
                        await logOut();

                        viewModel.runStartupLogic();
                        completer(DialogResponse(confirmed: true));
                      }
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  LogoutModel viewModelBuilder(BuildContext context) => LogoutModel();

  String _getDeviceName(customData) {
    Device device = customData;
    return device.deviceName!;
  }
}
