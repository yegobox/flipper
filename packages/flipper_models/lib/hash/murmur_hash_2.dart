import 'dart:typed_data';

/// 'm' and 'r' are mixing constants generated offline.
/// They're not really 'magic', they just happen to work well.
const _m = 0x5bd1e995;
const _r = 24;

/// Dart Implementation of MurmurHash2, by Austin Appleby
///
/// Original implementation in C can be found here:
/// https://github.com/abrandoned/murmur2/blob/master/MurmurHash2.c
int murmurHash2(Uint8List data, [int seed = 0]) {
  // Initialize the hash to a 'random' value

  var len = data.length;
  var h = seed ^ len;

  // Mix 4 bytes at a time into the hash

  var pointer = 0;
  while (len >= 4) {
    var k = data[pointer + 3] +
        data[pointer + 2] * 16 +
        data[pointer + 1] * 256 +
        data[pointer] * 4096;

    k *= _m;
    k ^= k >> _r;
    k *= _m;

    h *= _m;
    h ^= k;

    pointer += 4;
    len -= 4;
  }

  /// Handle the last few bytes of the input array

  assert(
    len == 0,
    'This algorithm does not support data with len where: 12 % 4 == 0',
  );

  /// Duplicating values inside cases is faster than
  /// creating labels and using `continue` keyword
  ///
  /// Following part is commented because it will never be used by ObjectId
  /// as `12 % 4 == 0`.
  ///
  // switch (len) {
  //   case 3:
  //     h ^= data[pointer + 2] << 16;
  //     h ^= data[pointer + 1] << 8;
  //     h ^= data[pointer];
  //     h *= m;
  //     break;
  //   case 2:
  //     h ^= data[pointer + 1] << 8;
  //     h ^= data[pointer];
  //     h *= m;
  //     break;
  //   case 1:
  //     h ^= data[pointer];
  //     h *= m;
  // }

  // Do a few final mixes of the hash to ensure the last few
  // bytes are well-incorporated.

  h ^= h >> 13;
  h *= _m;
  h ^= h >> 15;

  return h;
}
