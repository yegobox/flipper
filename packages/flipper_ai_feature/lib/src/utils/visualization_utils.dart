import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

class VisualizationUtils {
  /// Captures the widget identified by [visualizationKey] as an image and copies it to the clipboard.
  /// Shows success/error SnackBars using [context].
  static Future<void> copyToClipboard(
    BuildContext context,
    GlobalKey visualizationKey, {
    VoidCallback? onSuccess,
  }) async {
    // Capture and copy the image
    // Using addPostFrameCallback to ensuring the render object is ready/stable if called during build (unlikely for button tap but safe)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final boundary =
            visualizationKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;

        if (boundary == null) {
          if (context.mounted) {
            showErrorNotification(
              context,
              'Error: Could not find chart to copy.',
            );
          }
          return;
        }

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          if (context.mounted) {
            showErrorNotification(
              context,
              'Error: Could not generate image data.',
            );
          }
          return;
        }

        await Pasteboard.writeImage(byteData.buffer.asUint8List());

        if (context.mounted) {
          showSuccessNotification(context, 'Chart copied to clipboard!');
        }

        onSuccess?.call();
      } catch (e) {
        if (context.mounted) {
          showErrorNotification(context, 'Failed to copy chart: $e');
        }
      }
    });
  }
}
