import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final customerNameControllerProvider =
    ChangeNotifierProvider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});
