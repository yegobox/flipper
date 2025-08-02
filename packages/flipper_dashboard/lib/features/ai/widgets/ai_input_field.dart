import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:math' as math;
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

  // Layout constants (matching WhatsApp exactly)
  static const double _cancelThreshold = 100.0;
  static const double _lockThreshold = 50.0;
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

      if (event.logicalKey == LogicalKeyboardKey.enter && isModifierPressed) {
        if (_canSend()) {
          _handleSubmit(widget.controller.text);
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _startRecording() async {
    final audioRecorder = ref.read(audioRecorderProvider);
    if (await audioRecorder.hasPermission()) {
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

      // Start recording
      await audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a');

      // Start timer and waveform updates
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });
      });

      // Update waveform periodically
      Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (!_isRecording) {
          timer.cancel();
          return;
        }
        _updateWaveform();
      });
    }
  }

  void _stopRecording({bool send = true}) async {
    if (!_isRecording) return;

    final audioRecorder = ref.read(audioRecorderProvider);
    _recordingTimer?.cancel();
    _pulseController.stop();
    _lockController.reverse();

    if (send) {
      HapticFeedback.lightImpact();
      final path = await audioRecorder.stop();
      if (path != null && widget.onVoiceMessageSend != null) {
        widget.onVoiceMessageSend!(path);
      }
    } else {
      HapticFeedback.lightImpact();
      await audioRecorder.stop();
    }

    setState(() {
      _isRecording = false;
      _isLocked = false;
      _slideX = 0.0;
      _slideY = 0.0;
    });
  }

  void _lockRecording() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLocked = true;
      _slideX = 0.0;
      _slideY = 0.0;
    });
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
        child: _isRecording && !_isLocked
            ? _buildRecordingInterface()
            : _buildNormalInterface(),
      ),
    );
  }

  Widget _buildNormalInterface() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Emoji/Attachment button
        Container(
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
    return Stack(
      children: [
        // Main recording interface
        Row(
          children: [
            // Slide to cancel text
            AnimatedOpacity(
              opacity: _slideX < -30 ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: 100,
                height: _micButtonSize,
                alignment: Alignment.center,
                child: Text(
                  '< Slide to cancel',
                  style: TextStyle(
                    color: _slideX < -_cancelThreshold
                        ? Colors.red
                        : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Recording content
            Expanded(
              child: Container(
                height: _micButtonSize,
                decoration: BoxDecoration(
                  color: AiTheme.inputBackgroundColor,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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

            const SizedBox(width: 8),

            // Mic button (recording)
            _buildRecordingMicButton(),
          ],
        ),

        // Lock indicator (appears when sliding up)
        if (_slideY < -20 && !_isLocked)
          Positioned(
            right: 20,
            bottom: _micButtonSize + 10 - _slideY.abs().clamp(0, 60),
            child: AnimatedBuilder(
              animation: _lockSlideAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _lockSlideAnimation.value,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 20,
                      color: _slideY < -_lockThreshold
                          ? AiTheme.primaryColor
                          : Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
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
      onLongPressStart: _hasText ? null : (_) => _startRecording(),
      onLongPressMoveUpdate: _hasText
          ? null
          : (details) {
              if (!_isRecording) return;

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
              else if (!_isLocked && _slideX < -_cancelThreshold) {
                _stopRecording(send: false);
              }
            },
      onLongPressEnd: _hasText
          ? null
          : (_) {
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
                color: AiTheme.primaryColor.withValues(alpha: 0.7),
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
