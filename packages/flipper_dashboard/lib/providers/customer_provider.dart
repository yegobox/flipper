import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final customerNameControllerProvider =
    ChangeNotifierProvider<TextEditingController>((ref) {
      final controller = TextEditingController();
      ref.onDispose(() => controller.dispose());
      return controller;
    });
