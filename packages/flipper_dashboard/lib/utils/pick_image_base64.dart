import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// An image the user chose, already sized up and encoded.
class PickedImage {
  const PickedImage({
    required this.bytes,
    required this.base64,
    required this.aspectRatio,
  });

  final Uint8List bytes;
  final String base64;

  /// height / width. Captured here because Syncfusion's `drawImage` takes an
  /// explicit rectangle and will distort an image given the wrong one.
  final double aspectRatio;

  int get byteLength => bytes.length;
}

/// Why a pick did not produce an image.
enum PickImageFailure {
  /// The user dismissed the picker. Not an error — say nothing.
  cancelled,
  unreadable,
  empty,
  tooLarge,
}

class PickImageResult {
  const PickImageResult._({this.image, this.failure, this.message});

  const PickImageResult.success(PickedImage image) : this._(image: image);

  const PickImageResult.failed(PickImageFailure failure, String message)
    : this._(failure: failure, message: message);

  final PickedImage? image;
  final PickImageFailure? failure;
  final String? message;

  bool get cancelled => failure == PickImageFailure.cancelled;
}

/// Picks a PNG/JPEG and returns it base64-encoded, refusing anything over
/// [maxSizeBytes].
///
/// Shared by the receipt logo (device-local, 295 KB) and the company stamp
/// (Ditto-synced, far smaller) so the desktop path — where `PlatformFile.bytes`
/// is null and the file must be read from `path` — exists in one place.
///
/// There is no image package in this package, so an oversized file is refused
/// rather than downscaled; the caller tells the user the limit.
Future<PickImageResult> pickImageAsBase64({required int maxSizeBytes}) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['png', 'jpg', 'jpeg'],
    withData: false,
  );

  if (result == null || result.files.isEmpty) {
    return const PickImageResult.failed(
      PickImageFailure.cancelled,
      'No file selected.',
    );
  }

  final platformFile = result.files.single;
  Uint8List? bytes = platformFile.bytes;

  // Desktop hands back a path rather than bytes.
  if (bytes == null && platformFile.path != null) {
    try {
      bytes = await File(platformFile.path!).readAsBytes();
    } catch (_) {
      return const PickImageResult.failed(
        PickImageFailure.unreadable,
        'Failed to read the selected file. Please try again.',
      );
    }
  }

  if (bytes == null || bytes.isEmpty) {
    return const PickImageResult.failed(
      PickImageFailure.empty,
      'That file has no data. Please pick another.',
    );
  }

  if (bytes.length > maxSizeBytes) {
    final kb = (maxSizeBytes / 1024).round();
    return PickImageResult.failed(
      PickImageFailure.tooLarge,
      'Please choose an image under ${kb}KB.',
    );
  }

  // Decoding doubles as validation. FilePicker filters by extension, not by
  // content, so a renamed file reaches here looking like a PNG — and a stamp
  // that cannot decode would be replicated to every device on the branch and
  // then silently fail to draw on every document.
  final aspectRatio = await _aspectRatio(bytes);
  if (aspectRatio == null) {
    return const PickImageResult.failed(
      PickImageFailure.unreadable,
      'That file is not a readable PNG or JPEG. Please pick another.',
    );
  }

  return PickImageResult.success(
    PickedImage(
      bytes: bytes,
      base64: base64Encode(bytes),
      aspectRatio: aspectRatio,
    ),
  );
}

/// height / width, or null when the bytes are not a decodable image.
///
/// Null is the caller's signal to reject the file. Guessing a square here used
/// to let an undecodable file through, and it only surfaced later as a stamp
/// that never appeared on a document.
Future<double?> _aspectRatio(Uint8List bytes) async {
  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final width = image.width;
    final height = image.height;
    image.dispose();
    codec.dispose();
    if (width <= 0 || height <= 0) return null;
    return height / width;
  } catch (e) {
    debugPrint('pickImageAsBase64: could not decode the selected image: $e');
    return null;
  }
}
