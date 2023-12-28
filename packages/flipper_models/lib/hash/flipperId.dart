import 'dart:math' as math;
import 'dart:typed_data';

import 'murmur_hash_2.dart';
import 'process_unique.dart';

/// ## FlipperId
/// This class allows you to create and manipulate bson FlipperIds.
///
/// Example:
/// ```dart
/// final id = FlipperId();
/// final id2 = FlipperId.fromHexString('5f527e9b350aa5f9709daf16');
/// final id3 = FlipperId.fromBytes(
///   [95, 82, 126, 187, 124, 177, 57, 83, 165, 119, 211, 48],
/// );
/// final id4 = FlipperId.fromValues(timestamp, processUnique, counter);
/// ```
class FlipperId {
  static const _maxCounterValue = 0xffffff;
  static const _counterMask = _maxCounterValue + 1;

  /// Length of the [FlipperId] in bytes.
  static const byteLength = 15;

  /// Length of the FlipperId [hexString].
  static const hexStringLength = byteLength * 2;

  /// 5 bytes of process and timestamp specific random number.
  static final int _processUnique = ProcessUnique().getValue();

  /// FlipperId counter that will be used for FlipperId generation.
  ///
  /// Initialized with random value.
  static int _counter = math.Random().nextInt(_counterMask);

  /// Get FlipperId counter by incrementing current counter value by 1.
  /// FlipperId counter cannot be larger than 3 bits.
  static int _getCounter() => (_counter = (_counter + 1) % _counterMask);

  final Uint8List _bytes = Uint8List(byteLength);

  /// FlipperId bytes.
  Uint8List get bytes => _bytes;

  /// ### Creates FlipperId.
  ///
  /// {@template FlipperId.structure}
  /// #### FlipperId structure:
  /// ```
  ///   4 byte timestamp    5 byte process unique   3 byte counter
  /// |<----------------->|<---------------------->|<------------>|
  /// |----|----|----|----|----|----|----|----|----|----|----|----|
  /// 0                   4                   8                   12
  /// ```
  /// {@endtemplate}
  ///
  FlipperId() {
    _initialize(
      DateTime.now().millisecondsSinceEpoch,
      _processUnique,
      _getCounter(),
    );
  }

  /// ### Creates FlipperId from provided values.
  ///
  /// {@macro FlipperId.structure}
  FlipperId.fromValues(
    int millisecondsSinceEpoch,
    int processUnique,
    int counter,
  ) {
    ArgumentError.checkNotNull(millisecondsSinceEpoch, 'timestamp');
    ArgumentError.checkNotNull(processUnique, 'processUnique');
    ArgumentError.checkNotNull(counter, 'counter');

    _initialize(millisecondsSinceEpoch, processUnique, counter);
  }

  /// ### Creates FlipperId from provided timestamp.
  /// Only timestamp segment is set while the rest of the FlipperId is
  /// zeroed out.
  ///
  /// Example:
  /// ```
  /// final id = FlipperId.fromTimestamp(DateTime.now());
  /// ```
  /// {@macro FlipperId.structure}
  FlipperId.fromTimestamp(DateTime timestamp) {
    ArgumentError.checkNotNull(timestamp, 'timestamp');

    final secondsSinceEpoch = timestamp.millisecondsSinceEpoch ~/ 1000;

    // 4-byte timestamp
    _bytes[3] = secondsSinceEpoch & 0xff;
    _bytes[2] = (secondsSinceEpoch >> 8) & 0xff;
    _bytes[1] = (secondsSinceEpoch >> 16) & 0xff;
    _bytes[0] = (secondsSinceEpoch >> 24) & 0xff;
  }

