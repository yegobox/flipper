import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_providers.g.dart';

// Provider for tracking upload progress
@riverpod
class UploadProgress extends _$UploadProgress {
  @override
  double build() {
    return 0.0;
  }

  void setProgress(double progress) {
    state = progress;
  }
}
