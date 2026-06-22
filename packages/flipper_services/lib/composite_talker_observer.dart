import 'dart:async';

import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

/// Forwards Talker errors to Crashlytics (when available) and persists them via
/// [LogService] so catch blocks that call `talker.error(...)` are stored in the
/// local `Log` table without editing every catch site.
class CompositeTalkerObserver extends TalkerObserver {
  final LogService _logService = LogService();

  TalkerObserver? _crashObserver;

  TalkerObserver? get _crash {
    if (_crashObserver != null) {
      return _crashObserver;
    }
    try {
      final crash = ProxyService.crash;
      if (crash is TalkerObserver) {
        _crashObserver = crash as TalkerObserver;
      }
    } catch (_) {
      // Locator not ready yet (early startup).
    }
    return _crashObserver;
  }

  @override
  void onError(TalkerError err) {
    _crash?.onError(err);
    unawaited(_persist(
      err.error ?? err.message,
      err.stackTrace,
      type: 'talker_error',
      message: err.message,
    ));
  }

  @override
  void onException(TalkerException err) {
    _crash?.onException(err);
    unawaited(_persist(
      err.exception ?? err.message,
      err.stackTrace,
      type: 'talker_exception',
      message: err.message,
    ));
  }

  Future<void> _persist(
    Object? error,
    StackTrace? stackTrace, {
    required String type,
    String? message,
  }) async {
    if (error == null) {
      return;
    }
    if (!Repository.isReady) {
      return;
    }

    final text = error.toString();
    if (_shouldSkip(text, message)) {
      return;
    }

    await _logService.logException(
      error,
      stackTrace: stackTrace,
      type: type,
      extra: message == null ? null : {'talker_message': message},
    );
  }

  bool _shouldSkip(String errorText, String? message) {
    final combined = '$errorText ${message ?? ''}';
    const skipFragments = [
      'LogService',
      'Failed to save log',
      'Failed to get logs',
      'Failed to clear old logs',
      'Ditto not initialized',
    ];
    return skipFragments.any(combined.contains);
  }
}
