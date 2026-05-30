import 'package:flutter/material.dart';

/// Corner radii (formerly `Corners` in flipper_infra).
class Corners {
  static const BorderRadius s3Border = BorderRadius.all(s3Radius);
  static const Radius s3Radius = Radius.circular(3);

  static const BorderRadius s4Border = BorderRadius.all(s4Radius);
  static const Radius s4Radius = Radius.circular(4);

  static const BorderRadius s5Border = BorderRadius.all(s5Radius);
  static const Radius s5Radius = Radius.circular(5);

  static const BorderRadius s6Border = BorderRadius.all(s6Radius);
  static const Radius s6Radius = Radius.circular(6);

  static const BorderRadius s8Border = BorderRadius.all(s8Radius);
  static const Radius s8Radius = Radius.circular(8);

  static const BorderRadius s10Border = BorderRadius.all(s10Radius);
  static const Radius s10Radius = Radius.circular(10);

  static const BorderRadius s12Border = BorderRadius.all(s12Radius);
  static const Radius s12Radius = Radius.circular(12);

  static const BorderRadius s16Border = BorderRadius.all(s16Radius);
  static const Radius s16Radius = Radius.circular(16);
}

class Sizes {
  static double hitScale = 1;

  static double get hit => 40 * hitScale;

  static double get iconMed => 20;

  static double get sideBarWidth => 250 * hitScale;
}
