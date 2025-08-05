import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../theme/ai_theme.dart';

final audioRecorderProvider = Provider<AudioRecorder>((ref) {
  final recorder = AudioRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

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
  final GlobalKey _micButtonKey = GlobalKey();

  bool _hasText = false;
  bool _isRecording = false;
  bool _isLocked = false;
  bool _isProcessing = false;
  bool _showCancelHint = false;
  bool _showLockHint = false;
  bool _isCancelZone = false;
  double _slideX = 0.0;
  double _slideY = 0.0;
  Timer? _recordingTimer;
  Timer? _waveformTimer;
  Timer? _cancelHintTimer;
  Timer? _lockHintTimer;
  int _recordingDuration = 0;
  List<double> _waveformData = [];
  String? _currentRecordingPath;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _lockController;
  late AnimationController _waveController;
  late AnimationController _slideController;
  late AnimationController _cancelController;
  late AnimationController _micScaleController;
  late AnimationController _lockHintController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _lockSlideAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _cancelAnimation;
  late Animation<double> _micScaleAnimation;
  late Animation<double> _lockHintAnimation;

  // Layout constants
  static const double _cancelThreshold = 100.0;
  static const double _lockThreshold = 80.0;
  static const double _micButtonSize = 48.0;
  static const double _recordingBubbleHeight = 48.0;
  static const Duration _animationDuration = Duration(milliseconds: 150);
  static const Duration _hintDisplayDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
    _hasText = widget.controller.text.isNotEmpty;
    _focusNode.onKeyEvent = _handleKeyEvent;
    _initializeAnimations();
    _generateWaveform();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _lockController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _cancelController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _micScaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _lockHintController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _lockSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lockController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _cancelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cancelController, curve: Curves.easeInOut),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _micScaleController, curve: Curves.elasticOut),
    );
    _lockHintAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lockHintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _focusNode.onKeyEvent = null;
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    _pulseController.dispose();
    _lockController.dispose();
    _waveController.dispose();
    _slideController.dispose();
    _cancelController.dispose();
    _micScaleController.dispose();
    _lockHintController.dispose();
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    _cancelHintTimer?.cancel();
    _lockHintTimer?.cancel();
    super.dispose();
  }

  void _generateWaveform() {
    final random = math.Random();
    _waveformData = List.generate(25, (index) {
      final baseHeight = random.nextDouble() * 0.8 + 0.2;
      final variation = math.sin(index * 0.5) * 0.3;
      return (baseHeight + variation).clamp(0.1, 1.0);
    });
  }

  void _updateWaveform() {
    if (!_isRecording) return;
    setState(() => _generateWaveform());
    _waveController.forward().then((_) => _waveController.reset());
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final isModifierPressed = HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isMetaPressed;

      if (event.logicalKey == LogicalKeyboardKey.enter && !isModifierPressed) {
        if (_canSend()) _handleSubmit(widget.controller.text);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> _startRecording() async {
    if (_isProcessing || _isRecording || _hasText || widget.isLoading) return;

    setState(() => _isProcessing = true);

    final audioRecorder = ref.read(audioRecorderProvider);
    final hasPermission = await audioRecorder.hasPermission();

    if (!hasPermission) {
      _showPermissionDialog();
      setState(() => _isProcessing = false);
      return;
    }

    try {
      HapticFeedback.heavyImpact();

      final tempDir = await getTemporaryDirectory();
      final extension = Platform.isIOS ? '.m4a' : '.aac';
      _currentRecordingPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}$extension';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: _currentRecordingPath!,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _slideX = 0.0;
        _slideY = 0.0;
        _isLocked = false;
        _showCancelHint = false;
        _showLockHint = false;
      });

      _pulseController.repeat(reverse: true);
      _slideController.forward();
      _micScaleController.forward().then((_) => _micScaleController.reverse());

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isRecording) timer.cancel();
        setState(() => _recordingDuration++);
      });

      _waveformTimer =
          Timer.periodic(const Duration(milliseconds: 120), (timer) {
        if (!_isRecording) timer.cancel();
        _updateWaveform();
      });

      _cancelHintTimer = Timer(const Duration(milliseconds: 1000), () {
        if (_isRecording && !_isLocked) {
          setState(() => _showCancelHint = true);
          _cancelController.forward();
        }
      });

      _lockHintTimer = Timer(const Duration(milliseconds: 500), () {
        if (_isRecording && !_isLocked) {
          setState(() => _showLockHint = true);
          _lockHintController.forward();
          Future.delayed(_hintDisplayDuration, () {
            if (_isRecording && !_isLocked && mounted) {
              setState(() => _showLockHint = false);
              _lockHintController.reverse();
            }
          });
        }
      });
    } catch (e) {
      _showErrorSnackBar('Failed to start recording: $e');
      _resetRecordingState();
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _stopRecording({bool send = true}) async {
    if (!_isRecording || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final audioRecorder = ref.read(audioRecorderProvider);

      _recordingTimer?.cancel();
      _waveformTimer?.cancel();
      _cancelHintTimer?.cancel();
      _lockHintTimer?.cancel();

      _pulseController.stop();
      _slideController.reverse();
      _cancelController.reverse();
      _lockHintController.reverse();

      final path = await audioRecorder.stop();

      if (path != null && _currentRecordingPath != null) {
        if (send &&
            widget.onVoiceMessageSend != null &&
            _recordingDuration >= 1) {
          HapticFeedback.lightImpact();
          widget.onVoiceMessageSend!(path);
        } else {
          HapticFeedback.lightImpact();
          final file = File(path);
          if (await file.exists()) await file.delete();

          if (_recordingDuration < 1 && send) {
            _showErrorSnackBar('Recording too short');
          }
        }
      }

      _resetRecordingState();
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording: $e');
      _resetRecordingState();
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _lockRecording() {
    if (_isLocked || !_isRecording) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isLocked = true;
      _slideX = 0.0;
      _slideY = 0.0;
      _showCancelHint = false;
      _showLockHint = false;
    });

    _lockController.forward();
    _cancelController.reverse();
    _lockHintController.reverse();
  }

 

  void _resetRecordingState() {
    if (mounted) {
      setState(() {
        _isRecording = false;
        _isLocked = false;
        _slideX = 0.0;
        _slideY = 0.0;
        _showCancelHint = false;
        _showLockHint = false;
        _recordingDuration = 0;
        _isCancelZone = false;
      });
    }
    _currentRecordingPath = null;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text(
            'Microphone access is required to record voice messages. Please enable it in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Normal interface
            AnimatedSlide(
              offset:
                  _isRecording && !_isLocked ? const Offset(0, 1) : Offset.zero,
              duration: _animationDuration,
              child: AnimatedOpacity(
                opacity: _isRecording && !_isLocked ? 0.0 : 1.0,
                duration: _animationDuration,
                child: _buildNormalInterface(),
              ),
            ),

            // Recording interface
            if (_isRecording)
              AnimatedSlide(
                offset: Offset.zero,
                duration: _animationDuration,
                child: _buildRecordingInterface(),
              ),

            // Lock indicator
            if (_isRecording && !_isLocked) _buildLockIndicator(),

            // Cancel hint
            if (_showCancelHint && _isRecording && !_isLocked)
              _buildCancelHint(),

            // Lock hint
            if (_showLockHint && _isRecording && !_isLocked) _buildLockHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalInterface() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildAttachmentDeleteButton(),
        Expanded(child: _buildInputField()),
        const SizedBox(width: 8),
        _buildMicSendButton(),
      ],
    );
  }

  Widget _buildAttachmentDeleteButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: _isRecording && _isLocked
          ? GestureDetector(
              key: const ValueKey('delete'),
              onTap: () => _stopRecording(send: false),
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
              ),
            )
          : GestureDetector(
              key: const ValueKey('attachment'),
              onTap: () => HapticFeedback.lightImpact(),
              child: Container(
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
                  size: 22,
                ),
              ),
            ),
    );
  }

  Widget _buildRecordingInterface() {
    return Row(
      children: [
        if (!_isLocked)
          AnimatedScale(
            scale: _isCancelZone ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isCancelZone
                    ? Colors.red.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: _isCancelZone
                    ? Border.all(color: Colors.red.withOpacity(0.5))
                    : null,
              ),
              child: Icon(
                Icons.delete_outline,
                color: _isCancelZone
                    ? Colors.red
                    : Colors.grey[400],
                size: 24,
              ),
            ),
          ),
        if (!_isLocked) const SizedBox(width: 8),
        Expanded(
          child: Transform.translate(
            offset: Offset(_isLocked ? 0.0 : _slideX.clamp(-60.0, 0.0), 0),
            child: Container(
              height: _recordingBubbleHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildRecordingContent(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _buildRecordingActionButton(),
      ],
    );
  }

  Widget _buildRecordingContent() {
    return Row(
      children: [
        const SizedBox(width: 16),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
        Text(
          _formatDuration(_recordingDuration),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildWaveform()),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildRecordingActionButton() {
    if (_isLocked) {
      return GestureDetector(
        onTap: () => _stopRecording(send: true),
        child: Container(
          width: _micButtonSize,
          height: _micButtonSize,
          decoration: const BoxDecoration(
            color: AiTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.send, color: Colors.white, size: 22),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(_slideX.clamp(-40.0, 0.0), _slideY.clamp(-80.0, 0.0)),
      child: AnimatedBuilder(
        animation: _micScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _micScaleAnimation.value,
            child: Container(
              width: _micButtonSize,
              height: _micButtonSize,
              decoration: BoxDecoration(
                color: AiTheme.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AiTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLockIndicator() {
    final lockProgress = (_slideY.abs() / _lockThreshold).clamp(0.0, 1.0);
    final isNearLock = _slideY < -_lockThreshold * 0.8;

    return Positioned(
      right: 24,
      bottom: 70 + _slideY.clamp(-_lockThreshold, 0.0),
      child: AnimatedOpacity(
        opacity: lockProgress,
        duration: const Duration(milliseconds: 50),
        child: AnimatedScale(
          scale: isNearLock ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isNearLock
                  ? AiTheme.primaryColor.withOpacity(0.15)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isNearLock ? AiTheme.primaryColor : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.lock,
              size: 18,
              color: isNearLock ? AiTheme.primaryColor : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelHint() {
    return Positioned(
      left: 16,
      bottom: 70,
      child: AnimatedBuilder(
        animation: _cancelAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _cancelAnimation.value * 0.7,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - _cancelAnimation.value)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Slide to cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLockHint() {
    return Positioned(
      right: 24,
      bottom: 70,
      child: AnimatedBuilder(
        animation: _lockHintAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _lockHintAnimation.value * 0.7,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - _lockHintAnimation.value)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Slide up to lock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]!
                : Colors.grey[300]!),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled && !_isRecording,
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
      onLongPressMoveUpdate: _hasText ||
              widget.isLoading ||
              !_isRecording ||
              _isLocked
          ? null
          : (details) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final startPosition = renderBox.size.width - _micButtonSize / 2;
              final currentPosition =
                  renderBox.globalToLocal(details.globalPosition);

              final newSlideX =
                  (currentPosition.dx - startPosition).clamp(-200.0, 0.0);
              final newSlideY =
                  (currentPosition.dy - _micButtonSize).clamp(-120.0, 50.0);

              setState(() {
                _slideX = newSlideX;
                _slideY = newSlideY;
              });

              // Check for entering/leaving the cancel zone
              final isInCancelZone = newSlideX < -_cancelThreshold;
              if (isInCancelZone != _isCancelZone) {
                setState(() => _isCancelZone = isInCancelZone);
                HapticFeedback.mediumImpact();
              }

              // Check for locking
              if (_slideY < -_lockThreshold) {
                _lockRecording();
              }
            },
      onLongPressUp: _hasText || widget.isLoading
          ? null
          : () {
              if (_isRecording && !_isLocked) {
                // If in cancel zone, cancel. Otherwise, send.
                _stopRecording(send: !_isCancelZone);
              }
            },
      child: Container(
        width: _micButtonSize,
        height: _micButtonSize,
        decoration: BoxDecoration(
          color: AiTheme.primaryColor,
          borderRadius: BorderRadius.circular(_micButtonSize / 2),
          boxShadow: [
            BoxShadow(
              color: AiTheme.primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_micButtonSize / 2),
          onTap: _hasText && !_isRecording
              ? () => _handleSubmit(widget.controller.text)
              : null,
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
                    size: 22,
                  ),
          ),
        ),
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
          children: _waveformData.asMap().entries.map((entry) {
            final index = entry.key;
            final height = entry.value;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              width: 2.5,
              height: height * 24 + 6,
              margin: const EdgeInsets.symmetric(horizontal: 0.8),
              decoration: BoxDecoration(
                color: AiTheme.primaryColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(1.5),
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
        !_isRecording &&
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
