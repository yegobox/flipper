import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker
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
  final Function(String)? onAttachFile; // New callback for file attachments
  final String? attachedFilePath; // New parameter to display attached file
  final VoidCallback?
      onClearAttachedFile; // New callback to clear attached file
  final String? hintText;
  final bool enabled;

  const AiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    this.onAttachFile,
    this.attachedFilePath,
    this.onClearAttachedFile,
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
  bool _lockJustHappened = false;
  bool _showRecordingTip = false;
  double _slideX = 0.0;
  double _slideY = 0.0;
  Timer? _recordingTimer;
  Timer? _waveformTimer;
  Timer? _cancelHintTimer;
  Timer? _lockHintTimer;
  Timer? _tipTimer;
  Timer? _lockHintHideTimer;
  Timer? _recordingTipHideTimer;
  int _recordingDuration = 0;
  List<double> _waveformData = [];
  String? _currentRecordingPath;
  double _recordingAmplitude = 0.0;

  // Enhanced Animation controllers
  late AnimationController _pulseController;
  late AnimationController _lockController;
  late AnimationController _waveController;
  late AnimationController _slideController;
  late AnimationController _cancelController;
  late AnimationController _micScaleController;
  late AnimationController _lockHintController;
  late AnimationController _breathingController;
  late AnimationController _rippleController;
  late AnimationController _bounceController;
  late AnimationController _tipController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _cancelAnimation;
  late Animation<double> _micScaleAnimation;
  late Animation<double> _lockHintAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _tipAnimation;

  // Enhanced Layout constants
  static const double _cancelThreshold = 120.0;
  static const double _lockThreshold = 90.0;
  static const double _micButtonSize = 44.0;
  static const double _recordingBubbleHeight = 44.0;
  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const Duration _fastAnimationDuration = Duration(milliseconds: 150);
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
    // Existing controllers
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _lockController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _cancelController = AnimationController(
      duration: _fastAnimationDuration,
      vsync: this,
    );
    _micScaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _lockHintController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    // New enhanced controllers
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _tipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Enhanced animations
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _cancelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cancelController, curve: Curves.easeInOut),
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _micScaleController, curve: Curves.elasticOut),
    );
    _lockHintAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lockHintController, curve: Curves.easeInOut),
    );
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
    _tipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tipController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _focusNode.onKeyEvent = null;
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();

    // Cancel all timers before disposing controllers
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    _cancelHintTimer?.cancel();
    _lockHintTimer?.cancel();
    _tipTimer?.cancel();
    _lockHintHideTimer?.cancel();
    _recordingTipHideTimer?.cancel();

    // Dispose all controllers
    _pulseController.dispose();
    _lockController.dispose();
    _waveController.dispose();
    _slideController.dispose();
    _cancelController.dispose();
    _micScaleController.dispose();
    _lockHintController.dispose();
    _breathingController.dispose();
    _rippleController.dispose();
    _bounceController.dispose();
    _tipController.dispose();

    super.dispose();
  }

  void _generateWaveform() {
    final random = math.Random();
    _waveformData = List.generate(20, (index) {
      final baseHeight = random.nextDouble() * 0.9 + 0.1;
      final variation = math.sin(index * 0.7 + _recordingAmplitude) * 0.4;
      return (baseHeight + variation).clamp(0.1, 1.0);
    });
  }

  void _updateWaveform() {
    if (!_isRecording) return;

    // Simulate amplitude changes
    _recordingAmplitude += 0.2;
    setState(() => _generateWaveform());
    _waveController.forward().then((_) => _waveController.reset());
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _bounceController.forward().then((_) => _bounceController.reset());
      }
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
        _recordingAmplitude = 0.0;
      });

      // Enhanced animation sequence
      _pulseController.repeat(reverse: true);
      _breathingController.repeat(reverse: true);
      _rippleController.repeat();
      _slideController.forward();
      _micScaleController.forward().then((_) => _micScaleController.reverse());

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isRecording) timer.cancel();
        setState(() => _recordingDuration++);
      });

      _waveformTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!_isRecording) timer.cancel();
        _updateWaveform();
      });

      // Show enhanced hints with better timing
      _cancelHintTimer = Timer(const Duration(milliseconds: 800), () {
        if (_isRecording && !_isLocked) {
          setState(() => _showCancelHint = true);
          _cancelController.forward();
        }
      });

      _lockHintTimer = Timer(const Duration(milliseconds: 600), () {
        if (_isRecording && !_isLocked) {
          setState(() => _showLockHint = true);
          _lockHintController.forward();
          _lockHintHideTimer = Timer(_hintDisplayDuration, () {
            if (_isRecording && !_isLocked && mounted) {
              setState(() => _showLockHint = false);
              _lockHintController.reverse();
            }
          });
        }
      });

      // Show recording tip for first-time users
      _tipTimer = Timer(const Duration(milliseconds: 1500), () {
        if (_isRecording && !_isLocked && mounted) {
          setState(() => _showRecordingTip = true);
          _tipController.forward();
          _recordingTipHideTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() => _showRecordingTip = false);
              _tipController.reverse();
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

      // Cancel all timers
      _recordingTimer?.cancel();
      _waveformTimer?.cancel();
      _cancelHintTimer?.cancel();
      _lockHintTimer?.cancel();
      _tipTimer?.cancel();
      _lockHintHideTimer?.cancel();
      _recordingTipHideTimer?.cancel();

      // Stop all animations
      _pulseController.stop();
      _breathingController.stop();
      _rippleController.stop();
      _slideController.reverse();
      _cancelController.reverse();
      _lockHintController.reverse();
      _tipController.reverse();

      final path = await audioRecorder.stop();

      if (path != null && _currentRecordingPath != null) {
        if (send && _recordingDuration >= 1) {
          // Validate audio file before sending
          final audioFile = File(path);
          if (await _validateAudioFile(audioFile)) {
            HapticFeedback.lightImpact();
            // Format the voice message and send it through the main onSend callback
            widget.onSend('[voice]($path)');
            _showSuccessSnackBar('Voice message sent!');
          } else {
            _showErrorSnackBar('Audio file is corrupted or incomplete');
            if (await audioFile.exists()) await audioFile.delete();
          }
        } else {
          HapticFeedback.lightImpact();
          final file = File(path);
          if (await file.exists()) await file.delete();

          if (_recordingDuration < 1 && send) {
            _showErrorSnackBar('Recording too short (minimum 1 second)');
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
      _isCancelZone = false;
      _lockJustHappened = true;
    });

    _lockController.forward();
    _cancelController.reverse();
    _lockHintController.reverse();

    // Enhanced feedback for lock
    _bounceController.forward().then((_) => _bounceController.reset());

    Future.delayed(const Duration(milliseconds: 100), () {
      _lockJustHappened = false;
    });
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
        _showRecordingTip = false;
        _recordingDuration = 0;
        _isCancelZone = false;
        _recordingAmplitude = 0.0;
      });
    }
    _currentRecordingPath = null;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mic_none, color: AiTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Microphone Permission'),
          ],
        ),
        content: const Text(
          'Microphone access is required to record voice messages. Please enable it in your device settings.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AiTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickFile() async {
    if (widget.onAttachFile == null) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'xlsx', 'xls'], // Allow PDF and Excel files
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        widget.onAttachFile!(filePath);
      }
      // User canceled the picker - no action needed
    } catch (e) {
      _showErrorSnackBar('Error picking file: $e');
    }
  }

  Future<bool> _validateAudioFile(File audioFile) async {
    try {
      // Check if file exists
      if (!await audioFile.exists()) return false;

      // Check file size (minimum 1KB for valid audio)
      final fileSize = await audioFile.length();
      if (fileSize < 1024) return false;

      // Basic header validation for common audio formats
      final bytes = await audioFile.readAsBytes();
      if (bytes.isEmpty) return false;

      // Check for valid audio file headers
      final header = bytes.take(12).toList();

      // AAC/M4A file validation (starts with specific bytes)
      if (header.length >= 4) {
        // Check for ftyp box (MP4/M4A container)
        if (header[4] == 0x66 &&
            header[5] == 0x74 &&
            header[6] == 0x79 &&
            header[7] == 0x70) {
          return true;
        }
      }

      return fileSize > 1024; // Fallback: accept if file size is reasonable
    } catch (e) {
      return false;
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -4),
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

            // Enhanced lock indicator
            if (_isRecording && !_isLocked) _buildEnhancedLockIndicator(),

            // Enhanced cancel hint
            if (_showCancelHint && _isRecording && !_isLocked)
              _buildEnhancedCancelHint(),

            // Enhanced lock hint
            if (_showLockHint && _isRecording && !_isLocked)
              _buildEnhancedLockHint(),

            // Recording tip
            if (_showRecordingTip && _isRecording && !_isLocked)
              _buildRecordingTip(),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalInterface() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildEnhancedAttachmentDeleteButton(),
        const SizedBox(width: 8),
        Expanded(child: _buildEnhancedInputField()),
        const SizedBox(width: 8),
        _buildEnhancedMicSendButton(),
      ],
    );
  }

  Widget _buildEnhancedAttachmentDeleteButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: RotationTransition(
            turns: animation,
            child: child,
          ),
        );
      },
      child: _isRecording && _isLocked
          ? GestureDetector(
              key: const ValueKey('delete'),
              onTap: () => _stopRecording(send: false),
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red[400]!, Colors.red[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            )
          : GestureDetector(
              key: const ValueKey('attachment'),
              onTap: _pickFile, // Call _pickFile on tap
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AiTheme.primaryColor,
                      AiTheme.primaryColor.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: AiTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
        if (!_isLocked) _buildEnhancedCancelZone(),
        if (!_isLocked) const SizedBox(width: 12),
        Expanded(
          child: Transform.translate(
            offset: Offset(_isLocked ? 0.0 : _slideX.clamp(-80.0, 0.0), 0),
            child: Container(
              height: _recordingBubbleHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [Colors.grey[800]!, Colors.grey[750]!]
                      : [Colors.grey[50]!, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(27),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : Colors.grey[200]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildEnhancedRecordingContent(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildEnhancedRecordingActionButton(),
      ],
    );
  }

  Widget _buildEnhancedCancelZone() {
    return AnimatedScale(
      scale: _isCancelZone ? 1.3 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _isCancelZone
              ? Colors.red.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          border: _isCancelZone
              ? Border.all(color: Colors.red.withValues(alpha: 0.4), width: 2)
              : Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
        ),
        child: AnimatedRotation(
          turns: _isCancelZone ? 0.1 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.delete_outline,
            color: _isCancelZone ? Colors.red[600] : Colors.grey[400],
            size: _isCancelZone ? 28 : 24,
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedRecordingContent() {
    return Row(
      children: [
        const SizedBox(width: 20),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Text(
          _formatDuration(_recordingDuration),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(child: _buildEnhancedWaveform()),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildEnhancedRecordingActionButton() {
    final Widget button;
    if (_isLocked) {
      button = AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_bounceAnimation.value * 0.1),
            child: GestureDetector(
              onTap: () => _stopRecording(send: true),
              child: Container(
                width: _micButtonSize,
                height: _micButtonSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AiTheme.primaryColor,
                      AiTheme.primaryColor.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AiTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          );
        },
      );
    } else {
      button = AnimatedBuilder(
        animation: Listenable.merge(
            [_micScaleAnimation, _breathingAnimation, _rippleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _micScaleAnimation.value * _breathingAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ripple effect
                Container(
                  width: _micButtonSize * (1 + _rippleAnimation.value * 0.8),
                  height: _micButtonSize * (1 + _rippleAnimation.value * 0.8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AiTheme.primaryColor.withValues(
                        alpha: 0.3 * (1 - _rippleAnimation.value),
                      ),
                      width: 2,
                    ),
                  ),
                ),
                // Main button
                Container(
                  width: _micButtonSize,
                  height: _micButtonSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AiTheme.primaryColor,
                        AiTheme.primaryColor.withValues(alpha: 0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AiTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(
        _slideX.clamp(-60.0, 0.0),
        _slideY.clamp(-100.0, 0.0),
        0,
      ),
      child: button,
    );
  }

  Widget _buildEnhancedLockIndicator() {
    final lockProgress = (_slideY.abs() / _lockThreshold).clamp(0.0, 1.0);
    final isNearLock = _slideY < -_lockThreshold * 0.7;

    return Positioned(
      right: 28,
      bottom: 80 + _slideY.clamp(-_lockThreshold, 0.0),
      child: AnimatedOpacity(
        opacity: lockProgress * 0.9,
        duration: const Duration(milliseconds: 50),
        child: AnimatedScale(
          scale: isNearLock ? 1.4 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: isNearLock
                  ? LinearGradient(
                      colors: [
                        AiTheme.primaryColor.withValues(alpha: 0.2),
                        AiTheme.primaryColor.withValues(alpha: 0.1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey[200]!, Colors.grey[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: isNearLock ? AiTheme.primaryColor : Colors.grey[400]!,
                width: isNearLock ? 2.5 : 2,
              ),
              boxShadow: isNearLock
                  ? [
                      BoxShadow(
                        color: AiTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: AnimatedRotation(
              turns: isNearLock ? 0.1 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.lock,
                size: isNearLock ? 22 : 20,
                color: isNearLock ? AiTheme.primaryColor : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedCancelHint() {
    return Positioned(
      left: 20,
      bottom: 85,
      child: AnimatedBuilder(
        animation: _cancelAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _cancelAnimation.value * 0.85,
            child: Transform.translate(
              offset: Offset(-20 * (1 - _cancelAnimation.value),
                  15 * (1 - _cancelAnimation.value)),
              child: Transform.scale(
                scale: 0.8 + (_cancelAnimation.value * 0.2),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.7)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Slide to cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedLockHint() {
    return Positioned(
      right: 20,
      bottom: 85,
      child: AnimatedBuilder(
        animation: _lockHintAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _lockHintAnimation.value * 0.85,
            child: Transform.translate(
              offset: Offset(20 * (1 - _lockHintAnimation.value),
                  15 * (1 - _lockHintAnimation.value)),
              child: Transform.scale(
                scale: 0.8 + (_lockHintAnimation.value * 0.2),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.7)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Slide up to lock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecordingTip() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 140,
      child: AnimatedBuilder(
        animation: _tipAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _tipAnimation.value * 0.9,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - _tipAnimation.value)),
              child: Transform.scale(
                scale: 0.7 + (_tipAnimation.value * 0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AiTheme.primaryColor.withValues(alpha: 0.9),
                          AiTheme.primaryColor.withValues(alpha: 0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AiTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tips_and_updates,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Hold & slide to control recording',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedInputField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? LinearGradient(
                colors: [Colors.grey[800]!, Colors.grey[750]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, Colors.grey[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _focusNode.hasFocus
              ? AiTheme.primaryColor.withValues(alpha: 0.3)
              : (Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]!
                  : Colors.grey[300]!),
          width: _focusNode.hasFocus ? 1.5 : 1,
        ),
        boxShadow: _focusNode.hasFocus
            ? [
                BoxShadow(
                  color: AiTheme.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
            horizontal: 18,
            vertical: 12,
          ),
        ),
        style: const TextStyle(fontSize: 16),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildEnhancedMicSendButton() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_bounceAnimation.value * 0.1),
          child: GestureDetector(
            key: _micButtonKey,
            onLongPressStart: _hasText || widget.isLoading
                ? null
                : (details) => _startRecording(),
            onLongPressMoveUpdate: _hasText ||
                    widget.isLoading ||
                    !_isRecording ||
                    _isLocked
                ? null
                : (details) {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final localPosition =
                        renderBox.globalToLocal(details.globalPosition);
                    final buttonCenterX =
                        renderBox.size.width - _micButtonSize / 2;
                    final buttonCenterY = _micButtonSize / 2;

                    final newSlideX =
                        (localPosition.dx - buttonCenterX).clamp(-250.0, 0.0);
                    final newSlideY =
                        (localPosition.dy - buttonCenterY).clamp(-150.0, 50.0);

                    setState(() {
                      _slideX = newSlideX;
                      _slideY = newSlideY;
                    });

                    // Enhanced cancel zone feedback
                    final isInCancelZone = newSlideX < -_cancelThreshold;
                    if (isInCancelZone != _isCancelZone) {
                      setState(() => _isCancelZone = isInCancelZone);
                      HapticFeedback.mediumImpact();
                    }

                    // Enhanced lock detection
                    if (_slideY < -_lockThreshold) {
                      _lockRecording();
                    }
                  },
            onLongPressUp: _hasText || widget.isLoading
                ? null
                : () {
                    if (_lockJustHappened) {
                      _lockJustHappened = false;
                      return;
                    }
                    if (_isRecording && !_isLocked) {
                      _stopRecording(send: !_isCancelZone);
                    }
                  },
            child: Container(
              width: _micButtonSize,
              height: _micButtonSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AiTheme.primaryColor,
                    AiTheme.primaryColor.withValues(alpha: 0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(_micButtonSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: AiTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _hasText ? Icons.send : Icons.mic,
                            color: Colors.white,
                            size: 24,
                            key: ValueKey(_hasText),
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedWaveform() {
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
              duration: Duration(milliseconds: 80 + (index * 10)),
              width: 2.0,
              height: height * 28 + 8,
              margin: const EdgeInsets.symmetric(horizontal: 0.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AiTheme.primaryColor.withValues(alpha: 0.9),
                    AiTheme.primaryColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                    color: AiTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
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
