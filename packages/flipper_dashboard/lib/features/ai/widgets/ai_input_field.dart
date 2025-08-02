import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../theme/ai_theme.dart';

// Define the provider for the AudioRecorder
final audioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

/// A 100% WhatsApp-style input field with voice recording
class AiInputField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Function(String) onSend;
  final Function(String)? onVoiceMessageSend;
  final String? hintText;
  final bool enabled;

  const AiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    this.onVoiceMessageSend,
    this.hintText = 'Message',
    this.enabled = true,
  });

  @override
  ConsumerState<AiInputField> createState() => _AiInputFieldState();
}

class _AiInputFieldState extends ConsumerState<AiInputField>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  bool _hasText = false;
  bool _isRecording = false;
  bool _isLocked = false;
  bool _isProcessing = false;
  double _slideX = 0.0;
  double _slideY = 0.0;
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  List<double> _waveformData = [];

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _lockController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _lockSlideAnimation;

  // Layout constants (matching WhatsApp)
  static const double _cancelThreshold = 120.0;
  static const double _lockThreshold = 60.0;
  static const double _micButtonSize = 48.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
    _hasText = widget.controller.text.isNotEmpty;
    _focusNode.onKeyEvent = _handleKeyEvent;

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _lockController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _lockSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lockController, curve: Curves.easeOut),
    );

    // Generate initial waveform data
    _generateWaveform();
  }

  @override
  void dispose() {
    _focusNode.onKeyEvent = null;
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    _pulseController.dispose();
    _lockController.dispose();
    _waveController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _generateWaveform() {
    final random = math.Random();
    _waveformData =
        List.generate(20, (index) => random.nextDouble() * 0.8 + 0.2);
  }

  void _updateWaveform() {
    setState(() {
      _generateWaveform();
    });
    _waveController.forward().then((_) => _waveController.reset());
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final isModifierPressed = HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isMetaPressed;

      if (event.logicalKey == LogicalKeyboardKey.enter && !isModifierPressed) {
        if (_canSend()) {
          _handleSubmit(widget.controller.text);
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _startRecording() async {
    if (_isProcessing || _isRecording) return;
    _isProcessing = true;

    final audioRecorder = ref.read(audioRecorderProvider);
    final hasPermission = await audioRecorder.hasPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required to record audio.'),
        ),
      );
      _isProcessing = false;
      return;
    }

    try {
      HapticFeedback.heavyImpact();
      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _slideX = 0.0;
        _slideY = 0.0;
        _isLocked = false;
      });

      // Start animations
      _pulseController.repeat(reverse: true);
      _lockController.forward();

      // Use temporary directory for recording
      final tempDir = await getTemporaryDirectory();
      final extension = Platform.isIOS ? '.m4a' : '.aac';
      final filePath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}$extension';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      // Start timer and waveform updates
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });
      });

      Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (!_isRecording) {
          timer.cancel();
          return;
        }
        _updateWaveform();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
      setState(() {
        _isRecording = false;
        _isLocked = false;
      });
      _pulseController.stop();
      _lockController.reverse();
    } finally {
      _isProcessing = false;
    }
  }

  void _stopRecording({bool send = true}) async {
    if (!_isRecording || _isProcessing) return;
    _isProcessing = true;

    try {
      final audioRecorder = ref.read(audioRecorderProvider);
      _recordingTimer?.cancel();
      _pulseController.stop();
      _lockController.reverse();

      final path = await audioRecorder.stop();
      if (path != null) {
        if (send && widget.onVoiceMessageSend != null) {
          HapticFeedback.lightImpact();
          widget.onVoiceMessageSend!(path);
        } else {
          HapticFeedback.lightImpact();
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      setState(() {
        _isRecording = false;
        _isLocked = false;
        _slideX = 0.0;
        _slideY = 0.0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    } finally {
      _isProcessing = false;
    }
  }

  void _lockRecording() {
    if (_isLocked) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isLocked = true;
      _slideX = 0.0;
      _slideY = 0.0;
    });
    _lockController.forward();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none, // Allow lock icon to appear outside bounds
          children: [
            AnimatedOpacity(
              opacity: _isRecording && !_isLocked ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: _buildNormalInterface(),
            ),
            if (_isRecording) _buildRecordingInterface(),
            if (_isRecording && !_isLocked) _buildLockIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalInterface() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Attachment/Emoji button (replaced with delete when locked)
        _isLocked
            ? GestureDetector(
                onTap: () => _stopRecording(send: false),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              )
            : Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: AiTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),

        // Input field
        Expanded(child: _buildInputField()),

        const SizedBox(width: 8),

        // Mic/Send button
        _buildMicSendButton(),
      ],
    );
  }

  Widget _buildRecordingInterface() {
    return Row(
      children: [
        // Delete/Cancel button (visible when not locked)
        if (!_isLocked)
          GestureDetector(
            onTap: () => _stopRecording(send: false),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _slideX < -_cancelThreshold
                    ? Colors.red.withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.delete_outline,
                color: _slideX < -_cancelThreshold ? Colors.red : Colors.grey,
                size: 24,
              ),
            ),
          ),

        if (!_isLocked) const SizedBox(width: 8),

        // Recording content bubble
        Expanded(
          child: Transform.translate(
            offset: Offset(_isLocked ? 0.0 : _slideX.clamp(-50.0, 0.0), 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),

                  // Red recording dot
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  // Timer
                  Text(
                    _formatDuration(_recordingDuration),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Waveform
                  Expanded(child: _buildWaveform()),

                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Mic button (recording) or Send button (locked)
        _isLocked
            ? GestureDetector(
                onTap: () => _stopRecording(send: true),
                child: Container(
                  width: _micButtonSize,
                  height: _micButtonSize,
                  decoration: const BoxDecoration(
                    color: AiTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              )
            : Transform.translate(
                offset: Offset(
                    _slideX.clamp(-50.0, 0.0), _slideY.clamp(-100.0, 0.0)),
                child: _buildRecordingMicButton(),
              ),
      ],
    );
  }

  Widget _buildLockIndicator() {
    return Positioned(
      right: 16,
      bottom: 64 + _slideY.clamp(-_lockThreshold, 0.0),
      child: AnimatedOpacity(
        opacity: (_slideY.abs() / _lockThreshold).clamp(0.0, 1.0),
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _slideY < -_lockThreshold
                ? AiTheme.primaryColor.withOpacity(0.3)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _slideY < -_lockThreshold
                  ? AiTheme.primaryColor
                  : Colors.grey[400]!,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.lock,
            size: 16,
            color: _slideY < -_lockThreshold
                ? AiTheme.primaryColor
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        maxLines: null,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildMicSendButton() {
    return GestureDetector(
      onLongPressStart:
          _hasText || widget.isLoading ? null : (details) => _startRecording(),
      onLongPressMoveUpdate: _hasText || widget.isLoading
          ? null
          : (details) {
              if (!_isRecording || _isLocked) return;

              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final startPosition = renderBox.size.width - _micButtonSize / 2;
              final currentPosition =
                  renderBox.globalToLocal(details.globalPosition);

              setState(() {
                _slideX =
                    (currentPosition.dx - startPosition).clamp(-200.0, 0.0);
                _slideY =
                    (currentPosition.dy - _micButtonSize).clamp(-100.0, 50.0);
              });

              // Check for lock (slide up)
              if (!_isLocked && _slideY < -_lockThreshold) {
                _lockRecording();
              }
              // Check for cancel (slide left)
              if (!_isLocked && _slideX < -_cancelThreshold) {
                _stopRecording(send: false);
              }
            },
      onLongPressUp: _hasText || widget.isLoading
          ? null
          : () {
              if (_isRecording && !_isLocked) {
                _stopRecording(send: true);
              }
            },
      child: Container(
        width: _micButtonSize,
        height: _micButtonSize,
        decoration: BoxDecoration(
          color: _hasText ? AiTheme.primaryColor : AiTheme.primaryColor,
          borderRadius: BorderRadius.circular(_micButtonSize / 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_micButtonSize / 2),
          onTap: _hasText ? () => _handleSubmit(widget.controller.text) : null,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Icon(
                    _hasText ? Icons.send : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingMicButton() {
    return Container(
      width: _micButtonSize,
      height: _micButtonSize,
      decoration: BoxDecoration(
        color: AiTheme.primaryColor,
        borderRadius: BorderRadius.circular(_micButtonSize / 2),
      ),
      child: const Icon(
        Icons.mic,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _waveformData.map((height) {
            return Container(
              width: 2,
              height: height * 20 + 4,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: AiTheme.primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  bool _canSend() {
    return widget.enabled &&
        !widget.isLoading &&
        widget.controller.text.trim().isNotEmpty;
  }

  void _handleSubmit(String text) {
    if (_canSend()) {
      HapticFeedback.lightImpact();
      widget.onSend(text.trim());
      widget.controller.clear();
      _focusNode.requestFocus();
    }
  }
}