  /// ### Creates FlipperId from hex string.
  /// Can be helpful for mapping hex strings returned from
  /// API / mongodb to FlipperId instances.
  ///
  /// Example usage:
  /// ```dart
  /// final id = FlipperId();
  /// final id2 = FlipperId.fromHexString(id.hexString);
  /// print(id == id2) // => true
  /// ```
  /// {@macro FlipperId.structure}
  FlipperId.fromHexString(String hexString) {
    ArgumentError.checkNotNull(hexString, 'hexString');
    if (hexString.length != hexStringLength) {
      throw ArgumentError.value(
          hexString, 'hexString', 'Provided hexString has wrong length.');
    }

    final secondsSinceEpoch = int.parse(hexString.substring(0, 8), radix: 16);
    final millisecondsSinceEpoch = secondsSinceEpoch * 1000;

    final processUnique = int.parse(hexString.substring(8, 18), radix: 16);
    final counter = int.parse(hexString.substring(18, 24), radix: 16);

    /// cache this value
    _hexString = hexString;

    _initialize(millisecondsSinceEpoch, processUnique, counter);
  }

  /// Internally initialize FlipperId instance by filling
  /// bytes array with provided data.
  void _initialize(int millisecondsSinceEpoch, int processUnique, int counter) {
    final secondsSinceEpoch = millisecondsSinceEpoch ~/ 1000;

    // 4-byte timestamp
    _bytes[3] = secondsSinceEpoch & 0xff;
    _bytes[2] = (secondsSinceEpoch >> 8) & 0xff;
    _bytes[1] = (secondsSinceEpoch >> 16) & 0xff;
    _bytes[0] = (secondsSinceEpoch >> 24) & 0xff;

    // 5-byte process unique
    _bytes[8] = processUnique & 0xff;
    _bytes[7] = (processUnique >> 8) & 0xff;
    _bytes[6] = (processUnique >> 16) & 0xff;
    _bytes[5] = (processUnique >> 24) & 0xff;
    _bytes[4] = (processUnique >> 32) & 0xff;

    // 3-byte counter
    _bytes[11] = counter & 0xff;
    _bytes[10] = (counter >> 8) & 0xff;
    _bytes[9] = (counter >> 16) & 0xff;
  }

  /// ### Creates FlipperId from bytes.
  /// Example usage:
  /// ```dart
  /// final id = FlipperId();
  /// final id2 = FlipperId.fromBytes(id.bytes);
  /// print(id == id2) // => true
  /// ```
  ///
  /// {@macro FlipperId.structure}
  FlipperId.fromBytes(List<int> bytes) {
    ArgumentError.checkNotNull(bytes, 'bytes');
    if (bytes.length != byteLength) {
      throw ArgumentError.value(
        bytes,
        'bytes',
        'Bytes array should has length equal to $byteLength',
      );
    }

    for (var i = 0; i < byteLength; i++) {
      _bytes[i] = bytes[i];
    }
  }

  DateTime? _timestamp;

  /// Returns the generation date (accurate up to the second) that this
  /// FlipperId was generated.
  DateTime get timestamp {
    if (_timestamp != null) return _timestamp!;

    var secondsSinceEpoch = 0;
    for (var x = 3, y = 0; x >= 0; x--, y++) {
      secondsSinceEpoch += _bytes[x] * math.pow(256, y).toInt();
    }

    return _timestamp = DateTime.fromMillisecondsSinceEpoch(
      secondsSinceEpoch * 1000,
    );
  }

  String? _hexString;

  /// Returns hex string for current [FlipperId].
  String get hexString {
    if (_hexString == null) {
      final buffer = StringBuffer();
      for (var i = 0; i < _bytes.length; i++) {
        buffer.write(_bytes[i].toRadixString(16).padLeft(2, '0'));
      }
      _hexString = buffer.toString();
    }

    return _hexString!;
  }

  @override
  bool operator ==(Object other) {
    if (other is! FlipperId) return false;
    for (var i = 0; i < _bytes.length; i++) {
      if (other._bytes[i] != _bytes[i]) return false;
    }
    return true;
  }

  /// Whether hexString is a valid FlipperId
  static bool isValid(String hexString) {
    try {
      if (hexString.length != 24) return false;

      int.parse(hexString.substring(0, 8), radix: 16);
      int.parse(hexString.substring(8, 18), radix: 16);
      int.parse(hexString.substring(18, 24), radix: 16);
    } on FormatException {
      return false;
    }
    return true;
  }

  /// Caches [hashCode].
  /// Prevents multiple calculations of the same value.
  int? _hashCode;
  @override
  int get hashCode => _hashCode ??= murmurHash2(bytes);

  @override
  String toString() => hexString;
}
