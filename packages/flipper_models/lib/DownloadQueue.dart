import 'package:flipper_models/view_models/mixins/riverpod_states.dart';

import 'dart:collection';

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'SessionManager.dart';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;

final sessionManager = SessionManager();

class DownloadQueue {
  final Queue<DownloadParams> _queue = Queue();
  final int _maxConcurrentDownloads;
  int _activeDownloads = 0;

  DownloadQueue(this._maxConcurrentDownloads);

  void addToQueue(DownloadParams params) {
    _queue.add(params);
    _processQueue();
  }

  void _processQueue() {
    while (_activeDownloads < _maxConcurrentDownloads && _queue.isNotEmpty) {
      final params = _queue.removeFirst();
      _activeDownloads++;
      _startDownload(params);
    }
  }

  void _startDownload(DownloadParams params) async {
    try {
      await downloadAssetTask(params);
      talker.warning('Download completed for ${params.assetName}');
    } catch (e) {
      talker.error('Error downloading ${params.assetName}: $e');
    } finally {
      _downloadCompleted();
    }
  }

  void _downloadCompleted() {
    _activeDownloads--;
    _processQueue();
  }
}

Future<void> downloadAssetTask(DownloadParams params) async {
  try {
    // Authenticate before starting the download
    if (!await sessionManager.isAuthenticated()) {
      await sessionManager.signIn("yegobox@gmail.com");
      if (!await sessionManager.isAuthenticated()) {
        throw Exception('Failed to authenticate');
      }
    }

    // Continue with download if authentication is successful
    Directory directoryPath;
    if (Platform.isAndroid) {
      directoryPath = await getApplicationCacheDirectory();
    } else {
      directoryPath = await getApplicationCacheDirectory();
    }

    final filePath = path.join(directoryPath.path, params.assetName);
    final file = File(filePath);

    if (await file.exists()) {
      talker.warning('File already exists: $filePath');
      return;
    }

    talker.warning("filePathIsolate: $filePath");

    final storagePath = amplify.StoragePath.fromString(
        'public/${params.subPath}-${params.branchId}/${params.assetName}');

    final operation = amplify.Amplify.Storage.downloadFile(
      path: storagePath,
      localFile: amplify.AWSFile.fromPath(filePath),
      onProgress: (progress) {
        final percentageCompleted = (progress.fractionCompleted * 100).toInt();
        talker.debug(
            'Download progress for ${params.assetName}: $percentageCompleted%');
      },
    );

    await operation.result;
  } catch (error) {
    talker.error('Error in downloadAssetTask: $error');
    rethrow;
  }
}

class DownloadParams {
  final int branchId;
  final String assetName;
  final String subPath;

  DownloadParams({
    required this.branchId,
    required this.assetName,
    required this.subPath,
  });
}
