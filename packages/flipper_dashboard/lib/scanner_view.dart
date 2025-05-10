import 'dart:io';
import 'dart:math';

import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pubnub/pubnub.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ScannView extends StatefulHookConsumerWidget {
  const ScannView({
    Key? key,
    this.intent = 'selling',
    this.useLatestImplementation = false,
  }) : super(key: key);

  final String intent;
  final bool useLatestImplementation;

  @override
  ScannViewState createState() => ScannViewState();
}

class ScannViewState extends ConsumerState<ScannView>
    with SingleTickerProviderStateMixin {
  MobileScannerController? controller;
  bool isFlashOn = false;
  bool isScanning = true;
  bool hasScanned = false;
  final _routerService = locator<RouterService>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  ScanStatus _scanStatus = ScanStatus.idle;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    // Setup animation for scanner line
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scannerSize = min(screenSize.width * 0.8, 280.0);

    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Scanner background with blur overlay
              _buildScannerBackground(context, model),

              // Overlay with transparent cutout
              _buildOverlay(context, scannerSize),

              // Scanner animation
              _buildScannerAnimation(context, scannerSize),

              // Guide corners
              _buildGuideCorners(context, scannerSize),

              // Instructions text
              _buildInstructionsText(context, scannerSize),

              // Status bar when scanned
              if (hasScanned) _buildScanStatusBar(context),

              // Top app bar
              _buildAppBar(context),

              // Bottom controls
              _buildBottomControls(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScannerBackground(BuildContext context, CoreViewModel model) {
    return Positioned.fill(
      child: MobileScanner(
        onDetectError: (error, stackTrace) => print(error),
        controller: controller,
        onDetect: (capture) {
          if (!isScanning || hasScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            setState(() {
              hasScanned = true;
              isScanning = false;
            });

            // Vibrate on successful scan
            HapticFeedback.mediumImpact();

            performIntent(barcode, model);
          }
        },
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, double scannerSize) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: CustomPaint(
          painter: ScannerOverlayPainter(
            scannerSize: scannerSize,
            borderRadius: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildScannerAnimation(BuildContext context, double scannerSize) {
    return Center(
      child: SizedBox(
        width: scannerSize,
        height: scannerSize,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Align(
              alignment: Alignment(0, 2 * _animation.value - 1),
              child: Container(
                height: 2,
                width: scannerSize - 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0),
                      Colors.blue.withOpacity(0.5),
                      Colors.blue,
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0),
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGuideCorners(BuildContext context, double scannerSize) {
    return Center(
      child: Container(
        width: scannerSize,
        height: scannerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Stack(
          children: [
            // Top left corner
            Positioned(
              top: 0,
              left: 0,
              child: _buildCorner(isTopLeft: true),
            ),
            // Top right corner
            Positioned(
              top: 0,
              right: 0,
              child: _buildCorner(isTopLeft: false, isTopRight: true),
            ),
            // Bottom left corner
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCorner(isBottomLeft: true),
            ),
            // Bottom right corner
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCorner(isBottomRight: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: isTopLeft || isTopRight
              ? BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          bottom: isBottomLeft || isBottomRight
              ? BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          left: isTopLeft || isBottomLeft
              ? BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
          right: isTopRight || isBottomRight
              ? BorderSide(color: Colors.white, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildInstructionsText(BuildContext context, double scannerSize) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 + scannerSize / 2 + 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Align QR code within frame',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            getInstructionByIntent(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String getInstructionByIntent() {
    switch (widget.intent) {
      case SELLING:
        return 'Scan product barcode to add to cart';
      case ATTENDANCE:
        return 'Scan attendance QR code to check in';
      case LOGIN:
        return 'Scan QR code to log in to your account';
      default:
        return 'Scanning...';
    }
  }

  Widget _buildScanStatusBar(BuildContext context) {
    Color backgroundColor;
    Color iconColor;
    IconData statusIcon;
    String statusTitle;
    String statusMessage;
    bool showSpinner = false;

    switch (_scanStatus) {
      case ScanStatus.processing:
        backgroundColor = Colors.blue.shade50;
        iconColor = Colors.blue;
        statusIcon = Icons.sync;
        statusTitle = 'Processing';
        statusMessage = 'Sending login data...';
        showSpinner = true;
        break;
      case ScanStatus.success:
        backgroundColor = Colors.green.shade50;
        iconColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusTitle = 'Login Successful';
        statusMessage = 'Desktop device authenticated';
        break;
      case ScanStatus.failed:
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.red;
        statusIcon = Icons.error;
        statusTitle = 'Login Failed';
        statusMessage = 'Could not authenticate desktop device';
        break;
      case ScanStatus.idle:
        backgroundColor = Colors.white;
        iconColor = Colors.green;
        statusIcon = Icons.check;
        statusTitle = 'QR Code Detected';
        statusMessage = 'Processing your request...';
        showSpinner = true;
        break;
    }

    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - 80,
      left: 30,
      right: 30,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: Colors.white,
                size: 16,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    statusMessage,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (showSpinner)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _routerService.pop(),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Text(
              getScannerTitleByIntent(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Add help/info dialog
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _buildInfoSheet(context),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Scanner Help',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.qr_code_scanner, color: Colors.blue),
            title: Text('Position the code within the frame'),
            subtitle: Text('Make sure it\'s well-lit and not blurry'),
          ),
          ListTile(
            leading: Icon(Icons.flash_on, color: Colors.amber),
            title: Text('Use flash in low light'),
            subtitle: Text('Toggle the flash icon at the bottom'),
          ),
          ListTile(
            leading: Icon(Icons.devices, color: Colors.green),
            title: Text('Clean your camera lens'),
            subtitle: Text('For better scanning results'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  String getScannerTitleByIntent() {
    switch (widget.intent) {
      case SELLING:
        return 'Product Scanner';
      case ATTENDANCE:
        return 'Attendance Scanner';
      case LOGIN:
        return 'Login Scanner';
      default:
        return 'QR Scanner';
    }
  }

  Widget _buildBottomControls(BuildContext context) {
    return Positioned(
      bottom: 40 + MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Gallery button
            GestureDetector(
              onTap: () {
                // Implement image picker functionality
                showToast(context, 'Gallery selection coming soon');
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),

            // Flash button
            GestureDetector(
              onTap: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                  controller?.toggleTorch();
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isFlashOn ? Colors.amber : Colors.white24,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFlashOn ? Colors.amberAccent : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isFlashOn
                      ? [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: isFlashOn ? Colors.white : Colors.white,
                  size: 32,
                ),
              ),
            ),

            // Camera switch button
            GestureDetector(
              onTap: () {
                controller?.switchCamera();
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cameraswitch,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scanToLogin({required String? result}) {
    // If there's no result or it doesn't match the login format, show error
    if (result == null ||
        !result.contains('-') ||
        !result.split('-')[0].contains('login')) {
      setState(() {
        _scanStatus = ScanStatus.failed;
      });
      showToast(context, 'Invalid QR code format');

      // Wait a moment to show error state before closing
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        if (mounted) _routerService.back();
      });
      return;
    }

    final split = result.split('-');
    if (split.length > 1 && split[0] == 'login') {
      // Check if we have network connectivity
      Connectivity().checkConnectivity().then((connectivityResult) {
        if (connectivityResult == ConnectivityResult.none) {
          // We're offline, show a specific message
          setState(() {
            _scanStatus = ScanStatus.failed;
          });
          showToast(context,
              'Cannot login via QR when offline. Please use PIN login instead.');

          // Wait a moment to show error state before closing
          Future.delayed(Duration(milliseconds: 2000)).then((_) {
            if (mounted) _routerService.back();
          });
        } else {
          // We're online, proceed with login
          // we get login-<linkingCode> so we need to get the linkingCode
          // pass the linkingCode to the publishLoginDetails function which is split[1]
          _publishLoginDetails(split[1]);
        }
      });
    }
  }

  Future<void> _publishLoginDetails(String channel) async {
    setState(() {
      hasScanned = true;
      isScanning = false;
    });

    // Vibrate on successful scan
    HapticFeedback.mediumImpact();

    try {
      int userId = ProxyService.box.getUserId()!;
      int businessId = ProxyService.box.getBusinessId()!;
      int branchId = ProxyService.box.getBranchId()!;
      String phone = ProxyService.box.getUserPhone()!;
      String uid = ProxyService.box.uid();
      String defaultApp = ProxyService.box.getDefaultApp();
      String linkingCode = randomNumber().toString();

      // Update UI to show we're processing
      setState(() {
        _scanStatus = ScanStatus.processing;
      });

      PublishResult result = await ProxyService.event.publish(loginDetails: {
        'channel': channel,
        'userId': userId,
        'businessId': businessId,
        'branchId': branchId,
        'phone': phone,
        'defaultApp': defaultApp,
        'uid': uid,
        'deviceName': Platform.operatingSystem,
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': linkingCode,
      });

      if (!result.isError) {
        // Update UI to show success
        setState(() {
          _scanStatus = ScanStatus.success;
        });

        HapticFeedback.lightImpact();
        showToast(context, 'Login success');

        // Wait a moment to show success state before closing
        await Future.delayed(Duration(milliseconds: 1500));
        if (mounted) _routerService.back();
      } else {
        // Update UI to show failure
        setState(() {
          _scanStatus = ScanStatus.failed;
        });

        showToast(context, 'Login failed');

        // Wait a moment to show failure state before closing
        await Future.delayed(Duration(milliseconds: 1500));
        if (mounted) _routerService.back();
      }
    } catch (e) {
      // Handle any exceptions
      setState(() {
        _scanStatus = ScanStatus.failed;
      });

      showToast(context, 'Login error: ${e.toString()}');

      // Wait a moment to show failure state before closing
      await Future.delayed(Duration(milliseconds: 1500));
      if (mounted) _routerService.back();
    }
  }

  Future<void> performIntent(Barcode barcode, CoreViewModel model) async {
    // Set initial scan status
    setState(() {
      hasScanned = true;
      isScanning = false;
      _scanStatus = ScanStatus.idle;
    });

    // Vibrate on successful scan
    HapticFeedback.mediumImpact();

    // Process the barcode based on intent
    if (widget.intent == BARCODE) {
      model.productService.setBarcode(barcode.rawValue);
    }

    // Handle login QR code scanning
    if (widget.intent == LOGIN) {
      scanToLogin(result: barcode.rawValue);
      // We'll navigate from _publishLoginDetails after showing success/failure
      return;
    }

    // Add delay for better UX for non-login intents
    await Future.delayed(Duration(milliseconds: 1500));

    // Navigate based on intent for non-login cases
    navigate(barcode.rawValue, model);
  }

  void navigate(String? code, CoreViewModel model) async {
    if (widget.intent == BARCODE) {
      _routerService.pop();
      return;
    }
    if (widget.intent == SELLING) {
      Product? product =
          await model.productService.getProductByBarCode(code: code);
      if (product != null) {
        _routerService.navigateTo(SellRoute(product: product));
        return;
      }
      showSimpleNotification(
        const Text("Product not found"),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
      _routerService.pop();
      return;
    }
    if (widget.intent == ATTENDANCE) {
      return;
    }
    if (widget.intent == LOGIN) {
      return;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final double scannerSize;
  final double borderRadius;

  ScannerOverlayPainter({
    required this.scannerSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scannerSize,
      height: scannerSize,
    );

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
      );

    final finalPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(
      finalPath,
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // Draw the blur effect around the cutout
    final blurPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withOpacity(0.0),
          Colors.black.withOpacity(0.7),
        ],
      ).createShader(cutOutRect);

    // Draw blur around the cutout
    final blurRect = cutOutRect.inflate(30);
    canvas.drawRect(
      Rect.fromLTRB(
        blurRect.left,
        cutOutRect.top,
        blurRect.right,
        cutOutRect.bottom,
      ),
      blurPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum ScanStatus { idle, processing, success, failed }
