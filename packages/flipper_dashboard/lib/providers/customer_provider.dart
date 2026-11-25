import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final customerNameControllerProvider =
    ChangeNotifierProvider<TextEditingController>((ref) {
      return TextEditingController();
    });
