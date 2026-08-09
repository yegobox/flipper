import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum DictationState {
  /// Not listening. The mic button is tappable.
  idle,

  /// Permission / engine warm-up is in flight.
  starting,

  /// Microphone is live and words are being written into the target field.
  listening,

  /// Speech recognition can't run here (unsupported platform, denied
  /// permission, or engine failure). [SpeechDictation.error] says why.
  unavailable,
}

/// Drives on-device speech recognition and streams the recognised words
/// straight into a [TextEditingController], so a mic button behaves like
/// dictation rather than like a voice-note recorder.
///
/// Words land in the field as they are recognised (partial results), and the
/// text that was already typed before dictation started is preserved.
class SpeechDictation extends ChangeNotifier {
  SpeechDictation({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  DictationState _state = DictationState.idle;
  String? _error;
  bool _initialized = false;

  /// Text present in the target field when the session started; recognised
  /// words are appended to it so dictation never eats what the user typed.
  String _base = '';
  TextEditingController? _target;

  DictationState get state => _state;
  bool get isListening => _state == DictationState.listening;
  bool get isBusy => _state == DictationState.starting;

  /// Last failure reason, meant to be surfaced to the user once and cleared.
  String? get error => _error;

  /// `speech_to_text` ships implementations for these platforms only; on
  /// Linux there is no engine to fall back to.
  static bool get isSupportedPlatform {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  String? consumeError() {
    final message = _error;
    _error = null;
    return message;
  }

  Future<void> toggle(TextEditingController target) {
    if (isListening || isBusy) return stop();
    return start(target);
  }

  Future<void> start(TextEditingController target) async {
    if (_state == DictationState.listening ||
        _state == DictationState.starting) {
      return;
    }

    if (!isSupportedPlatform) {
      _fail('Voice input isn\'t available on this platform yet.');
      return;
    }

    _error = null;
    _setState(DictationState.starting);

    if (!_initialized) {
      try {
        _initialized = await _speech.initialize(
          onStatus: _onStatus,
          onError: _onError,
        );
      } catch (e) {
        _fail('Could not start voice input: $e');
        return;
      }
      if (!_initialized) {
        _fail(
          'Microphone access is off. Enable it for Flipper in your system '
          'settings, then try again.',
        );
        return;
      }
    }

    _target = target;
    final existing = target.text.trimRight();
    _base = existing.isEmpty ? '' : '$existing ';

    try {
      await _speech.listen(
        onResult: _onResult,
        listenOptions: SpeechListenOptions(
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.dictation,
          // Long enough to dictate a full question, and forgiving of the
          // pauses people take mid-sentence.
          listenFor: const Duration(minutes: 2),
          pauseFor: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      _fail('Could not start listening: $e');
      return;
    }

    _setState(DictationState.listening);
  }

  Future<void> stop() async {
    if (_state == DictationState.idle) return;
    try {
      await _speech.stop();
    } catch (_) {
      // Stopping a session that already ended is not worth surfacing.
    }
    _setState(DictationState.idle);
  }

  void _onResult(SpeechRecognitionResult result) {
    final target = _target;
    if (target == null) return;

    final text = '$_base${result.recognizedWords}';
    target.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

    if (result.finalResult) {
      // Keep the final phrase so a follow-on session appends rather than
      // overwrites, in case the engine restarts itself mid-dictation.
      _base = text.isEmpty ? '' : '$text ';
    }
  }

  void _onStatus(String status) {
    if (status == SpeechToText.listeningStatus) {
      _setState(DictationState.listening);
    } else if (_state != DictationState.unavailable) {
      // 'notListening' / 'done' — the engine stopped on its own (pause
      // timeout, listen timeout, or an explicit stop).
      _setState(DictationState.idle);
    }
  }

  void _onError(SpeechRecognitionError error) {
    // 'error_no_match' / 'error_speech_timeout' just mean nothing was heard;
    // dropping back to idle silently is friendlier than an error toast.
    const quiet = {'error_no_match', 'error_speech_timeout'};
    if (quiet.contains(error.errorMsg)) {
      _setState(DictationState.idle);
      return;
    }
    _fail(_describe(error.errorMsg));
  }

  String _describe(String errorMsg) {
    switch (errorMsg) {
      case 'error_permission':
      case 'error_audio_error':
        return 'Microphone access is off. Enable it for Flipper in your '
            'system settings, then try again.';
      case 'error_network':
      case 'error_network_timeout':
        return 'Voice input needs a network connection right now.';
      case 'error_busy':
        return 'The microphone is in use by another app.';
      default:
        return 'Voice input failed ($errorMsg).';
    }
  }

  void _fail(String message) {
    _error = message;
    // Unavailable is transient: the next tap retries, which is what a user
    // expects after granting permission in system settings.
    _state = DictationState.idle;
    notifyListeners();
  }

  void _setState(DictationState next) {
    if (_state == next) return;
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_initialized) {
      _speech.cancel();
    }
    super.dispose();
  }
}
