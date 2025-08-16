import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flipper_scanner/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pubnub/pubnub.dart' as nub;

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flipper_scanner/scanner_actions.dart';
import 'package:flipper_scanner/providers/scan_status_provider.dart';

class ScannView extends StatefulHookConsumerWidget {
  const ScannView({
    Key? key,
    this.intent = 'selling',
    this.useLatestImplementation = false,
    required this.scannerActions,
  }) : super(key: key);

  final String intent;
  final bool useLatestImplementation;
  final ScannerActions scannerActions;

  @override
  ScannViewState createState() => ScannViewState();
}

class ScannViewState extends ConsumerState<ScannView>
    with SingleTickerProviderStateMixin {
  MobileScannerController? controller;
  bool isFlashOn = false;
  bool isScanning = true;
  bool hasScanned = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // For managing PubNub subscriptions and timers
  nub.Subscription? _loginResponseSubscription;
  Timer? _loginTimeoutTimer;

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
    final scanStatus = ref.watch(scanStatusProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner background with blur overlay
          _buildScannerBackground(context),

          // Overlay with transparent cutout
          _buildOverlay(context, scannerSize),

          // Scanner animation
          _buildScannerAnimation(context, scannerSize),

          // Guide corners
          _buildGuideCorners(context, scannerSize),

          // Instructions text
          _buildInstructionsText(context, scannerSize),

          // Status bar when scanned
          if (hasScanned) _buildScanStatusBar(context, scanStatus),

          // Top app bar
          _buildAppBar(context),

          // Bottom controls
          _buildBottomControls(context),
        ],
      ),
    );
  }

  Widget _buildScannerBackground(BuildContext context) {
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

            widget.scannerActions.onBarcodeDetected(barcode);
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

  Widget _buildScanStatusBar(BuildContext context, ScanStatus scanStatus) {
    Color backgroundColor;
    Color iconColor;
    IconData statusIcon;
    String statusTitle;
    String statusMessage;
    bool showSpinner = false;

    switch (scanStatus) {
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
              onTap: () => widget.scannerActions.pop(),
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
        ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      });
      showToast(context, 'Invalid QR code format');

      // Wait a moment to show error state before closing
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        if (mounted) widget.scannerActions.pop();
      });
      return;
    }

    final split = result.split('-');
    if (split.length > 1 && split[0] == 'login') {
      widget.scannerActions.handleLoginScan(result);
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
      int userId = widget.scannerActions.getUserId();
      int businessId = widget.scannerActions.getBusinessId();
      int branchId = widget.scannerActions.getBranchId();
      String phone = widget.scannerActions.getUserPhone();
      String defaultApp = widget.scannerActions.getDefaultApp();
      String linkingCode = randomNumber().toString();

      // Create a unique response channel for this login attempt
      String responseChannel = 'login-response-${userId}-${linkingCode}';

      // Start listening for response on the response channel
      _listenForLoginResponse(responseChannel);

      // Update UI to show we're processing
      setState(() {
        ref.read(scanStatusProvider.notifier).state = ScanStatus.processing;
      });
      // get the pin
      final pin = await widget.scannerActions
          .getPinLocal(userId: userId, alwaysHydrate: false);

      nub.PublishResult result =
          await widget.scannerActions.getEventService().publish(loginDetails: {
        'channel': channel,
        'userId': userId,
        'businessId': businessId,
        'branchId': branchId,
        'phone': phone,
        'defaultApp': defaultApp,
        'tokenUid': pin?.tokenUid,
        'deviceName': Platform.operatingSystem,
        'deviceVersion': Platform.operatingSystemVersion,
        'linkingCode': linkingCode,
        'responseChannel': responseChannel, // Add response channel
      });

      if (result.isError) {
        // Only handle publish error here, success will be handled by response
        setState(() {
          ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
        });

        widget.scannerActions.showSimpleNotification('Failed to send login request');

        // Wait a moment to show failure state before closing
        await Future.delayed(Duration(milliseconds: 1500));
        if (mounted) widget.scannerActions.pop();
      }

      // Set up a timeout timer that will be canceled if we get a response
      _loginTimeoutTimer = Timer(Duration(seconds: 15), () {
        // Only proceed if widget is still mounted and we're still processing
        if (mounted && ref.read(scanStatusProvider) == ScanStatus.processing) {
          setState(() {
            ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
          });

          widget.scannerActions.showSimpleNotification('Login timed out. Please try again.');

          // Wait a moment to show failure state before closing
          Timer(Duration(milliseconds: 1500), () {
            if (mounted) widget.scannerActions.pop();
          });

          // Clean up subscription since we're done
          _loginResponseSubscription?.unsubscribe();
          _loginResponseSubscription = null;
        }
      });
    } catch (e) {
      // Handle any exceptions
      setState(() {
        ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      });

      widget.scannerActions.showSimpleNotification('Login error: ${e.toString()}');

      // Wait a moment to show failure state before closing
      await Future.delayed(Duration(milliseconds: 1500));
      if (mounted) widget.scannerActions.pop();
    }
  }

  void _listenForLoginResponse(String responseChannel) {
    try {
      // Use the connect method to get the PubNub instance
      nub.PubNub pubNub = widget.scannerActions.getEventService().connect();

      // Subscribe to the response channel
      _loginResponseSubscription =
          pubNub.subscribe(channels: {responseChannel});

      // Listen for messages on this channel
      _loginResponseSubscription!.messages.listen((envelope) {
        // Parse the response
        Map<String, dynamic> response = envelope.payload;

        if (response.containsKey('status')) {
          if (response['status'] == 'success') {
            // Update UI to show success
            setState(() {
              ref.read(scanStatusProvider.notifier).state = ScanStatus.success;
            });

            HapticFeedback.lightImpact();
            widget.scannerActions.showSimpleNotification('Login successful');

            // Wait a moment to show success state before closing
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              if (mounted) widget.scannerActions.pop();
            });
          } else if (response['status'] == 'choices_needed') {
            // This is not a failure - it's part of the normal flow when a user
            // needs to select a business/branch
            setState(() {
              ref.read(scanStatusProvider.notifier).state = ScanStatus.success;
            });

            HapticFeedback.lightImpact();
            widget.scannerActions.showSimpleNotification('Login successful - select your business');

            // Wait a moment to show success state before closing
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              if (mounted) widget.scannerActions.pop();
            });
          } else {
            // Update UI to show failure
            setState(() {
              ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
            });

            String errorMessage = response.containsKey('message')
                ? response['message']
                : 'Login failed';

            widget.scannerActions.showSimpleNotification(errorMessage);

            // Wait a moment to show failure state before closing
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              if (mounted) widget.scannerActions.pop();
            });
          }

          // Cancel the timeout timer since we got a response
          _loginTimeoutTimer?.cancel();
          _loginTimeoutTimer = null;

          // Unsubscribe after receiving response
          _loginResponseSubscription?.unsubscribe();
          _loginResponseSubscription = null;
        }
      }, onError: (error) {
        // Handle subscription error
        setState(() {
          ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
        });

        widget.scannerActions.showSimpleNotification('Connection error: $error');

        // Wait a moment to show failure state before closing
        Future.delayed(Duration(milliseconds: 1500)).then((_) {
          if (mounted) widget.scannerActions.pop();
        });
      });
    } catch (e) {
      // Handle any exceptions
      setState(() {
        ref.read(scanStatusProvider.notifier).state = ScanStatus.failed;
      });

      widget.scannerActions.showSimpleNotification('Subscription error: $e');

      // Wait a moment to show failure state before closing
      Future.delayed(Duration(milliseconds: 1500)).then((_) {
        if (mounted) widget.scannerActions.pop();
      });
    }
  }

  Future<void> performIntent(Barcode barcode) async {
    // Set initial scan status
    setState(() {
      hasScanned = true;
      isScanning = false;
      ref.read(scanStatusProvider.notifier).state = ScanStatus.idle;
    });

    // Vibrate on successful scan
    HapticFeedback.mediumImpact();

    // Process the barcode based on intent
    if (widget.intent == BARCODE) {
      widget.scannerActions.onBarcodeDetected(barcode);
    }

    // Handle login QR code scanning
    if (widget.intent == LOGIN) {
      await widget.scannerActions.handleLoginScan(barcode.rawValue);
      return;
    }

    // Add delay for better UX for non-login intents
    await Future.delayed(Duration(milliseconds: 1500));

    // Navigate based on intent for non-login cases
    navigate(barcode.rawValue);
  }

  void navigate(String? code) async {
    if (widget.intent == BARCODE) {
      widget.scannerActions.pop();
      return;
    }
    if (widget.intent == SELLING) {
      Product? product =
          await widget.scannerActions.getStrategyService().getProductByBarCode(code: code);
      if (product != null) {
        widget.scannerActions.navigateToSellRoute(product);
        return;
      }
      widget.scannerActions.showSimpleNotification("Product not found");
      widget.scannerActions.pop();
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
    // Cancel any active PubNub subscriptions
    if (_loginResponseSubscription != null) {
      _loginResponseSubscription!.unsubscribe();
      _loginResponseSubscription = null;
    }

    // Cancel any active timers
    _loginTimeoutTimer?.cancel();
    _loginTimeoutTimer = null;

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
