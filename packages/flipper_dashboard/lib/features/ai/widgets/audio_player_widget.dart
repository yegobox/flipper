import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? height;
  final bool showFileName;
  final VoidCallback? onPlaybackComplete;
  final Function(String)? onError;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.primaryColor,
    this.backgroundColor,
    this.height,
    this.showFileName = false,
    this.onPlaybackComplete,
    this.onError,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // State variables
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  Duration? _duration;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  // Subscriptions
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;

  // Animation controllers
  late AnimationController _playButtonController;
  late AnimationController _loadingController;

  // Disposal flag
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initAudioPlayer();
  }

  void _initAnimations() {
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  Future<void> _initAudioPlayer() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Validate file exists
      final file = File(widget.audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found');
      }

      // Set the audio source and wait for it to load
      final source = AudioSource.uri(Uri.file(widget.audioPath));
      _duration = await _audioPlayer.setAudioSource(source);

      if (!mounted) return;

      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (mounted && !_isDisposed) {
          setState(() {
            _isPlaying = state.playing;
            _isLoading = state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering;
          });

          // Handle play/pause animation
          if (state.playing) {
            _playButtonController.forward();
          } else {
            _playButtonController.reverse();
          }

          // Handle playback completion
          if (state.processingState == ProcessingState.completed) {
            _handlePlaybackComplete();
          }
        }
      });

      // Listen to position changes with throttling
      _positionSubscription = _audioPlayer.positionStream
          .throttleTime(const Duration(milliseconds: 100))
          .listen((position) {
        if (mounted && !_isDisposed) {
          setState(() {
            _position = position;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Failed to load audio: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    if (_isDisposed) return;
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _isLoading = false;
    });
    widget.onError?.call(message);
  }

  void _handlePlaybackComplete() {
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.pause();
    widget.onPlaybackComplete?.call();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _playButtonController.dispose();
    _loadingController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_hasError) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
    } catch (e) {
      _handleError('Playback error: ${e.toString()}');
    }
  }

  Future<void> _seekToPosition(double value) async {
    if (_duration == null || _hasError) return;

    try {
      final newPosition = _duration! * value;
      await _audioPlayer.seek(newPosition);
    } catch (e) {
      _handleError('Seek error: ${e.toString()}');
    }
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    if (_hasError || _isDisposed) return;

    try {
      await _audioPlayer.setSpeed(speed);
      if (!_isDisposed) {
        setState(() {
          _playbackSpeed = speed;
        });
      }
    } catch (e) {
      _handleError('Speed change error: ${e.toString()}');
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }
    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  String _getFileName() {
    return widget.audioPath.split('/').last.replaceAll(RegExp(r'\.[^.]*$'), '');
  }

  Widget _buildPlayButton() {
    if (_isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: RotationTransition(
          turns: _loadingController,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_hasError) {
      return const Icon(Icons.error, color: Colors.red);
    }

    return AnimatedIcon(
      icon: AnimatedIcons.play_pause,
      progress: _playButtonController,
      size: 28,
    );
  }

  Widget _buildSpeedControl() {
    return PopupMenuButton<double>(
      icon: Text(
        '${_playbackSpeed}x',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      onSelected: _setPlaybackSpeed,
      itemBuilder: (context) => [
        const PopupMenuItem(value: 0.5, child: Text('0.5x')),
        const PopupMenuItem(value: 0.75, child: Text('0.75x')),
        const PopupMenuItem(value: 1.0, child: Text('1.0x')),
        const PopupMenuItem(value: 1.25, child: Text('1.25x')),
        const PopupMenuItem(value: 1.5, child: Text('1.5x')),
        const PopupMenuItem(value: 2.0, child: Text('2.0x')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_duration?.inMilliseconds ?? 0) > 0
        ? (_position.inMilliseconds / _duration!.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    final backgroundColor = widget.backgroundColor ??
        (theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200]);

    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;

    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showFileName) ...[
            Text(
              _getFileName(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              IconButton(
                icon: _buildPlayButton(),
                onPressed: _hasError ? null : _togglePlayPause,
                color: theme.textTheme.bodyLarge?.color,
                iconSize: 32,
              ),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: _hasError ? null : _seekToPosition,
                        activeColor: primaryColor,
                        inactiveColor: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _formatDuration(_duration ?? Duration.zero),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildSpeedControl(),
            ],
          ),
          if (_hasError) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.red,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
