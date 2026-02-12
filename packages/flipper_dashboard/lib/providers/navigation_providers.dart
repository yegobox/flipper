import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flipper_services/proxy.dart';

// Navigation state providers
final selectedMenuItemProvider = StateProvider<int>(
  (ref) => -1,
); // -1 represents the Apps screen
final defaultAppProvider = StateProvider<String?>((ref) => null);
final isDefaultAppLoadedProvider = StateProvider<bool>((ref) => false);

final featuresProvider = StreamProvider<List<String>>((ref) {
  final controller = StreamController<List<String>>();
  final appService = ProxyService.app;

  void listener() {
    controller.add(appService.features);
  }

  appService.addListener(listener);
  controller.add(appService.features);

  ref.onDispose(() {
    appService.removeListener(listener);
    controller.close();
  });

  return controller.stream;
});

final hasFeatureProvider = Provider.family<bool, String>((ref, featureName) {
  final featuresAsync = ref.watch(featuresProvider);
  return featuresAsync.when(
    data: (features) => features.contains(featureName),
    loading: () => false,
    error: (_, __) => false,
  );
});
