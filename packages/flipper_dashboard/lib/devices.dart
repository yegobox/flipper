// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

// Define a Riverpod provider for the device list
final deviceListProvider = FutureProvider<List<Device>>((ref) async {
  // Watch for updates from the updateStream
//  await ref.watch(deviceUpdateProvider.); // Wait for the first event
  return ProxyService.isar.getDevices(
    businessId: ProxyService.box.getBusinessId()!,
  );
});

class Devices extends ConsumerWidget {
  Devices({Key? key, this.pin}) : super(key: key);
  final int? pin;
  final _routerService = locator<RouterService>();
  final _dialogService = locator<DialogService>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceListAsyncValue = ref.watch(deviceListProvider);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          onPop: () async {
            _routerService.pop();
          },
          title: 'Link Device',
          disableButton: false,
          showActionButton: false,
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.devices,
                  size: 64,
                  color: Color(0xff006AFE),
                ),
              ),
            ),
            Text(
              "Use Flipper on other Devices",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 40,
              child: OutlinedButton(
                child: Text('Link A Device',
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
                style: ButtonStyle(
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blue.withOpacity(0.04);
                      }
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.blue.withOpacity(0.12);
                      }
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () {
                  _routerService.navigateTo(ScannViewRoute(intent: "login"));
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white70,
              width: MediaQuery.of(context).size.width - 40,
              height: 40,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                child: OutlinedButton(
                  child: Text('PIN: $pin',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.blue.withOpacity(0.04);
                        }
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed)) {
                          return Colors.blue.withOpacity(0.12);
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "List of connected Devices",
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            // streams of devices
            deviceListAsyncValue.when(
              data: (deviceList) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: deviceList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          'assets/${deviceList[index].deviceName}.png',
                          package: 'flipper_dashboard',
                        ),
                        title: Text(deviceList[index].deviceName!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _dialogService.showCustomDialog(
                                variant: DialogType.logOut,
                                title: 'Log out',
                                data: deviceList[index]);
                            ref.refresh(deviceListProvider);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () {
                return CircularProgressIndicator();
              },
              error: (error, stackTrace) {
                return Text('Error: $error');
              },
            ),
          ],
        ),
      ),
    );
  }
}
