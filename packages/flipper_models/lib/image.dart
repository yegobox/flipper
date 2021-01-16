library flipper_models;

import 'package:built_value/built_value.dart';

part 'image.g.dart';

abstract class ImageP implements Built<ImageP, ImagePBuilder> {
  String get path;
  bool get isLocal;

  ImageP._();

  factory ImageP([void Function(ImagePBuilder) updates]) = _$ImageP;
}
