import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/ai_theme.dart';
import 'package:flipper_services/keyboard_service.dart';

class AiInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Function(String) onSend;
  final String? hintText;
  final int maxLines;
  final bool showAttachButton;
  final VoidCallback? onAttachPressed;
  final bool enabled;
  final String? errorText;

  const AiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    this.hintText = 'Type your message...',
    this.maxLines = 6,
    this.showAttachButton = false,
    this.onAttachPressed,
    this.enabled = true,
    this.errorText,
  });

  @override
  State<AiInputField> createState() => _AiInputFieldState();
}

class _AiInputFieldState extends State<AiInputField>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late AnimationController _buttonAnimationController;
  late AnimationController _fieldAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Color?> _borderColorAnimation;

  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupListeners();
    _hasText = widget.controller.text.isNotEmpty;
  }

  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fieldAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.elasticOut,
    ));

    _borderColorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: AiTheme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _fieldAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupListeners() {
    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    _buttonAnimationController.dispose();
    _fieldAnimationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _fieldAnimationController.forward();
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    } else {
      _fieldAnimationController.reverse();
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (hasText) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      KeyboardService.handleKeyDown(event);
      if (KeyboardService.shouldSendMessage()) {
        _handleSubmit(widget.controller.text);
      }
    } else if (event is KeyUpEvent) {
      KeyboardService.handleKeyUp(event);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AiTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.errorText != null) _buildErrorBanner(),
          _buildInputRow(),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade50,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.showAttachButton) ...[
            _buildAttachButton(),
            const SizedBox(width: 12),
          ],
          Expanded(child: _buildInputField()),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildAttachButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        icon: Icon(
          Icons.attach_file,
          color: AiTheme.secondaryColor,
          size: 20,
        ),
        onPressed: widget.enabled ? widget.onAttachPressed : null,
        tooltip: 'Attach file',
      ),
    );
  }

  Widget _buildInputField() {
    return AnimatedBuilder(
      animation: _borderColorAnimation,
      builder: (context, child) {
        return Container(
          constraints: const BoxConstraints(
            minHeight: 44,
            maxHeight: 120,
          ),
          decoration: BoxDecoration(
            color: widget.enabled
                ? AiTheme.surfaceColor
                : AiTheme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red.shade400
                  : _borderColorAnimation.value ?? Colors.grey.shade300,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AiTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AiTheme.secondaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
            maxLines: widget.maxLines,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _handleSubmit(widget.controller.text),
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _hasText ? _buttonScaleAnimation.value : 0.8,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _canSend()
                  ? AiTheme.primaryColor
                  : AiTheme.inputBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: _canSend()
                  ? [
                      BoxShadow(
                        color: AiTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: IconButton(
              icon: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          AiTheme.surfaceColor,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: _canSend()
                          ? AiTheme.surfaceColor
                          : AiTheme.secondaryColor,
                      size: 20,
                    ),
              onPressed: _canSend()
                  ? () => _handleSubmit(widget.controller.text)
                  : null,
              tooltip: 'Send message',
            ),
          ),
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
      // Add haptic feedback for better UX
      HapticFeedback.lightImpact();

      final trimmedText = text.trim();
      widget.onSend(trimmedText);
      widget.controller.clear();

      // Reset animations
      _buttonAnimationController.reset();
      _hasText = false;

      // Keep focus on the input field
      _focusNode.requestFocus();
    }
  }
}
